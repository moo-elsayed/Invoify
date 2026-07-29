import * as functions from 'firebase-functions/v1';
import { db } from '../config/firebase';

// 1x1 Transparent GIF Buffer
const TRANSPARENT_GIF_BUFFER = Buffer.from(
  'R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7',
  'base64'
);

export const trackEmailOpen = functions
  .region('europe-west3')
  .https.onRequest(async (req, res) => {
  const invoiceId = req.query.invoiceId as string;

  if (invoiceId) {
    try {
      const invoiceRef = db.collection('invoices').doc(invoiceId);
      const doc = await invoiceRef.get();

      if (doc.exists) {
        const currentStatus = doc.data()?.status;
        // Only update if status is currently 'pending'
        if (currentStatus === 'pending') {
          await invoiceRef.update({
            status: 'opened',
            openedAt: new Date(),
          });
          console.log(`Invoice #${invoiceId} status updated to 'opened' via tracking pixel.`);
        }
      }
    } catch (error) {
      console.error(`Error tracking email open for invoice #${invoiceId}:`, error);
    }
  }

  res.writeHead(200, {
    'Content-Type': 'image/gif',
    'Content-Length': TRANSPARENT_GIF_BUFFER.length,
    'Cache-Control': 'no-store, no-cache, must-revalidate, private',
  });
  res.end(TRANSPARENT_GIF_BUFFER);
});
