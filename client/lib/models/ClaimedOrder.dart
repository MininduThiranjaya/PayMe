class ClaimedOrder {
  final int orderId;
  final String merchantNic;
  final String? customerNic;
  final String status;
  final List<ClaimedOrderItem> orderItems;
  final int totalAmount;
  final DateTime createdAt;

  ClaimedOrder({
    required this.orderId,
    required this.merchantNic,
    required this.customerNic,
    required this.status,
    required this.orderItems,
    required this.totalAmount,
    required this.createdAt,
  });

  factory ClaimedOrder.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClaimedOrder(
      orderId:
          (json['orderId'] as num).toInt(),

      merchantNic:
          json['merchantNic']?.toString() ?? '',

      customerNic:
          json['customerNic']?.toString(),

      status:
          json['status']?.toString() ?? '',

      orderItems:
          (json['orderItems'] as List<dynamic>? ?? [])
              .map(
                (item) =>
                    ClaimedOrderItem.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList(),

      totalAmount:
          (json['totalAmount'] as num).toInt(),

      createdAt:
          DateTime.parse(
        json['createdAt'].toString(),
      ),
    );
  }
}

class ClaimedOrderItem {
  final int id;
  final String itemName;
  final int quantity;
  final String metric;
  final int unitPrice;
  final int totalPrice;

  ClaimedOrderItem({
    required this.id,
    required this.itemName,
    required this.quantity,
    required this.metric,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory ClaimedOrderItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClaimedOrderItem(
      id:
          (json['id'] as num).toInt(),

      itemName:
          json['itemName']?.toString() ?? '',

      quantity:
          (json['quantity'] as num).toInt(),

      metric:
          json['metric']?.toString() ?? '',

      unitPrice:
          (json['unitPrice'] as num).toInt(),

      totalPrice:
          (json['totalPrice'] as num).toInt(),
    );
  }
}