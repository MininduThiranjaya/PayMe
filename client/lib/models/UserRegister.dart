enum Role { CUSTOMER, MERCHANT }

Role _roleFromString(String value) {
  return Role.values.firstWhere(
    (r) => r.name == value,
    orElse: () => Role.CUSTOMER,
  );
}

/// Shop info sent TO the backend when registering a merchant.
class ShopRequestDto {
  final String shopName;
  final String address;

  ShopRequestDto({required this.shopName, required this.address});

  Map<String, dynamic> toJson() => {
        'shopNames': shopName,
        'addresses': address,
      };
}

/// Shop info returned FROM the backend after a merchant registers
/// (mirrors Shop_res_dto).
class ShopResDto {
  final String? shopId;
  final String shopName;
  final String address;

  ShopResDto({this.shopId, required this.shopName, required this.address});

  factory ShopResDto.fromJson(Map<String, dynamic> json) {
    return ShopResDto(
      shopId: json['shopId'] as String?,
      shopName: json['shopName'] as String? ?? '',
      address: json['address'] as String? ?? '',
    );
  }
}

/// resData payload for a customer registration.
class RegisterResponseData {
  final String nic;
  final String userName;
  final Set<Role> roles;

  RegisterResponseData({
    required this.nic,
    required this.userName,
    required this.roles,
  });

  factory RegisterResponseData.fromJson(Map<String, dynamic> json) {
    final rawRoles = (json['roles'] as List<dynamic>? ?? []);
    return RegisterResponseData(
      nic: json['nic'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      roles: rawRoles.map((r) => _roleFromString(r.toString())).toSet(),
    );
  }
}

/// resData payload for a merchant registration - extends the base fields
/// with the Stripe onboarding info + shop list.
class MerchantRegisterResponseData extends RegisterResponseData {
  final String? stripeAccountId;
  final String? stripeOnboardingURL;
  final List<ShopResDto> shops;

  MerchantRegisterResponseData({
    required super.nic,
    required super.userName,
    required super.roles,
    this.stripeAccountId,
    this.stripeOnboardingURL,
    required this.shops,
  });

  factory MerchantRegisterResponseData.fromJson(Map<String, dynamic> json) {
    final rawRoles = (json['roles'] as List<dynamic>? ?? []);
    final rawShops = (json['shops'] as List<dynamic>? ?? []);
    return MerchantRegisterResponseData(
      nic: json['nic'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      roles: rawRoles.map((r) => _roleFromString(r.toString())).toSet(),
      stripeAccountId: json['stripeAccountId'] as String?,
      stripeOnboardingURL: json['stripeOnboardingURL'] as String?,
      shops: rawShops
          .map((s) => ShopResDto.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}