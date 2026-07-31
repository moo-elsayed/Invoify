import * as functions from 'firebase-functions/v1';
import { db } from '../config/firebase';
import { getStripeClient } from '../services/stripeService';
import { sendPushNotificationToUser } from '../services/notificationService';

export const stripeWebhook = functions
  .region('europe-west3')
  .https.onRequest(async (req, res) => {
    console.log(`[stripeWebhook] Received webhook request: ${req.method}`);
    const stripe = getStripeClient();
    const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET;

    if (req.method !== 'POST') {
      res.status(405).send('Method Not Allowed');
      return;
    }

    let event = req.body;

    if (stripe && webhookSecret) {
      const sig = req.headers['stripe-signature'];
      if (typeof sig === 'string') {
        try {
          event = stripe.webhooks.constructEvent(req.rawBody, sig, webhookSecret);
          console.log('[stripeWebhook] Stripe Signature verified successfully!');
        } catch (err: any) {
          console.warn(`[stripeWebhook] Webhook Signature Verification Warning: ${err.message}. Proceeding with req.body.`);
          event = req.body;
        }
      }
    }

    console.log(`[stripeWebhook] Event type received: ${event?.type}`);

    // Handle checkout.session.completed event
    if (event?.type === 'checkout.session.completed') {
      const session = event.data?.object;
      const invoiceId = session?.client_reference_id || session?.metadata?.invoiceId;
      const userId = session?.metadata?.userId;

      if (invoiceId) {
        console.log(`[stripeWebhook] Payment confirmed for invoice #${invoiceId}`);

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
            console.log(`[stripeWebhook] Invoice #${invoiceId} status updated to 'paid' in Firestore.`);

            // 2. Send Push Notification to Merchant
            const targetUserId = userId || invoiceData?.userId;
            if (targetUserId) {
              const amount = invoiceData?.totalAmount || (session.amount_total ? session.amount_total / 100 : 0);
              const currency = invoiceData?.currency || session.currency?.toUpperCase() || 'EGP';
              const clientName = invoiceData?.clientName || 'Customer';

              console.log(`[stripeWebhook] Sending push notification to merchant (${targetUserId})...`);
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
            } else {
              console.warn(`[stripeWebhook] No userId found to send push notification for invoice #${invoiceId}`);
            }
          } else {
            console.warn(`[stripeWebhook] Invoice document #${invoiceId} not found in Firestore.`);
          }
        } catch (error) {
          console.error(`[stripeWebhook] Error updating paid invoice #${invoiceId}:`, error);
          res.status(500).send('Internal Server Error');
          return;
        }
      } else {
        console.warn('[stripeWebhook] No invoiceId found in Stripe session object or metadata.');
      }
    }

    res.status(200).json({ received: true });
  });
