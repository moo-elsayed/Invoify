import * as functions from 'firebase-functions/v1';
import { db } from '../config/firebase';
import { sendInvoiceEmail } from '../services/emailService';

export const dailyOverdueChecker = functions
  .region('europe-west3')
  .pubsub
  .schedule('0 9 * * *') // Runs daily at 9:00 AM
  .timeZone('UTC')
  .onRun(async (context) => {
    console.log('Running daily overdue invoice checker...');
    const now = new Date();

    try {
      // Query pending and opened invoices past due date
      const snapshot = await db
        .collection('invoices')
        .where('status', 'in', ['pending', 'opened'])
        .where('dueDate', '<', now)
        .get();

      if (snapshot.empty) {
        console.log('No overdue invoices found today.');
        return;
      }

      console.log(`Found ${snapshot.size} overdue invoices. Updating statuses...`);

      const batch = db.batch();

      for (const doc of snapshot.docs) {
        const data = doc.data();
        batch.update(doc.ref, {
          status: 'overdue',
          overdueAt: now,
        });

        const clientEmail = data.client?.email || data.clientEmail;
        const clientName = data.client?.name || data.clientName || 'Customer';

        // Send follow-up reminder email if client email is present
        if (clientEmail) {
          await sendInvoiceEmail({
            toEmail: clientEmail,
            clientName: clientName,
            invoiceId: doc.id,
            totalAmount: data.totalAmount,
            currency: data.currency || 'USD',
            pdfUrl: data.pdfUrl,
            stripePaymentLink: data.stripePaymentLink,
          });
        }
      }

      await batch.commit();
      console.log(`Successfully marked ${snapshot.size} invoices as overdue.`);
    } catch (error) {
      console.error('Error running daily overdue checker:', error);
    }
  });
