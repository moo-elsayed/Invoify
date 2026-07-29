import * as functions from 'firebase-functions/v1';
import { db } from '../config/firebase';
import { generateInvoicePdfAndUpload, InvoiceData } from '../services/pdfGenerator';
import { createStripeCheckoutSession } from '../services/stripeService';
import { sendInvoiceEmail } from '../services/emailService';

export const onInvoiceStatusChange = functions
  .region('europe-west3')
  .firestore
  .document('invoices/{invoiceId}')
  .onUpdate(async (change, context) => {
    const beforeData = change.before.data();
    const afterData = change.after.data();
    const invoiceId = context.params.invoiceId;

    // Trigger only when status changes to 'pending'
    if (beforeData.status !== 'pending' && afterData.status === 'pending') {
      console.log(`Processing pending invoice: ${invoiceId}`);

      try {
        // Fetch User profile to get businessName if needed
        let businessName = '';
        if (afterData.userId) {
          const userDoc = await db.collection('users').doc(afterData.userId).get();
          if (userDoc.exists) {
            businessName = userDoc.data()?.businessName || '';
          }
        }

        const invoice: InvoiceData = {
          invoiceId,
          userId: afterData.userId,
          clientName: afterData.clientName || 'Valued Customer',
          clientEmail: afterData.clientEmail,
          clientAddress: afterData.clientAddress,
          businessName,
          items: afterData.items || [],
          taxRate: afterData.taxRate || 0,
          discount: afterData.discount || 0,
          totalAmount: afterData.totalAmount || 0,
          currency: afterData.currency || 'USD',
          dueDate: afterData.dueDate,
          createdAt: afterData.createdAt,
        };

        // 1. Generate & Upload PDF
        console.log(`Generating PDF for invoice #${invoiceId}...`);
        const pdfUrl = await generateInvoicePdfAndUpload(invoice);

        // 2. Generate Stripe Payment Link
        console.log(`Generating Stripe link for invoice #${invoiceId}...`);
        const stripePaymentLink = await createStripeCheckoutSession(invoice);

        // 3. Update Invoice document in Firestore
        const updateData: Record<string, any> = {};
        if (pdfUrl) updateData.pdfUrl = pdfUrl;
        if (stripePaymentLink) updateData.stripePaymentLink = stripePaymentLink;

        if (Object.keys(updateData).length > 0) {
          await change.after.ref.update(updateData);
        }

        // 4. Send Email to Client
        if (afterData.clientEmail) {
          await sendInvoiceEmail({
            toEmail: afterData.clientEmail,
            clientName: invoice.clientName,
            invoiceId,
            totalAmount: invoice.totalAmount,
            currency: invoice.currency,
            pdfUrl: pdfUrl || undefined,
            stripePaymentLink: stripePaymentLink || undefined,
            businessName,
          });
        }
      } catch (error) {
        console.error(`Error processing pending invoice #${invoiceId}:`, error);
      }
    }
  });
