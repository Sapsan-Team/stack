import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/features/auth/domain/services/auth_session_events.dart';

final authSessionEventsProvider = Provider<AuthSessionEvents>((ref) {
  final events = AuthSessionEventBus();
  ref.onDispose(() => unawaited(events.dispose()));
  return events;
});
