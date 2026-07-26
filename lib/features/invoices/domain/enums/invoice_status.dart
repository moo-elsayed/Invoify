enum InvoiceStatus {
  draft,
  sent,
  paid,
  overdue,
  cancelled;

  String get value => name;

  static InvoiceStatus fromString(String? value) {
    switch (value?.toLowerCase().trim()) {
      case 'sent':
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
