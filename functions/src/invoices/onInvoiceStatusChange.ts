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

    const isTargetStatus = afterData.status === 'pending' || afterData.status === 'sent';
    const wasNotTarget = beforeData.status !== 'pending' && beforeData.status !== 'sent';

    if (wasNotTarget && isTargetStatus) {
      console.log(`Processing pending/sent invoice: ${invoiceId}`);

      // Fetch User profile to get businessName and currency if needed
      let businessName = '';
      let userCurrency = 'EGP';
      if (afterData.userId) {
        try {
          const userDoc = await db.collection('users').doc(afterData.userId).get();
          if (userDoc.exists) {
            const uData = userDoc.data();
            businessName = uData?.businessName || '';
            userCurrency = uData?.currency || uData?.preferredCurrency || 'EGP';
          }
        } catch (uErr) {
          console.warn(`Could not fetch user profile for ${afterData.userId}:`, uErr);
        }
      }

      const clientEmail = afterData.client?.email || afterData.clientEmail || '';
      const clientName = afterData.client?.name || afterData.clientName || 'Valued Customer';
      const clientAddress = afterData.client?.address || afterData.clientAddress || '';

      const invoice: InvoiceData = {
        invoiceId,
        userId: afterData.userId,
        clientName,
        clientEmail,
        clientAddress,
        businessName,
        items: afterData.items || [],
        taxRate: afterData.taxRate || 0,
        discount: afterData.discountAmount || afterData.discount || 0,
        totalAmount: afterData.totalAmount || 0,
        currency: afterData.currency || userCurrency || 'EGP',
        dueDate: afterData.dueDate,
        createdAt: afterData.createdAt,
      };

      // 1. Generate & Upload PDF (isolated try-catch)
      let pdfUrl: string | undefined;
      try {
        console.log(`Generating PDF for invoice #${invoiceId}...`);
        pdfUrl = (await generateInvoicePdfAndUpload(invoice)) || undefined;
      } catch (pdfErr) {
        console.error(`Failed to generate PDF for invoice #${invoiceId}:`, pdfErr);
      }

      // 2. Generate Stripe Payment Link (isolated try-catch)
      let stripePaymentLink: string | undefined;
      try {
        console.log(`Generating Stripe link for invoice #${invoiceId}...`);
        stripePaymentLink = (await createStripeCheckoutSession(invoice)) || undefined;
      } catch (stripeErr) {
        console.error(`Failed to generate Stripe link for invoice #${invoiceId}:`, stripeErr);
      }

      // 3. Update Invoice document in Firestore (isolated try-catch)
      try {
        const updateData: Record<string, any> = {};
        if (pdfUrl) updateData.pdfUrl = pdfUrl;
        if (stripePaymentLink) updateData.stripePaymentLink = stripePaymentLink;

        if (Object.keys(updateData).length > 0) {
          await change.after.ref.update(updateData);
        }
      } catch (updErr) {
        console.error(`Failed to update invoice #${invoiceId} document:`, updErr);
      }

      // 4. Send Email to Client (ALWAYS EXECUTES)
      if (clientEmail) {
        console.log(`Sending invoice email to ${clientEmail}...`);
        try {
          await sendInvoiceEmail({
            toEmail: clientEmail,
            clientName: invoice.clientName,
            invoiceId,
            totalAmount: invoice.totalAmount,
            currency: invoice.currency,
            pdfUrl,
            stripePaymentLink,
            businessName,
          });
        } catch (emailErr) {
          console.error(`Error inside sendInvoiceEmail for invoice #${invoiceId}:`, emailErr);
        }
      } else {
        console.warn(`No client email found for invoice #${invoiceId}`);
      }
    }
  });
