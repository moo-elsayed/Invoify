enum DiscountType {
  percentage,
  fixed;

  bool get isPercentage => this == DiscountType.percentage;
  bool get isFixed => this == DiscountType.fixed;

  static DiscountType fromString(String? type) {
    if (type == 'percentage') {
      return DiscountType.percentage;
    }
    return DiscountType.fixed;
  }
}
