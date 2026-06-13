import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/queue_service.dart';

final queueProvider = Provider<QueueService>((ref) {
  return QueueService();
});