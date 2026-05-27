class Statuses {
  final bool hasStatus;

  Statuses({required this.hasStatus});

  factory Statuses.fromJson(Map<String, dynamic> json) {
    return Statuses(
      hasStatus: json['has_status'] as bool,
    );
  }
}