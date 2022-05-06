class Product {
  final String id;
  final String title;
  final double price;
  final double cost;
  final DateTime dateOfPurchase;
  final int quantity;
  final double calories;
  final String trademark;
  final DateTime expirationDate;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.cost,
    required this.dateOfPurchase,
    required this.quantity,
    required this.calories,
    required this.trademark,
    required this.expirationDate,
  });
}
