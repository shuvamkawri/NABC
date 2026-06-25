import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/responsive.dart';
import '../utils/events_store.dart';
import '../models/event_model.dart';
import '../widgets/banner_slider.dart';
import '../widgets/status_badge.dart';

class MyEventsScreen extends StatefulWidget {
  final bool standalone;
  const MyEventsScreen({super.key, this.standalone = false});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  // Simulated status for each event
  final Map<String, String> _eventStatus = {
    '1': 'Confirmed',
    '2': 'Pending',
    '3': 'Confirmed',
    '4': 'Pending',
    '5': 'Pending',
    '6': 'Pending',
    '7': 'Pending',
    '8': 'Pending',
    '9': 'Pending',
    '10': 'Confirmed',
  };

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'Music':       return AppColors.accentRed;
      case 'Cultural':    return const Color(0xFF6A1B9A);
      case 'Opening':     return AppColors.primaryBlue;
      case 'Closing':     return const Color(0xFF2E7D32);
      case 'Business':    return const Color(0xFF0277BD);
      case 'Film':        return const Color(0xFF00695C);
      case 'Health':      return const Color(0xFF2E7D32);
      case 'Competition': return const Color(0xFFE65100);
      default:            return AppColors.mediumGrey;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    EventsStore.instance.loadEvents();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final sliderH = context.hp(22).clamp(140.0, 190.0);

    return Scaffold(
      body: Column(
        children: [
          // ── Compact Banner Slider ─────────────────────────────────
          if (!widget.standalone)
            BannerSlider(
              slides: nabcBannerSlides,
              height: sliderH,
              showTopBar: false,
            ),

          // ── App Bar row ───────────────────────────────────────────
          Container(
            color: cs.primary,
            child: SafeArea(
              bottom: false,
              top: widget.standalone,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        widget.standalone ? 4 : context.pagePad,
                        8,
                        context.pagePad,
                        4),
                    child: Row(children: [
                      if (widget.standalone)
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context),
                        )
                      else
                        Icon(Icons.playlist_play_rounded,
                            color: Colors.white, size: 22),
                      const SizedBox(width: 6),
                      Text('My Events',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: context.sp(18),
                          )),
                      const Spacer(),
                      ListenableBuilder(
                        listenable: EventsStore.instance,
                        builder: (_, __) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(14),
                            border:
                                Border.all(color: Colors.white30),
                          ),
                          child: Text(
                            '${EventsStore.instance.myEventsCount} Events',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: context.sp(11),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.info_outline,
                            color: Colors.white, size: 20),
                        onPressed: () => ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              'Browse Events tab to add events to your list'),
                        )),
                      ),
                    ]),
                  ),
                  TabBar(
                    controller: _tabCtrl,
                    indicatorColor: AppColors.accentGold,
                    indicatorWeight: 3,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white54,
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: context.sp(12)),
                    tabs: const [
                      Tab(
                          icon: Icon(Icons.playlist_play_rounded, size: 18),
                          text: 'Playlist'),
                      Tab(
                          icon: Icon(Icons.verified_rounded, size: 18),
                          text: 'Status'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Tab content ───────────────────────────────────────────
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabCtrl,
              children: [
                _buildPlaylistTab(context, cs),
                _buildStatusTab(context, cs),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Playlist Tab ──────────────────────────────────────────────────
  Widget _buildPlaylistTab(BuildContext context, ColorScheme cs) {
    return ListenableBuilder(
      listenable: EventsStore.instance,
      builder: (context, _) {
        final store = EventsStore.instance;
        final myEvents = store.myEvents;

        return Column(
          children: [
            Container(
              color: cs.primary.withValues(alpha: 0.07),
              padding: EdgeInsets.symmetric(
                  horizontal: context.pagePad, vertical: 10),
              child: Row(children: [
                Icon(Icons.drag_indicator_rounded,
                    color: cs.primary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Drag to reorder • Tap − to remove',
                    style: TextStyle(
                      fontSize: context.sp(12),
                      color: context.textSecondary,
                    ),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: myEvents.isEmpty
                  ? _buildEmpty(context, cs)
                  : ReorderableListView.builder(
                      padding: EdgeInsets.all(context.pagePad),
                      itemCount: myEvents.length,
                      onReorder: (oldIndex, newIndex) =>
                          store.reorderMyEvents(oldIndex, newIndex),
                      itemBuilder: (_, i) {
                        final event = myEvents[i];
                        final color = _categoryColor(event.category);
                        return _buildPlaylistTile(
                            context, store, event, i, color);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlaylistTile(BuildContext context, EventsStore store,
      Event event, int index, Color color) {
    return Container(
      key: ValueKey(event.id),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(context.cardRadius + 2),
        border: Border.all(
            color: color.withValues(alpha: 0.25), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.10),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
          ...context.cardShadow,
        ],
      ),
      child: Row(
        children: [
          // Number + drag handle
          Container(
            width: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.18),
                  color.withValues(alpha: 0.08),
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
                const SizedBox(height: 14),
                Text('${index + 1}',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w900,
                      fontSize: context.sp(18),
                    )),
                const SizedBox(height: 6),
                const Icon(Icons.drag_handle_rounded,
                    color: Colors.grey, size: 18),
                const SizedBox(height: 14),
              ],
            ),
          ),

          // Details
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: context.cardPad, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: context.sp(13),
                        color: context.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.calendar_today_outlined,
                        size: 12, color: color),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '${event.date} • ${event.time}',
                        style: TextStyle(
                          fontSize: context.sp(11),
                          color: context.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 2),
                  Row(children: [
                    Icon(Icons.location_on_outlined,
                        size: 12, color: color),
                    const SizedBox(width: 4),
                    Flexible(
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
                    Text(event.performers.join(', '),
                        style: TextStyle(
                          fontSize: context.sp(10),
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ],
              ),
            ),
          ),

          // Category chip + remove
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(event.category,
                      style: TextStyle(
                        color: color,
                        fontSize: context.sp(9),
                        fontWeight: FontWeight.w800,
                      )),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    final title = event.title;
                    store.removeFromMyEvents(event.id);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('$title removed'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () =>
                            store.toggleEvent(event.id),
                      ),
                    ));
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.accentRed.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.remove_rounded,
                        color: AppColors.accentRed, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Status Tab ────────────────────────────────────────────────────
  Widget _buildStatusTab(BuildContext context, ColorScheme cs) {
    return ListenableBuilder(
      listenable: EventsStore.instance,
      builder: (context, _) {
        final myEvents = EventsStore.instance.myEvents;
        if (myEvents.isEmpty) return _buildEmpty(context, cs);

        final confirmed = myEvents
            .where((e) => _eventStatus[e.id] == 'Confirmed')
            .toList();
        final pending = myEvents
            .where((e) => _eventStatus[e.id] != 'Confirmed')
            .toList();

        return SingleChildScrollView(
          padding: EdgeInsets.all(context.pagePad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary chips
              Row(children: [
                _summaryChip(
                    context, '${myEvents.length}', 'Total', cs.primary),
                const SizedBox(width: 10),
                _summaryChip(context, '${confirmed.length}', 'Confirmed',
                    AppColors.successGreen),
                const SizedBox(width: 10),
                _summaryChip(context, '${pending.length}', 'Pending',
                    AppColors.warningYellow),
              ]),
              const SizedBox(height: 24),
              if (confirmed.isNotEmpty) ...[
                _statusHeader(
                    context, 'Confirmed', confirmed.length, AppColors.successGreen),
                const SizedBox(height: 10),
                ...confirmed
                    .map((e) => _buildStatusTile(context, e, 'Confirmed')),
                const SizedBox(height: 20),
              ],
              if (pending.isNotEmpty) ...[
                _statusHeader(
                    context, 'Pending', pending.length, AppColors.warningYellow),
                const SizedBox(height: 10),
                ...pending.map((e) => _buildStatusTile(context, e, 'Pending')),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _summaryChip(BuildContext context, String count, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.14),
              color.withValues(alpha: 0.06),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(children: [
          Text(count,
              style: TextStyle(
                fontSize: context.sp(24),
                fontWeight: FontWeight.w900,
                color: color,
              )),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                fontSize: context.sp(10),
                color: color,
                fontWeight: FontWeight.w700,
              )),
        ]),
      ),
    );
  }

  Widget _statusHeader(BuildContext context, String title, int count, Color color) {
    return Row(children: [
      Container(
        width: 4,
        height: 18,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(2)),
      ),
      const SizedBox(width: 8),
      Text(title,
          style: TextStyle(
            fontSize: context.sp(14),
            fontWeight: FontWeight.w800,
            color: context.textPrimary,
          )),
      const SizedBox(width: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text('$count',
            style: TextStyle(
              color: color,
              fontSize: context.sp(11),
              fontWeight: FontWeight.w800,
            )),
      ),
    ]);
  }

  Widget _buildStatusTile(
      BuildContext context, Event event, String status) {
    final color = _categoryColor(event.category);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(context.cardPad),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(context.cardRadius),
        border: Border.all(
            color: color.withValues(alpha: 0.2)),
        boxShadow: context.cardShadow,
      ),
      child: Row(children: [
        Container(
          width: 4,
          height: 56,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: context.sp(13),
                    color: context.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Row(children: [
                Icon(Icons.calendar_today_outlined,
                    size: 12, color: context.textSecondary),
                const SizedBox(width: 4),
                Flexible(
                  child: Text('${event.date} • ${event.time}',
                      style: TextStyle(
                        fontSize: context.sp(11),
                        color: context.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
              ]),
              const SizedBox(height: 2),
              Row(children: [
                Icon(Icons.location_on_outlined,
                    size: 12, color: context.textSecondary),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(event.location,
                      style: TextStyle(
                        fontSize: context.sp(11),
                        color: context.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis),
                ),
              ]),
            ],
          ),
        ),
        const SizedBox(width: 8),
        StatusBadge(status: status),
      ]),
    );
  }

  Widget _buildEmpty(BuildContext context, ColorScheme cs) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    cs.primary.withValues(alpha: 0.15),
                    cs.primary.withValues(alpha: 0.05),
                  ],
                ),
                border: Border.all(
                    color: cs.primary.withValues(alpha: 0.2)),
              ),
              child: Icon(Icons.playlist_add_rounded,
                  size: 44,
                  color: cs.primary.withValues(alpha: 0.5)),
            ),
            const SizedBox(height: 20),
            Text('No Events Added Yet',
                style: TextStyle(
                  fontSize: context.sp(17),
                  fontWeight: FontWeight.w800,
                  color: context.textPrimary,
                )),
            const SizedBox(height: 8),
            Text(
              'Go to the Events tab to browse\nand add events to your list',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.textSecondary,
                fontSize: context.sp(13),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [cs.primary, const Color(0xFF1E88E5)]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: cs.primary.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to Events tab (index 3 in MainAppScreen)
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: const Icon(Icons.festival_rounded),
                label: const Text('Browse Events'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  textStyle: TextStyle(
                    fontSize: context.sp(14),
                    fontWeight: FontWeight.w800,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}