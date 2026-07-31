import Stripe from 'stripe';
import { InvoiceData } from './pdfGenerator';

export function getStripeClient(): Stripe | null {
  const secretKey = process.env.STRIPE_SECRET_KEY;
  if (!secretKey) {
    console.warn('STRIPE_SECRET_KEY is not configured in environment variables.');
    return null;
  }
  return new Stripe(secretKey, {
    apiVersion: '2023-10-16',
  });
}

export async function createStripeCheckoutSession(invoice: InvoiceData): Promise<string | null> {
  const stripe = getStripeClient();
  if (!stripe) return null;

  try {
    const currency = (invoice.currency || 'EGP').toLowerCase();
    const totalInCents = Math.round(invoice.totalAmount * 100);

    // Format item summary for product description
    const itemSummary = Array.isArray(invoice.items) && invoice.items.length > 0
      ? invoice.items.map((i) => `${i.name || i.description || 'Item'} (x${i.quantity ?? 1})`).join(', ')
      : `Invoice #${invoice.invoiceId}`;

    const lineItems: Stripe.Checkout.SessionCreateParams.LineItem[] = [
      {
        price_data: {
          currency: currency,
          product_data: {
            name: `Invoice #${invoice.invoiceId}`,
            description: itemSummary,
          },
          unit_amount: totalInCents,
        },
        quantity: 1,
      },
    ];

    console.log(`[createStripeCheckoutSession] Creating session for invoice #${invoice.invoiceId}: Amount = ${invoice.totalAmount} ${currency.toUpperCase()}`);

    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: lineItems,
      mode: 'payment',
      client_reference_id: invoice.invoiceId,
      customer_email: invoice.clientEmail || undefined,
      metadata: {
        invoiceId: invoice.invoiceId,
        userId: invoice.userId,
      },
      success_url: `${process.env.APP_BASE_URL || 'https://europe-west3-invoify-7757d.cloudfunctions.net'}/payment-success?invoiceId=${invoice.invoiceId}`,
      cancel_url: `${process.env.APP_BASE_URL || 'https://europe-west3-invoify-7757d.cloudfunctions.net'}/payment-cancel?invoiceId=${invoice.invoiceId}`,
    });

    return session.url;
  } catch (error) {
    console.error('Error creating Stripe Checkout session:', error);
    return null;
  }
}
