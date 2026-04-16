class MerchantModel {
  final String name;
  final String? storeName;
  final String? address;
  final String? city;
  final String? jib;
  final String? pib;

  const MerchantModel({
    required this.name,
    this.storeName,
    this.address,
    this.city,
    this.jib,
    this.pib,
  });

  factory MerchantModel.fromJson(Map<String, dynamic> json) {
    return MerchantModel(
      name: json['name']?.toString() ?? '',
      storeName: json['store_name']?.toString(),
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      jib: json['jib']?.toString(),
      pib: json['pib']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'store_name': storeName,
      'address': address,
      'city': city,
      'jib': jib,
      'pib': pib,
    };
  }
}
