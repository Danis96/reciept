class FiscalInfoModel {
  final String? ibfm;
  final bool qrPresent;
  final String? verificationCode;

  const FiscalInfoModel({
    this.ibfm,
    required this.qrPresent,
    this.verificationCode,
  });

  factory FiscalInfoModel.fromJson(Map<String, dynamic> json) {
    return FiscalInfoModel(
      ibfm: json['ibfm']?.toString(),
      qrPresent: json['qr_present'] == true,
      verificationCode: json['verification_code']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ibfm': ibfm,
      'qr_present': qrPresent,
      'verification_code': verificationCode,
    };
  }
}
