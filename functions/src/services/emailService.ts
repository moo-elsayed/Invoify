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
  const host = process.env.SMTP_HOST || 'smtp.gmail.com';
  const port = parseInt(process.env.SMTP_PORT || '465', 10);
  const user = process.env.SMTP_USER;
  const pass = process.env.SMTP_PASS;

  if (!user || !pass) {
    console.warn('SMTP_USER or SMTP_PASS is missing in environment variables.');
    return null;
  }

  return nodemailer.createTransport({
    host,
    port,
    secure: port === 465,
    auth: { user, pass },
  });
}

export async function sendInvoiceEmail(params: SendInvoiceEmailParams): Promise<boolean> {
  const transporter = createTransporter();
  if (!transporter) {
    console.warn('Skipping email send: Transporter not configured.');
    return false;
  }

  const baseUrl = process.env.APP_BASE_URL || 'https://us-central1-invoify-7757d.cloudfunctions.net';
  const trackingPixelUrl = `${baseUrl}/trackEmailOpen?invoiceId=${params.invoiceId}`;
  const senderName = params.businessName || 'Invoify';

  const payButtonHtml = params.stripePaymentLink
    ? `<div style="margin: 30px 0;">
        <a href="${params.stripePaymentLink}" style="background-color: #4F46E5; color: #ffffff; padding: 14px 28px; text-decoration: none; border-radius: 8px; font-weight: bold; display: inline-block;">Pay Invoice (${params.totalAmount} ${params.currency})</a>
       </div>`
    : '';

  const htmlContent = `
    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; color: #333333; padding: 20px; border: 1px solid #e0e0e0; border-radius: 10px;">
      <h2 style="color: #4F46E5;">Invoice #${params.invoiceId} from ${senderName}</h2>
      <p>Dear ${params.clientName},</p>
      <p>Please find attached your invoice for <strong>${params.totalAmount} ${params.currency}</strong>.</p>
      ${payButtonHtml}
      <p style="font-size: 13px; color: #777;">If you have any questions, feel free to reply to this email.</p>
      <hr style="border: none; border-top: 1px solid #eeeeee; margin: 20px 0;" />
      <p style="font-size: 11px; color: #aaa;">Sent via Invoify Automated Invoicing Platform</p>
      <!-- Hidden Tracking Pixel -->
      <img src="${trackingPixelUrl}" width="1" height="1" alt="" style="display:none;" />
    </div>
  `;

  try {
    await transporter.sendMail({
      from: `"${senderName}" <${process.env.SMTP_USER}>`,
      to: params.toEmail,
      subject: `New Invoice #${params.invoiceId} from ${senderName}`,
      html: htmlContent,
    });
    console.log(`Invoice email sent successfully to ${params.toEmail}`);
    return true;
  } catch (error) {
    console.error('Failed to send invoice email:', error);
    return false;
  }
}
