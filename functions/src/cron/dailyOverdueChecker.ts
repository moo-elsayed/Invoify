import * as functions from 'firebase-functions/v1';
import { db } from '../config/firebase';
import { sendInvoiceEmail } from '../services/emailService';
import { sendPushNotificationToUser } from '../services/notificationService';

export const dailyOverdueChecker = functions
  .region('europe-west3')
  .pubsub
  .schedule('0 9 * * *') // Runs daily at 9:00 AM UTC
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

        const targetUserId = data.userId;
        let lang = 'ar';
        if (targetUserId) {
          try {
            const userDoc = await db.collection('users').doc(targetUserId).get();
            if (userDoc.exists) {
              lang = userDoc.data()?.languageCode || 'ar';
            }
          } catch (e) {
            lang = 'ar';
          }
        }

        const clientEmail = data.client?.email || data.clientEmail;
        const fallbackClientName = lang === 'ar' ? 'العميل' : 'Customer';
        const clientName = data.client?.name || data.clientName || fallbackClientName;
        const amount = data.totalAmount || 0;
        const currency = data.currency || 'EGP';

        // 1. Send follow-up reminder email if client email is present
        if (clientEmail) {
          await sendInvoiceEmail({
            toEmail: clientEmail,
            clientName: clientName,
            invoiceId: doc.id,
            totalAmount: amount,
            currency: currency,
            pdfUrl: data.pdfUrl,
            stripePaymentLink: data.stripePaymentLink,
          });
        }

        // 2. Send FCM Push Notification to Merchant
        if (targetUserId) {
          try {
            const title = lang === 'ar' ? 'تنبيه فاتورة متأخرة ⚠️' : 'Invoice Overdue Alert ⚠️';
            const body = lang === 'ar'
              ? `الفاتورة #${doc.id} الخاصة بـ ${clientName} بمبلغ ${amount} ${currency} أصبحت متأخرة عن موعد الاستحقاق.`
              : `Invoice #${doc.id} for ${clientName} (${amount} ${currency}) is now past due date.`;

            await sendPushNotificationToUser({
              userId: targetUserId,
              title,
              body,
              data: {
                invoiceId: doc.id,
                screen: 'invoice_details',
                type: 'invoice_overdue',
              },
            });
          } catch (pushErr) {
            console.error(`Error sending overdue push notification for invoice #${doc.id}:`, pushErr);
          }
        }
      }

      await batch.commit();
      console.log(`Successfully marked ${snapshot.size} invoices as overdue.`);
    } catch (error) {
      console.error('Error running daily overdue checker:', error);
    }
  });
