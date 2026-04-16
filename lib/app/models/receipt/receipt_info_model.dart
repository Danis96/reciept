class ReceiptInfoModel {
  final String type;
  final String? number;
  final DateTime? dateTime;
  final String? date;
  final String? time;

  const ReceiptInfoModel({
    required this.type,
    this.number,
    this.dateTime,
    this.date,
    this.time,
  });

  factory ReceiptInfoModel.fromJson(Map<String, dynamic> json) {
    return ReceiptInfoModel(
      type: json['type']?.toString() ?? 'fiscal',
      number: json['number']?.toString(),
      dateTime: DateTime.tryParse(json['datetime']?.toString() ?? ''),
      date: json['date']?.toString(),
      time: json['time']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'number': number,
      'datetime': dateTime?.toIso8601String(),
      'date': date,
      'time': time,
    };
  }
}
