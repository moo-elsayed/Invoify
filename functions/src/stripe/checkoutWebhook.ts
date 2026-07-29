import * as functions from 'firebase-functions/v1';
import { db } from '../config/firebase';
import { getStripeClient } from '../services/stripeService';
import { sendPushNotificationToUser } from '../services/notificationService';

export const stripeWebhook = functions
  .region('europe-west3')
  .https.onRequest(async (req, res) => {
  const stripe = getStripeClient();
  const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET;

  if (req.method !== 'POST') {
    res.status(405).send('Method Not Allowed');
    return;
  }

  let event = req.body;

  if (stripe && webhookSecret) {
    const sig = req.headers['stripe-signature'];
    try {
      if (typeof sig === 'string') {
        event = stripe.webhooks.constructEvent(req.rawBody, sig, webhookSecret);
      }
    } catch (err: any) {
      console.error(`Webhook Signature Verification Failed: ${err.message}`);
      res.status(400).send(`Webhook Error: ${err.message}`);
      return;
    }
  }

  // Handle checkout.session.completed event
  if (event.type === 'checkout.session.completed') {
    const session = event.data.object;
    const invoiceId = session.client_reference_id || session.metadata?.invoiceId;
    const userId = session.metadata?.userId;

    if (invoiceId) {
      console.log(`Payment confirmed for invoice #${invoiceId}`);

      try {
        const invoiceRef = db.collection('invoices').doc(invoiceId);
        const invoiceDoc = await invoiceRef.get();

        if (invoiceDoc.exists) {
          const invoiceData = invoiceDoc.data();

          // 1. Update Invoice status to 'paid'
          await invoiceRef.update({
            status: 'paid',
            paidAt: new Date(),
          });

          // 2. Send Push Notification to Merchant
          const targetUserId = userId || invoiceData?.userId;
          if (targetUserId) {
            const amount = invoiceData?.totalAmount || session.amount_total / 100;
            const currency = invoiceData?.currency || session.currency?.toUpperCase() || 'USD';
            const clientName = invoiceData?.clientName || 'Customer';

            await sendPushNotificationToUser({
              userId: targetUserId,
              title: 'Invoice Paid! 💰',
              body: `Received ${amount} ${currency} for Invoice #${invoiceId} from ${clientName}.`,
              data: {
                invoiceId,
                screen: 'invoice_details',
                type: 'payment_received',
              },
            });
          }
        }
      } catch (error) {
        console.error(`Error updating paid invoice #${invoiceId}:`, error);
        res.status(500).send('Internal Server Error');
        return;
      }
    }
  }

  res.status(200).json({ received: true });
});
