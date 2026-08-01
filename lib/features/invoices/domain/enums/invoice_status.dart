enum InvoiceStatus {
  draft,
  sent,
  opened,
  paid,
  overdue,
  cancelled;

  String get value => name;

  static InvoiceStatus fromString(String? value) {
    switch (value?.toLowerCase().trim()) {
      case 'opened':
        return InvoiceStatus.opened;
      case 'sent':
      case 'pending':
        return InvoiceStatus.sent;
      case 'paid':
        return InvoiceStatus.paid;
      case 'overdue':
        return InvoiceStatus.overdue;
      case 'cancelled':
        return InvoiceStatus.cancelled;
      case 'draft':
      default:
        return InvoiceStatus.draft;
    }
  }
}
