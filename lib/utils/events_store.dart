import 'package:flutter/foundation.dart';
import '../models/event_model.dart';
import '../services/events_service.dart';

class EventsStore extends ChangeNotifier {
  EventsStore._internal();
  static final EventsStore instance = EventsStore._internal();

  /// All events, loaded from the backend (`GET /api-attendee/events`),
  /// which serves whatever the admin panel has uploaded.
  List<Event> globalEvents = [];
  bool loading = false;
  String? error;
  bool _loaded = false;

  /// Loads events from the API once. Pass `force: true` to refresh.
  Future<void> loadEvents({bool force = false}) async {
    if (loading) return;
    if (_loaded && !force) return;
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
  }

  final List<String> _myEventIds = ['1', '3'];

  List<String> get myEventIds => List.unmodifiable(_myEventIds);

  List<Event> get myEvents => _myEventIds
      .where((id) => globalEvents.any((e) => e.id == id))
      .map((id) => globalEvents.firstWhere((e) => e.id == id))
      .toList();

  bool isMyEvent(String id) => _myEventIds.contains(id);

  int get myEventsCount => _myEventIds.length;

  void toggleEvent(String id, {VoidCallback? onToggled}) {
    if (_myEventIds.contains(id)) {
      _myEventIds.remove(id);
    } else {
      _myEventIds.add(id);
    }
    notifyListeners();
    onToggled?.call();
  }

  void removeFromMyEvents(String id) {
    _myEventIds.remove(id);
    notifyListeners();
  }

  void reorderMyEvents(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final item = _myEventIds.removeAt(oldIndex);
    _myEventIds.insert(newIndex, item);
    notifyListeners();
  }
}