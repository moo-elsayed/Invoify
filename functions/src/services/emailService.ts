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
  const appSenderName = 'Invoify';
  const merchantName = params.businessName || 'Merchant';
  const currencyStr = params.currency || 'EGP';

  const payButtonHtml = params.stripePaymentLink
    ? `<div style="margin: 20px 0 10px 0;">
        <a href="${params.stripePaymentLink}" style="background-color: #4F46E5; color: #ffffff; padding: 14px 28px; text-decoration: none; border-radius: 8px; font-weight: 600; display: inline-block; font-size: 15px; box-shadow: 0 4px 6px -1px rgba(79, 70, 229, 0.2);">Pay Invoice Online (${params.totalAmount} ${currencyStr})</a>
       </div>`
    : '';

  const pdfButtonHtml = params.pdfUrl
    ? `<div style="margin: 10px 0 20px 0;">
        <a href="${params.pdfUrl}" style="background-color: #1F2937; color: #ffffff; padding: 11px 22px; text-decoration: none; border-radius: 8px; font-weight: 500; display: inline-block; font-size: 14px;">Download PDF Invoice</a>
       </div>`
    : '';

  const htmlContent = `
    <div style="font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; max-width: 600px; margin: 0 auto; background-color: #ffffff; color: #1F2937; padding: 32px; border: 1px solid #E5E7EB; border-radius: 16px; box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.05);">
      <!-- App Header -->
      <div style="border-bottom: 2px solid #F3F4F6; padding-bottom: 16px; margin-bottom: 24px; display: flex; align-items: center; justify-content: space-between;">
        <div>
          <span style="font-size: 24px; font-weight: 800; color: #4F46E5; letter-spacing: -0.5px;">Invoify</span>
        </div>
      </div>

      <!-- Main Body -->
      <h2 style="color: #111827; font-size: 20px; font-weight: 700; margin-top: 0;">New Invoice from ${merchantName}</h2>
      <p style="font-size: 15px; color: #4B5563; line-height: 1.6;">Dear <strong>${params.clientName}</strong>,</p>
      <p style="font-size: 15px; color: #4B5563; line-height: 1.6;">
        You have received a new invoice <strong>#${params.invoiceId}</strong> for the total amount of <strong style="color: #4F46E5;">${params.totalAmount} ${currencyStr}</strong>.
      </p>

      ${payButtonHtml}
      ${pdfButtonHtml}

      <p style="font-size: 13px; color: #6B7280; margin-top: 24px;">If you have any questions regarding this invoice, please reach out to ${merchantName}.</p>
      
      <!-- Footer -->
      <hr style="border: none; border-top: 1px solid #F3F4F6; margin: 28px 0 16px 0;" />
      <p style="font-size: 12px; color: #9CA3AF; text-align: center; margin: 0;">Sent automatically via <strong>Invoify</strong> Automated Invoicing System</p>

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
    console.log(`[sendInvoiceEmail] Sending email from "${appSenderName}" <${process.env.SMTP_USER}> to ${params.toEmail}...`);
    const info = await transporter.sendMail({
      from: `"${appSenderName}" <${process.env.SMTP_USER}>`,
      to: params.toEmail,
      subject: `Invoice #${params.invoiceId} from ${merchantName} - Invoify`,
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
