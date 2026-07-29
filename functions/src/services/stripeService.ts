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
    const lineItems: Stripe.Checkout.SessionCreateParams.LineItem[] = invoice.items.map((item) => ({
      price_data: {
        currency: (invoice.currency || 'USD').toLowerCase(),
        product_data: {
          name: item.description,
        },
        unit_amount: Math.round(item.price * 100), // Stripe expects amounts in cents
      },
      quantity: item.quantity,
    }));

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
      success_url: `${process.env.APP_BASE_URL || 'https://invoify.app'}/payment-success?invoiceId=${invoice.invoiceId}`,
      cancel_url: `${process.env.APP_BASE_URL || 'https://invoify.app'}/payment-cancel?invoiceId=${invoice.invoiceId}`,
    });

    return session.url;
  } catch (error) {
    console.error('Error creating Stripe Checkout session:', error);
    return null;
  }
}
