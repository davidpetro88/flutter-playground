class Job {
  final String id;
  final String name;
  final int ratePerHour;

  Job({
    required this.id,
    required this.name,
    required this.ratePerHour,
  });

  factory Job.fromMap(Map<String, dynamic> map, String documentId) {
    return new Job(
      id: documentId,
      name: map['name'] as String,
      ratePerHour: map['ratePerHour'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'ratePerHour': this.ratePerHour,
    };
  }
}
