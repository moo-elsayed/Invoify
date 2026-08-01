import PDFDocument from 'pdfkit';
// @ts-ignore
import { ArabicShaper } from 'arabic-persian-reshaper';

import { storage } from '../config/firebase';
import { amiriRegularBuffer, amiriBoldBuffer } from '../assets/fonts/amiriFonts';

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

function formatText(text: string | undefined | null): string {
  if (!text) return '';
  const str = String(text).trim();
  const hasArabic = /[\u0600-\u06FF]/.test(str);
  if (!hasArabic) return str;

  try {
    const reshaped = ArabicShaper.convertArabic(str);
    const words = reshaped.split(' ');
    if (words.length > 1) {
      return words.reverse().join(' ');
    }
    return reshaped;
  } catch (e) {
    return str;
  }
}

function drawText(
  doc: PDFKit.PDFDocument,
  text: string | undefined | null,
  x: number,
  y: number,
  options?: PDFKit.Mixins.TextOptions & { isBold?: boolean }
) {
  const isBold = options?.isBold ?? false;
  const str = String(text ?? '').trim();
  if (!str) return;

  const hasArabic = /[\u0600-\u06FF]/.test(str);

  const pdfOptions: PDFKit.Mixins.TextOptions = { ...options };
  delete (pdfOptions as any).isBold;

  if (hasArabic) {
    const formatted = formatText(str);
    doc.font(isBold ? amiriBoldBuffer : amiriRegularBuffer);

    // Default to right-alignment for Arabic text if width is provided and align is not explicitly set
    if (pdfOptions.width && !pdfOptions.align) {
      pdfOptions.align = 'right';
    }

    doc.text(formatted, x, y, pdfOptions);
  } else {
    doc.font(isBold ? 'Helvetica-Bold' : 'Helvetica');
    doc.text(str, x, y, pdfOptions);
  }
}

export async function generateInvoicePdfAndUpload(invoice: InvoiceData): Promise<string> {
  return new Promise((resolve, reject) => {
    try {
      console.log(`[pdfGenerator] Starting PDF generation for invoice #${invoice.invoiceId}`);

      // Set margin: 0 to strictly force 1 single page without automatic breaks
      const doc = new PDFDocument({
        size: 'A4',
        margin: 0,
        bufferPages: true,
      });

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

      // Color Palette
      const primaryColor = '#4F46E5'; // Indigo
      const textColor = '#1E293B';    // Slate 800
      const textSecondary = '#64748B';// Slate 500
      const borderColor = '#E2E8F0';  // Slate 200
      const rowAltColor = '#F8FAFC';  // Slate 50
      const currencyStr = invoice.currency || 'EGP';

      // 1. Top Decorative Bar
      doc.rect(0, 0, 595, 8).fill(primaryColor);

      // 2. Header Section
      doc.fillColor(primaryColor).fontSize(22);
      drawText(doc, 'INVOIFY', 35, 25, { isBold: true });

      doc.fillColor(textSecondary).fontSize(9);
      drawText(doc, 'Automated Invoicing System', 35, 52);

      doc.fillColor(textColor).fontSize(18);
      drawText(doc, 'INVOICE', 350, 25, { width: 210, align: 'right', isBold: true });

      doc.fillColor(primaryColor).fontSize(8);
      drawText(doc, `#${invoice.invoiceId}`, 350, 48, { width: 210, align: 'right', isBold: true });

      // Divider Line
      doc.strokeColor(borderColor).lineWidth(1).moveTo(35, 75).lineTo(560, 75).stroke();

      // 3. Info Cards Section (Two Columns)
      const cardY = 88;
      const cardHeight = 75;
      const colWidth = 250;

      // Left Box: ISSUED BY (Business/Merchant)
      doc.roundedRect(35, cardY, colWidth, cardHeight, 6).fillAndStroke(rowAltColor, borderColor);
      doc.fillColor(textSecondary).fontSize(8);
      drawText(doc, 'ISSUED BY', 47, cardY + 10, { isBold: true });

      const businessName = invoice.businessName || 'Invoify Merchant';
      doc.fillColor(textColor).fontSize(11);
      drawText(doc, businessName, 47, cardY + 24, { width: colWidth - 24, isBold: true });

      // Right Box: BILLED TO (Client Info)
      const rightColX = 310;
      doc.roundedRect(rightColX, cardY, colWidth, cardHeight, 6).fillAndStroke(rowAltColor, borderColor);
      doc.fillColor(textSecondary).fontSize(8);
      drawText(doc, 'BILLED TO', rightColX + 12, cardY + 10, { isBold: true });

      doc.fillColor(textColor).fontSize(11);
      drawText(doc, invoice.clientName, rightColX + 12, cardY + 24, { width: colWidth - 24, isBold: true });

      let clientDetailY = cardY + 42;
      if (invoice.clientEmail) {
        doc.fillColor(textSecondary).fontSize(8);
        drawText(doc, invoice.clientEmail, rightColX + 12, clientDetailY, { width: colWidth - 24 });
        clientDetailY += 13;
      }
      if (invoice.clientAddress) {
        doc.fillColor(textSecondary).fontSize(8);
        drawText(doc, invoice.clientAddress, rightColX + 12, clientDetailY, { width: colWidth - 24 });
      }

      // 4. Dates & Metadata Row
      const metaY = 175;
      let formattedIssueDate = 'N/A';
      try {
        if (invoice.createdAt && typeof invoice.createdAt.toDate === 'function') {
          formattedIssueDate = invoice.createdAt.toDate().toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
        } else if (invoice.createdAt) {
          const d = new Date(invoice.createdAt);
          if (!isNaN(d.getTime())) formattedIssueDate = d.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
        }
      } catch (e) {
        formattedIssueDate = 'N/A';
      }

      let formattedDueDate = 'N/A';
      try {
        if (invoice.dueDate && typeof invoice.dueDate.toDate === 'function') {
          formattedDueDate = invoice.dueDate.toDate().toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
        } else if (invoice.dueDate) {
          const d = new Date(invoice.dueDate);
          if (!isNaN(d.getTime())) formattedDueDate = d.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
        }
      } catch (dErr) {
        formattedDueDate = 'N/A';
      }

      doc.fontSize(8).fillColor(textSecondary);
      drawText(doc, 'Issue Date:', 35, metaY);
      doc.fillColor(textColor);
      drawText(doc, formattedIssueDate, 85, metaY, { isBold: true });

      doc.fillColor(textSecondary);
      drawText(doc, 'Due Date:', 210, metaY);
      doc.fillColor(textColor);
      drawText(doc, formattedDueDate, 255, metaY, { isBold: true });

      doc.fillColor(textSecondary);
      drawText(doc, 'Currency:', 410, metaY);
      doc.fillColor(textColor);
      drawText(doc, currencyStr, 455, metaY, { isBold: true });

      // 5. Items Table
      const tableTop = 195;
      const tableWidth = 525;

      // Table Header Background
      doc.roundedRect(35, tableTop, tableWidth, 24, 4).fill(primaryColor);

      // Table Header Text
      doc.fillColor('#FFFFFF').fontSize(8);
      drawText(doc, 'Item & Description', 45, tableTop + 7, { isBold: true });
      drawText(doc, 'Qty', 290, tableTop + 7, { width: 50, align: 'center', isBold: true });
      drawText(doc, 'Unit Price', 350, tableTop + 7, { width: 90, align: 'right', isBold: true });
      drawText(doc, 'Total Amount', 450, tableTop + 7, { width: 100, align: 'right', isBold: true });

      let currentY = tableTop + 26;
      let isEven = false;
      let subtotalCalculated = 0;

      if (Array.isArray(invoice.items) && invoice.items.length > 0) {
        invoice.items.forEach((item) => {
          const rawName = item.name || item.description || 'Item';
          const price = Number(item.unitPrice ?? item.price ?? 0);
          const qty = Number(item.quantity ?? 1);
          const itemTotal = qty * price;
          subtotalCalculated += itemTotal;

          if (isEven) {
            doc.rect(35, currentY - 3, tableWidth, 22).fill(rowAltColor);
          }
          isEven = !isEven;

          doc.fillColor(textColor).fontSize(9);
          drawText(doc, rawName, 45, currentY, { width: 235 });
          drawText(doc, qty.toString(), 290, currentY, { width: 50, align: 'center' });
          drawText(doc, `${price.toFixed(2)}`, 350, currentY, { width: 90, align: 'right' });
          drawText(doc, `${itemTotal.toFixed(2)}`, 450, currentY, { width: 100, align: 'right' });

          currentY += 22;
        });
      } else {
        doc.fillColor(textSecondary).fontSize(9);
        drawText(doc, 'No items specified.', 45, currentY);
        currentY += 22;
      }

      // Table Bottom Border
      doc.strokeColor(borderColor).lineWidth(1).moveTo(35, currentY).lineTo(560, currentY).stroke();
      currentY += 12;

      // 6. Financial Totals Section (Right Aligned)
      const summaryLeft = 330;
      const summaryWidth = 230;

      // Subtotal
      doc.fontSize(9).fillColor(textSecondary);
      drawText(doc, 'Subtotal:', summaryLeft, currentY, { width: 110, align: 'right' });
      doc.fillColor(textColor);
      drawText(doc, `${subtotalCalculated.toFixed(2)} ${currencyStr}`, summaryLeft + 115, currentY, { width: 110, align: 'right', isBold: true });
      currentY += 15;

      // Tax
      if (invoice.taxRate > 0) {
        doc.fontSize(9).fillColor(textSecondary);
        drawText(doc, `Tax (${invoice.taxRate}%):`, summaryLeft, currentY, { width: 110, align: 'right' });
        const taxVal = (subtotalCalculated * invoice.taxRate) / 100;
        doc.fillColor(textColor);
        drawText(doc, `+${taxVal.toFixed(2)} ${currencyStr}`, summaryLeft + 115, currentY, { width: 110, align: 'right', isBold: true });
        currentY += 15;
      }

      // Discount
      if (invoice.discount > 0) {
        doc.fontSize(9).fillColor(textSecondary);
        drawText(doc, 'Discount:', summaryLeft, currentY, { width: 110, align: 'right' });
        doc.fillColor('#DC2626');
        drawText(doc, `-${invoice.discount.toFixed(2)} ${currencyStr}`, summaryLeft + 115, currentY, { width: 110, align: 'right', isBold: true });
        currentY += 15;
      }

      currentY += 4;

      // Total Box (Highlighted Indigo Container)
      doc.roundedRect(summaryLeft, currentY, summaryWidth, 30, 5).fill(primaryColor);
      doc.fillColor('#FFFFFF').fontSize(10);
      drawText(doc, 'Total Amount Due', summaryLeft + 12, currentY + 8, { isBold: true });
      doc.fontSize(11);
      drawText(doc, `${invoice.totalAmount.toFixed(2)} ${currencyStr}`, summaryLeft + 110, currentY + 8, { width: 110, align: 'right', isBold: true });

      // 7. Footer (Fixed Position on the SINGLE A4 Page)
      const footerY = 780;
      doc.strokeColor(borderColor).lineWidth(1).moveTo(35, footerY).lineTo(560, footerY).stroke();
      doc.fontSize(8).fillColor(textSecondary);
      drawText(doc, 'Thank you for your business!', 35, footerY + 8, { align: 'center', width: 525 });
      doc.fontSize(7).fillColor('#94A3B8');
      drawText(doc, 'Invoify SaaS Automated Invoicing Platform • www.invoify.app', 35, footerY + 20, { align: 'center', width: 525 });

      doc.end();
    } catch (err) {
      console.error('[pdfGenerator] Error in generateInvoicePdfAndUpload setup:', err);
      reject(err);
    }
  });
}
