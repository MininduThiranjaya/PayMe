class Shop {

  final int id;
  final String shopName;
  final String address;

  const Shop({
    required this.id,
    required this.shopName,
    required this.address
  });

  factory Shop.fromJson(Map<String, dynamic> json) {

    return Shop(
      id: json['id'] as int? ?? 0,
      shopName: json['shopName'] as String? ?? '',
      address: json['address'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {

    return {
      'id': id,
      'shopName': shopName,
      'address': address,
    };
  }
}

class UserProfile {
  
  final String nic;
  final String userName;
  final List<String> roles;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Shop> shops;

  const UserProfile({
    required this.nic,
    required this.userName,
    required this.roles,
    required this.createdAt,
    required this.updatedAt,
    required this.shops,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {

    return UserProfile(
      nic: json['nic'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      roles: (json['roles'] as List<dynamic>? ?? [])
        .map((role) => role.toString())
        .toList(),
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),

      updatedAt: DateTime.parse(
        json['updatedAt'] as String,
      ),

      shops: (json['shops'] as List<dynamic>? ?? [])
          .map(
            (shop) => Shop.fromJson(
              shop as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {

    return {
      'nic': nic,
      'userName': userName,
      'roles': roles,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'shops': shops.map((shop) => shop.toJson()).toList(),
    };
  }
}