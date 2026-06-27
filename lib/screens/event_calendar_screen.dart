import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/responsive.dart';
import '../utils/events_store.dart';
import '../models/event_model.dart';
import '../widgets/banner_slider.dart';

class EventCalendarScreen extends StatefulWidget {
  const EventCalendarScreen({super.key});

  @override
  State<EventCalendarScreen> createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  String _filterDay = 'All';

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'Music':       return AppColors.accentRed;
      case 'Cultural':    return const Color(0xFF6A1B9A);
      case 'Business':    return AppColors.primaryBlue;
      case 'Film':        return const Color(0xFF00695C);
      case 'Health':      return const Color(0xFF2E7D32);
      case 'Competition': return const Color(0xFFE65100);
      case 'Opening':     return const Color(0xFF0277BD);
      case 'Closing':     return const Color(0xFF4527A0);
      default:            return AppColors.mediumGrey;
    }
  }

  Widget _stateMessage(BuildContext context, String message,
      {VoidCallback? onRetry}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_busy_rounded,
                size: 48, color: context.textSecondary.withValues(alpha: 0.6)),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(color: context.textSecondary)),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    EventsStore.instance.loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final sliderH = context.hp(26).clamp(170.0, 230.0);

    final canPop = Navigator.canPop(context);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // ── Banner Slider ────────────────────────────────────────
              BannerSlider(
                height: sliderH,
              ),

              // ── Events list (no calendar) ────────────────────────────
              Expanded(child: _buildEventsTab(context, cs)),
            ],
          ),

          // ── Back button overlay (only when pushed via Navigator) ──
          if (canPop)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 6),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Events Tab (Global Chooser) ───────────────────────────────────
  Widget _buildEventsTab(BuildContext context, ColorScheme cs) {
    return ListenableBuilder(
      listenable: EventsStore.instance,
      builder: (context, _) {
        final store = EventsStore.instance;
        final allEvents = store.globalEvents;

        // Loading / error / empty states (first load from the API).
        if (store.loading && allEvents.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (store.error != null && allEvents.isEmpty) {
          return _stateMessage(context, store.error!,
              onRetry: () => store.loadEvents(force: true));
        }
        if (allEvents.isEmpty) {
          return _stateMessage(context, 'No events available yet.');
        }

        // Filter by day
        final filtered = _filterDay == 'All'
            ? allEvents
            : allEvents.where((e) => e.date.contains(_filterDay)).toList();

        // Group by date — dynamic, so any uploaded dates appear in order.
        final Map<String, List<Event>> grouped = {};
        final dateOrder = <String>[];
        for (final e in filtered) {
          if (!grouped.containsKey(e.date)) dateOrder.add(e.date);
          grouped.putIfAbsent(e.date, () => []).add(e);
        }

        final List<Object> items = [];
        for (final d in dateOrder) {
          items.add(d);
          items.addAll(grouped[d]!);
        }

        return Column(
          children: [
            // Header row
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: context.pagePad, vertical: 12),
              decoration: BoxDecoration(
                color: context.cardBg,
                border: Border(
                    bottom: BorderSide(
                        color: context.borderColor.withValues(alpha: 0.4))),
              ),
              child: Column(
                children: [
                  Row(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Icon(Icons.festival_rounded,
                              color: cs.primary, size: 18),
                          const SizedBox(width: 6),
                          Text('All Events',
                              style: TextStyle(
                                fontSize: context.sp(16),
                                fontWeight: FontWeight.w900,
                                color: context.textPrimary,
                              )),
                        ]),
                        Text(
                          '${allEvents.length} events  •  ${store.myEventsCount} selected',
                          style: TextStyle(
                            fontSize: context.sp(10),
                            color: context.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [cs.primary, const Color(0xFF1E88E5)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: cs.primary.withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Text(
                        '${store.myEventsCount} My Events',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: context.sp(10),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  // Day filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final d in ['All', 'Jul 3', 'Jul 4', 'Jul 5'])
                          _filterChip(context, cs, d),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Events list
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text('No events found',
                          style: TextStyle(color: context.textSecondary)))
                  : ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                          context.pagePad, 8, context.pagePad, context.pagePad),
                      itemCount: items.length,
                      itemBuilder: (_, i) {
                        final item = items[i];
                        if (item is String) {
                          return _buildDateHeader(context, cs, item,
                              grouped[item]!.length);
                        }
                        return _buildEventCard(context, store, item as Event);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _filterChip(BuildContext context, ColorScheme cs, String label) {
    final dayKey = label == 'All'
        ? 'All'
        : label.replaceFirst('Jul ', 'July ').contains('Jul 3')
            ? '3,'
            : label.contains('Jul 4')
                ? '4,'
                : '5,';
    final active = _filterDay == dayKey || (label == 'All' && _filterDay == 'All');

    return GestureDetector(
      onTap: () => setState(() => _filterDay = label == 'All' ? 'All' : dayKey),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          gradient: active
              ? LinearGradient(
                  colors: [const Color(0xFF0D47A1), cs.primary])
              : null,
          color: active ? null : context.surfaceBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active
                ? Colors.transparent
                : context.borderColor,
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                      color: cs.primary.withValues(alpha: 0.30),
                      blurRadius: 6,
                      offset: const Offset(0, 2))
                ]
              : null,
        ),
        child: Text(label,
            style: TextStyle(
              color: active ? Colors.white : context.textSecondary,
              fontSize: context.sp(11),
              fontWeight: active ? FontWeight.w800 : FontWeight.w500,
            )),
      ),
    );
  }

  Widget _buildDateHeader(BuildContext context, ColorScheme cs, String date, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 10),
      child: Row(children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [cs.primary, const Color(0xFF42A5F5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(date,
            style: TextStyle(
              fontSize: context.sp(14),
              fontWeight: FontWeight.w900,
              color: context.textPrimary,
            )),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [cs.primary.withValues(alpha: 0.15),
                         cs.primary.withValues(alpha: 0.08)]),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count event${count > 1 ? 's' : ''}',
            style: TextStyle(
              color: cs.primary,
              fontSize: context.sp(10),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildEventCard(BuildContext context, EventsStore store, Event event) {
    final color = _categoryColor(event.category);
    final isMyEvent = store.isMyEvent(event.id);
    final timeParts = event.time.split(' ');
    final timeNum = timeParts.isNotEmpty ? timeParts[0] : event.time;
    final timeSuffix = timeParts.length > 1 ? timeParts[1] : '';

    return GestureDetector(
      onTap: () => _showEventDetail(context, store, event),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(context.cardRadius + 2),
          border: isMyEvent
              ? Border.all(color: AppColors.successGreen, width: 2)
              : Border.all(
                  color: context.borderColor.withValues(alpha: 0.5)),
          boxShadow: isMyEvent
              ? [
                  BoxShadow(
                    color: AppColors.successGreen.withValues(alpha: 0.20),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  )
                ]
              : context.cardShadow,
        ),
        child: Row(
          children: [
            // ── Colored time panel ──────────────────────────────────
            Container(
              width: 70,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.lerp(color, Colors.white, 0.15)!,
                    color,
                    Color.lerp(color, Colors.black, 0.2)!,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.cardRadius + 2),
                  bottomLeft: Radius.circular(context.cardRadius + 2),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(timeNum,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: context.sp(15),
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                      )),
                  if (timeSuffix.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(timeSuffix,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: context.sp(9),
                          fontWeight: FontWeight.w700,
                        )),
                  ],
                  const SizedBox(height: 6),
                  Container(
                      width: 24, height: 1, color: Colors.white30),
                  const SizedBox(height: 6),
                  Text(
                    event.category.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: context.sp(7),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),

            // ── Event details ───────────────────────────────────────
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: context.cardPad, vertical: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: context.sp(13),
                          color: context.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 5),
                    Row(children: [
                      Icon(Icons.location_on_outlined,
                          size: 12, color: color),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(event.location,
                            style: TextStyle(
                              fontSize: context.sp(11),
                              color: context.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ]),
                    if (event.performers.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Row(children: [
                        const Icon(Icons.star_rounded,
                            size: 11, color: AppColors.accentGold),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(event.performers.join(', '),
                              style: TextStyle(
                                fontSize: context.sp(10),
                                color: context.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ]),
                    ],
                  ],
                ),
              ),
            ),

            // ── Add/Remove Button ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () {
                  store.toggleEvent(event.id);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(store.isMyEvent(event.id)
                        ? '${event.title} added to My Events'
                        : '${event.title} removed from My Events'),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ));
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isMyEvent
                        ? const LinearGradient(
                            colors: [
                              AppColors.successGreen,
                              Color(0xFF2E7D32)
                            ],
                          )
                        : LinearGradient(
                            colors: [
                              AppColors.primaryBlue.withValues(alpha: 0.15),
                              AppColors.primaryBlue.withValues(alpha: 0.05),
                            ],
                          ),
                    border: Border.all(
                      color: isMyEvent
                          ? AppColors.successGreen
                          : AppColors.primaryBlue.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                    boxShadow: isMyEvent
                        ? [
                            BoxShadow(
                              color: AppColors.successGreen
                                  .withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ]
                        : null,
                  ),
                  child: Icon(
                    isMyEvent
                        ? Icons.check_rounded
                        : Icons.add_rounded,
                    color: isMyEvent
                        ? Colors.white
                        : AppColors.primaryBlue,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEventDetail(
      BuildContext context, EventsStore store, Event event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final isMyEvent = store.isMyEvent(event.id);
          final color = _categoryColor(event.category);
          return DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.4,
            maxChildSize: 0.92,
            expand: false,
            builder: (__, ctrl) => SingleChildScrollView(
              controller: ctrl,
              padding: EdgeInsets.all(context.pagePad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.borderColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: color.withValues(alpha: 0.4)),
                    ),
                    child: Text(event.category,
                        style: TextStyle(
                          color: color,
                          fontSize: context.sp(10),
                          fontWeight: FontWeight.w800,
                        )),
                  ),
                  const SizedBox(height: 10),
                  Text(event.title,
                      style: TextStyle(
                        fontSize: context.sp(22),
                        fontWeight: FontWeight.w900,
                        color: context.textPrimary,
                      )),
                  const SizedBox(height: 14),
                  _infoRow(context, Icons.calendar_today, event.date, color),
                  _infoRow(context, Icons.access_time, event.time, color),
                  _infoRow(
                      context, Icons.location_on, event.location, color),
                  const SizedBox(height: 16),
                  Text('About',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: context.sp(15),
                        color: context.textPrimary,
                      )),
                  const SizedBox(height: 6),
                  Text(event.description,
                      style: TextStyle(
                        color: context.textSecondary,
                        height: 1.55,
                        fontSize: context.sp(13),
                      )),
                  if (event.performers.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text('Performers',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: context.sp(15),
                          color: context.textPrimary,
                        )),
                    const SizedBox(height: 8),
                    ...event.performers.map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(children: [
                        const Icon(Icons.star_rounded,
                            size: 14,
                            color: AppColors.accentGold),
                        const SizedBox(width: 8),
                        Text(p,
                            style: TextStyle(
                              color: context.textPrimary,
                              fontSize: context.sp(13),
                              fontWeight: FontWeight.w600,
                            )),
                      ]),
                    )),
                  ],
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isMyEvent
                              ? [
                                  const Color(0xFFD32F2F),
                                  const Color(0xFFB71C1C)
                                ]
                              : [
                                  AppColors.primaryBlue,
                                  const Color(0xFF1E88E5)
                                ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: (isMyEvent
                                    ? AppColors.accentRed
                                    : AppColors.primaryBlue)
                                .withValues(alpha: 0.40),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          store.toggleEvent(event.id);
                        },
                        icon: Icon(isMyEvent
                            ? Icons.remove_circle_outline
                            : Icons.add_circle_outline),
                        label: Text(isMyEvent
                            ? 'Remove from My Events'
                            : 'Add to My Events'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          textStyle: TextStyle(
                            fontSize: context.sp(14),
                            fontWeight: FontWeight.w800,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(BuildContext context, IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Flexible(
          child: Text(text,
              style: TextStyle(
                fontSize: context.sp(13),
                color: context.textPrimary,
              )),
        ),
      ]),
    );
  }
}