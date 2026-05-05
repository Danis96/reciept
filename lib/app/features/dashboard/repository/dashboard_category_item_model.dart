class DashboardCategoryItemModel {
  const DashboardCategoryItemModel({
    required this.name,
    required this.merchantName,
    required this.currency,
    required this.purchasedAt,
    required this.amount,
    required this.quantity,
    this.unit,
  });

  final String name;
  final String merchantName;
  final String currency;
  final DateTime purchasedAt;
  final double amount;
  final double quantity;
  final String? unit;
}
