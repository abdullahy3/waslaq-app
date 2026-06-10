/// Global notification refresh bus.
/// main.dart calls notifyRefreshListeners() when any FCM message arrives (foreground).
/// _BellIconWithBadge listens to immediately re-fetch badge count without polling.

final List<void Function()> _notifRefreshListeners = [];

void addNotifRefreshListener(void Function() cb) =>
    _notifRefreshListeners.add(cb);

void removeNotifRefreshListener(void Function() cb) =>
    _notifRefreshListeners.remove(cb);

/// Call this whenever a new notification arrives — triggers badge re-fetch everywhere.
void notifyRefreshListeners() {
  for (final cb in _notifRefreshListeners) {
    cb();
  }
}
