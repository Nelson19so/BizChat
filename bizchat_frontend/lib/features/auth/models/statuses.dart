class Statuses {
  final bool hasStatus;

  Statuses({required this.hasStatus});

  factory Statuses.fromJson(Map<String, dynamic> json) {
    return Statuses(
      hasStatus: json['has_status'] as bool,
    );
  }

  factory Statuses.empty() {
    return Statuses(
      hasStatus: false,
    );
  }
}