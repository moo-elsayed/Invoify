import PDFDocument from 'pdfkit';
import { storage } from '../config/firebase';

export interface InvoiceItem {
  itemId?: string;
  name?: string;
  description?: string;
  quantity: number;
  unitPrice?: number;
  price?: number;
  totalPrice?: number;
}

export interface InvoiceData {
  invoiceId: string;
  userId: string;
  clientName: string;
  clientEmail?: string;
  clientAddress?: string;
  businessName?: string;
  items: InvoiceItem[];
  taxRate: number;
  discount: number;
  totalAmount: number;
  currency: string;
  dueDate: any;
  createdAt: any;
}

export async function generateInvoicePdfAndUpload(invoice: InvoiceData): Promise<string> {
  return new Promise((resolve, reject) => {
    try {
      console.log(`[pdfGenerator] Starting PDF generation for invoice #${invoice.invoiceId}`);
      const doc = new PDFDocument({ margin: 50 });
      const buffers: Buffer[] = [];

      doc.on('data', (chunk) => buffers.push(chunk));
      doc.on('error', (err) => {
        console.error('[pdfGenerator] PDFKit stream error:', err);
        reject(err);
      });

      doc.on('end', async () => {
        try {
          console.log(`[pdfGenerator] PDF stream ended. Compiling buffer (${buffers.length} chunks)...`);
          const pdfBuffer = Buffer.concat(buffers);

          let bucket;
          try {
            bucket = storage.bucket();
          } catch (bErr) {
            console.warn('[pdfGenerator] Default storage.bucket() failed, falling back to invoify-7757d.firebasestorage.app');
            bucket = storage.bucket('invoify-7757d.firebasestorage.app');
          }

          const filePath = `invoices/${invoice.userId}/${invoice.invoiceId}.pdf`;
          const file = bucket.file(filePath);

          console.log(`[pdfGenerator] Saving PDF buffer to Storage path: ${filePath}`);
          await file.save(pdfBuffer, {
            contentType: 'application/pdf',
            metadata: {
              metadata: {
                invoiceId: invoice.invoiceId,
              },
            },
          });

          // Make the file publicly accessible or get signed URL
          let publicUrl = `https://storage.googleapis.com/${bucket.name}/${filePath}`;
          try {
            await file.makePublic();
            console.log(`[pdfGenerator] File made public successfully: ${publicUrl}`);
          } catch (aclErr) {
            console.warn(`[pdfGenerator] file.makePublic() skipped (uniform bucket access):`, aclErr);
            try {
              const [signedUrl] = await file.getSignedUrl({
                action: 'read',
                expires: '01-01-2099',
              });
              publicUrl = signedUrl;
              console.log(`[pdfGenerator] Fallback signed URL generated: ${publicUrl}`);
            } catch (signedErr) {
              console.error(`[pdfGenerator] file.getSignedUrl failed:`, signedErr);
            }
          }

          resolve(publicUrl);
        } catch (err) {
          console.error('[pdfGenerator] Error inside doc.on(end):', err);
          reject(err);
        }
      });

      // --- PDF Content Generation ---
      const primaryColor = '#4F46E5'; // Indigo
      const textColor = '#1F2937';
      const currencyStr = invoice.currency || 'EGP';

      // Header
      doc.fillColor(primaryColor).fontSize(26).text('INVOICE', 50, 45);
      doc.fillColor(textColor).fontSize(10).text(`Invoice ID: #${invoice.invoiceId}`, 50, 75);

      const businessName = invoice.businessName || 'Invoify Merchant';
      doc.fontSize(12).fillColor(textColor).text(businessName, 350, 45, { align: 'right' });

      doc.moveDown();
      doc.strokeColor('#E5E7EB').lineWidth(1).moveTo(50, 100).lineTo(550, 100).stroke();

      // Bill To & Dates
      const startY = 120;
      doc.fontSize(10).fillColor('#6B7280').text('BILL TO:', 50, startY);
      doc.fontSize(11).fillColor(textColor).text(invoice.clientName, 50, startY + 15);
      if (invoice.clientEmail) {
        doc.fontSize(9).fillColor('#6B7280').text(invoice.clientEmail, 50, startY + 30);
      }
      if (invoice.clientAddress) {
        doc.fontSize(9).fillColor('#6B7280').text(invoice.clientAddress, 50, startY + 42);
      }

      // Safe Date Parsing
      let formattedDueDate = 'N/A';
      try {
        if (invoice.dueDate && typeof invoice.dueDate.toDate === 'function') {
          formattedDueDate = invoice.dueDate.toDate().toLocaleDateString('en-US');
        } else if (invoice.dueDate) {
          const d = new Date(invoice.dueDate);
          if (!isNaN(d.getTime())) {
            formattedDueDate = d.toLocaleDateString('en-US');
          }
        }
      } catch (dErr) {
        formattedDueDate = 'N/A';
      }

      doc.fontSize(10).fillColor('#6B7280').text('DUE DATE:', 350, startY, { align: 'right' });
      doc.fontSize(11).fillColor(textColor).text(formattedDueDate, 350, startY + 15, { align: 'right' });

      // Table Header
      const tableTop = 200;
      doc.fillColor('#F3F4F6').rect(50, tableTop, 500, 24).fill();
      doc.fillColor('#374151').fontSize(10);
      doc.text('Description', 60, tableTop + 7);
      doc.text('Qty', 320, tableTop + 7, { width: 50, align: 'right' });
      doc.text('Price', 380, tableTop + 7, { width: 70, align: 'right' });
      doc.text('Amount', 460, tableTop + 7, { width: 80, align: 'right' });

      let currentY = tableTop + 30;

      // Table Rows
      if (Array.isArray(invoice.items)) {
        invoice.items.forEach((item) => {
          const name = item.name || item.description || 'Item';
          const price = Number(item.unitPrice ?? item.price ?? 0);
          const qty = Number(item.quantity ?? 1);
          const itemTotal = qty * price;

          doc.fillColor(textColor).fontSize(10);
          doc.text(name, 60, currentY);
          doc.text(qty.toString(), 320, currentY, { width: 50, align: 'right' });
          doc.text(`${price.toFixed(2)} ${currencyStr}`, 380, currentY, { width: 70, align: 'right' });
          doc.text(`${itemTotal.toFixed(2)} ${currencyStr}`, 460, currentY, { width: 80, align: 'right' });

          currentY += 22;
        });
      }

      doc.strokeColor('#E5E7EB').lineWidth(1).moveTo(50, currentY).lineTo(550, currentY).stroke();
      currentY += 15;

      // Totals Summary
      doc.fontSize(10).fillColor('#6B7280').text('Tax Rate:', 350, currentY, { width: 100, align: 'right' });
      doc.fillColor(textColor).text(`${invoice.taxRate}%`, 460, currentY, { width: 80, align: 'right' });
      currentY += 18;

      doc.fontSize(10).fillColor('#6B7280').text('Discount:', 350, currentY, { width: 100, align: 'right' });
      doc.fillColor(textColor).text(`-${invoice.discount} ${currencyStr}`, 460, currentY, { width: 80, align: 'right' });
      currentY += 22;

      // Total Line
      doc.fillColor(primaryColor).rect(330, currentY, 220, 30).fill();
      doc.fillColor('#FFFFFF').fontSize(12).text('Total Amount:', 340, currentY + 8);
      doc.fillColor('#FFFFFF').fontSize(14).text(`${invoice.totalAmount.toFixed(2)} ${currencyStr}`, 450, currentY + 7, { width: 90, align: 'right' });

      // Footer
      doc.fontSize(9).fillColor('#9CA3AF').text('Thank you for your business!', 50, 720, { align: 'center', width: 500 });

      doc.end();
    } catch (err) {
      console.error('[pdfGenerator] Error in generateInvoicePdfAndUpload setup:', err);
      reject(err);
    }
  });
}
