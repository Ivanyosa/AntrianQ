class BusinessModel {
  final String id;
  final String ownerId;

  final String name;
  final String? logoUrl;
  final String location;
  final String description;

  final int serviceDuration;
  final int maxDailyQueue;
  final int currentQueue;
  final int queueSession;

  final String status;
  final String approvalStatus;

  final DateTime createdAt;

  const BusinessModel({
    required this.id,
    required this.ownerId,
    required this.name,
    this.logoUrl,
    required this.location,
    required this.description,
    required this.serviceDuration,
    required this.maxDailyQueue,
    required this.currentQueue,
    required this.queueSession,
    required this.status,
    required this.approvalStatus,
    required this.createdAt,
  });

  factory BusinessModel.fromMap(Map<String, dynamic> map) {
    return BusinessModel(
      id: map['id'] ?? '',
      ownerId: map['owner_id'] ?? '',

      name: map['name'] ?? '',
      logoUrl: map['logo_url'],

      location: map['location'] ?? '',
      description: map['description'] ?? '',

      serviceDuration: map['service_duration'] ?? 0,
      maxDailyQueue: map['max_daily_queue'] ?? 0,
      currentQueue: map['current_queue'] ?? 0,
      queueSession: map['queue_session'] ?? 0,

      status: map['status'] ?? 'closed',
      approvalStatus: map['approval_status'] ?? 'pending',

      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'owner_id': ownerId,

      'name': name,
      'logo_url': logoUrl,

      'location': location,
      'description': description,

      'service_duration': serviceDuration,
      'max_daily_queue': maxDailyQueue,
      'current_queue': currentQueue,
      'queue_session': queueSession,

      'status': status,
      'approval_status': approvalStatus,

      'created_at': createdAt.toIso8601String(),
    };
  }
}
