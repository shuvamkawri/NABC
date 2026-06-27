import 'package:flutter/foundation.dart';
import '../models/event_model.dart';
import '../services/events_service.dart';
import '../services/my_events_service.dart';
import 'session.dart';

class EventsStore extends ChangeNotifier {
  EventsStore._internal();
  static final EventsStore instance = EventsStore._internal();

  /// All events, loaded from the backend (admin-managed `nabc_events`).
  List<Event> globalEvents = [];
  bool loading = false;
  String? error;
  bool _loaded = false;

  /// The member's saved event ids, loaded from / persisted to the backend
  /// (`nabc_my_events`), keyed by registration number.
  final List<String> _myEventIds = [];

  String get _reg => Session.current?.registrationNumber ?? '';

  /// Loads the global event list once, then refreshes the member's My Events.
  Future<void> loadEvents({bool force = false}) async {
    if (loading) return;
    if (_loaded && !force) {
      loadMyEvents();
      return;
    }
    loading = true;
    error = null;
    notifyListeners();
    try {
      globalEvents = await EventsService.fetchEvents();
      _loaded = true;
    } catch (e) {
      error = 'Could not load events. Please try again.';
      debugPrint('🚨 [EVENTS] $e');
    } finally {
      loading = false;
      notifyListeners();
    }
    loadMyEvents();
  }

  /// Pulls the member's saved event ids from the backend.
  Future<void> loadMyEvents() async {
    if (_reg.isEmpty) return;
    try {
      final ids = await MyEventsService.fetchIds(_reg);
      _myEventIds
        ..clear()
        ..addAll(ids);
      notifyListeners();
    } catch (e) {
      debugPrint('🚨 [MYEVENTS] load: $e');
    }
  }

  List<String> get myEventIds => List.unmodifiable(_myEventIds);

  List<Event> get myEvents => _myEventIds
      .where((id) => globalEvents.any((e) => e.id == id))
      .map((id) => globalEvents.firstWhere((e) => e.id == id))
      .toList();

  bool isMyEvent(String id) => _myEventIds.contains(id);

  int get myEventsCount => _myEventIds.length;

  /// Optimistically toggles locally (so the UI updates instantly), then
  /// persists to the backend; reverts if the request fails.
  void toggleEvent(String id, {VoidCallback? onToggled}) {
    final adding = !_myEventIds.contains(id);
    if (adding) {
      _myEventIds.add(id);
    } else {
      _myEventIds.remove(id);
    }
    notifyListeners();
    onToggled?.call();

    if (_reg.isEmpty) return;
    final req = adding
        ? MyEventsService.add(_reg, id)
        : MyEventsService.remove(_reg, id);
    req.catchError((e) {
      // revert on failure
      if (adding) {
        _myEventIds.remove(id);
      } else {
        _myEventIds.add(id);
      }
      notifyListeners();
      debugPrint('🚨 [MYEVENTS] toggle failed: $e');
    });
  }

  void removeFromMyEvents(String id) {
    _myEventIds.remove(id);
    notifyListeners();
    if (_reg.isNotEmpty) {
      MyEventsService.remove(_reg, id)
          .catchError((e) => debugPrint('🚨 [MYEVENTS] remove: $e'));
    }
  }

  void reorderMyEvents(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final item = _myEventIds.removeAt(oldIndex);
    _myEventIds.insert(newIndex, item);
    notifyListeners();
  }
}
