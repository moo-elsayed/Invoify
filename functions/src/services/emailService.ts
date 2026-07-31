import nodemailer from 'nodemailer';

export interface SendInvoiceEmailParams {
  toEmail: string;
  clientName: string;
  invoiceId: string;
  totalAmount: number;
  currency: string;
  pdfUrl?: string;
  stripePaymentLink?: string;
  businessName?: string;
}

export function createTransporter() {
  const user = process.env.SMTP_USER?.trim();
  const pass = process.env.SMTP_PASS?.replace(/\s+/g, '');

  if (!user || !pass) {
    console.warn('SMTP_USER or SMTP_PASS is missing in environment variables.');
    return null;
  }

  // Use port 587 STARTTLS for optimal GCP Cloud Functions compatibility
  return nodemailer.createTransport({
    host: 'smtp.gmail.com',
    port: 587,
    secure: false, // STARTTLS
    auth: { user, pass },
    tls: {
      rejectUnauthorized: false,
    },
  });
}

export async function sendInvoiceEmail(params: SendInvoiceEmailParams): Promise<boolean> {
  console.log(`[sendInvoiceEmail] Initiating email send to target: ${params.toEmail}`);
  const transporter = createTransporter();
  if (!transporter) {
    console.warn('[sendInvoiceEmail] Transporter creation failed. Missing SMTP credentials.');
    return false;
  }

  const baseUrl = process.env.APP_BASE_URL || 'https://europe-west3-invoify-7757d.cloudfunctions.net';
  const trackingPixelUrl = `${baseUrl}/trackEmailOpen?invoiceId=${params.invoiceId}`;
  const senderName = params.businessName || 'Invoify';
  const currencyStr = params.currency || 'EGP';

  const payButtonHtml = params.stripePaymentLink
    ? `<div style="margin: 25px 0 10px 0;">
        <a href="${params.stripePaymentLink}" style="background-color: #4F46E5; color: #ffffff; padding: 14px 28px; text-decoration: none; border-radius: 8px; font-weight: bold; display: inline-block; font-size: 16px;">Pay Invoice Online (${params.totalAmount} ${currencyStr})</a>
       </div>`
    : '';

  const pdfButtonHtml = params.pdfUrl
    ? `<div style="margin: 10px 0 25px 0;">
        <a href="${params.pdfUrl}" style="background-color: #374151; color: #ffffff; padding: 10px 20px; text-decoration: none; border-radius: 6px; font-weight: bold; display: inline-block; font-size: 14px;">Download PDF Invoice</a>
       </div>`
    : '';

  const htmlContent = `
    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; color: #333333; padding: 25px; border: 1px solid #e0e0e0; border-radius: 12px;">
      <h2 style="color: #4F46E5; margin-top: 0;">Invoice #${params.invoiceId} from ${senderName}</h2>
      <p style="font-size: 15px;">Dear ${params.clientName},</p>
      <p style="font-size: 15px;">Please find attached your invoice for <strong>${params.totalAmount} ${currencyStr}</strong>.</p>
      ${payButtonHtml}
      ${pdfButtonHtml}
      <p style="font-size: 13px; color: #777;">If you have any questions, feel free to reply to this email.</p>
      <hr style="border: none; border-top: 1px solid #eeeeee; margin: 20px 0;" />
      <p style="font-size: 11px; color: #aaa;">Sent via Invoify Automated Invoicing Platform</p>
      <!-- Hidden Tracking Pixel -->
      <img src="${trackingPixelUrl}" width="1" height="1" alt="" style="display:none;" />
    </div>
  `;

  // Attach PDF directly to email if available
  const attachments: any[] = [];
  if (params.pdfUrl) {
    attachments.push({
      filename: `Invoice_${params.invoiceId}.pdf`,
      path: params.pdfUrl,
    });
  }

  try {
    console.log(`[sendInvoiceEmail] Sending email from "${senderName}" <${process.env.SMTP_USER}> to ${params.toEmail}...`);
    const info = await transporter.sendMail({
      from: `"${senderName}" <${process.env.SMTP_USER}>`,
      to: params.toEmail,
      subject: `New Invoice #${params.invoiceId} from ${senderName}`,
      html: htmlContent,
      attachments,
    });
    console.log(`[sendInvoiceEmail] Invoice email sent successfully! MessageID: ${info.messageId}`);
    return true;
  } catch (error: any) {
    console.error('[sendInvoiceEmail] Failed to send invoice email:', error?.message || error, error?.stack || '');
    return false;
  }
}
