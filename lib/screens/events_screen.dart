import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/responsive.dart';
import '../models/event_model.dart';
import '../widgets/custom_app_bar.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<Event> allEvents = [
    Event(id: '1', title: 'Inaugural Program', description: 'Opening ceremony of NABC 2026', date: 'July 3, 2026', time: '6:00 PM', location: 'Main Stage', imageUrl: 'https://nabcapp.com/images/slider/1.jpg', category: 'Opening', performers: []),
    Event(id: '2', title: 'Sunday Bollywood Dhamaka', description: 'Experience the magic of Bollywood music', date: 'July 5, 2026', time: '7:00 PM', location: 'Main Stage', imageUrl: 'https://nabcapp.com/images/Vishal-Shekhar.png', category: 'Music', performers: ['Vishal-Shekhar']),
    Event(id: '3', title: 'Saturday Night Spectacular', description: 'Grand celebration of Bengali culture', date: 'July 4, 2026', time: '8:00 PM', location: 'Main Stage', imageUrl: 'https://nabcapp.com/images/Kaushiki.png', category: 'Cultural', performers: ['Shantanu Moitra', 'Kaushiki Chakraborty']),
    Event(id: '4', title: 'Film Festival', description: 'Bengali and Indian cinema showcase', date: 'July 3-5, 2026', time: '2:00 PM', location: 'Cinema Hall', imageUrl: '', category: 'Film', performers: []),
    Event(id: '5', title: 'Fashion Show', description: 'Indian ethnic attire showcase', date: 'July 4, 2026', time: '3:00 PM', location: 'Fashion Arena', imageUrl: '', category: 'Fashion', performers: []),
    Event(id: '6', title: 'NABC Idol Competition', description: 'Talent competition for singers', date: 'July 5, 2026', time: '5:00 PM', location: 'Talent Stage', imageUrl: '', category: 'Competition', performers: []),
    Event(id: '7', title: 'Business Forum', description: 'Professional networking summit', date: 'July 4, 2026', time: '10:00 AM', location: 'Conference Room', imageUrl: '', category: 'Business', performers: []),
    Event(id: '8', title: 'Literary Summit', description: 'Authors and publishers gathering', date: 'July 3, 2026', time: '2:00 PM', location: 'Conference Room', imageUrl: '', category: 'Literature', performers: []),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredEvents = _getFilteredEvents();

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Events',
        subtitle: 'NABC 2026 Schedule',
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(context.pagePad),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search events...',
                prefixIcon: Icon(Icons.search, color: context.textSecondary),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: context.pagePad),
            child: Row(
              children: [
                _buildCategoryChip(context, 'All'),
                _buildCategoryChip(context, 'Music'),
                _buildCategoryChip(context, 'Cultural'),
                _buildCategoryChip(context, 'Film'),
                _buildCategoryChip(context, 'Fashion'),
                _buildCategoryChip(context, 'Business'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filteredEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_note,
                            size: 64,
                            color: context.textSecondary
                                .withValues(alpha: 0.3)),
                        const SizedBox(height: 16),
                        Text(
                          'No events found',
                          style: TextStyle(color: context.textSecondary),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: context.pagePad),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      return _buildEventListTile(
                          context, filteredEvents[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, String category) {
    final isSelected = _selectedCategory == category;
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          category,
          style: TextStyle(fontSize: context.sp(12)),
        ),
        selected: isSelected,
        onSelected: (_) => setState(() => _selectedCategory = category),
        selectedColor: cs.primary,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : context.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEventListTile(BuildContext context, Event event) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(context.cardRadius),
        boxShadow: context.cardShadow,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(context.cardRadius),
        onTap: () => _showEventDetails(context, event),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(context.cardRadius),
                bottomLeft: Radius.circular(context.cardRadius),
              ),
              child: SizedBox(
                width: context.wp(28).clamp(100.0, 130.0),
                height: 110,
                child: event.imageUrl.isNotEmpty
                    ? Image.network(
                        event.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: cs.primary.withValues(alpha: 0.12),
                          child: Icon(Icons.event,
                              color: cs.primary, size: 32),
                        ),
                      )
                    : Container(
                        color: cs.primary.withValues(alpha: 0.12),
                        child: Icon(Icons.event,
                            color: cs.primary, size: 32),
                      ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(context.cardPad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accentRed.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        event.category,
                        style: TextStyle(
                          color: AppColors.accentRed,
                          fontSize: context.sp(10),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: context.sp(13),
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 12, color: context.textSecondary),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            event.date,
                            style: TextStyle(
                              fontSize: context.sp(11),
                              color: context.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 12, color: context.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          event.time,
                          style: TextStyle(
                            fontSize: context.sp(11),
                            color: context.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Event> _getFilteredEvents() {
    var filtered = allEvents;
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((e) => e.category == _selectedCategory)
          .toList();
    }
    if (_searchController.text.isNotEmpty) {
      final q = _searchController.text.toLowerCase();
      filtered = filtered
          .where((e) =>
              e.title.toLowerCase().contains(q) ||
              e.description.toLowerCase().contains(q))
          .toList();
    }
    return filtered;
  }

  void _showEventDetails(BuildContext context, Event event) {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SingleChildScrollView(
        child: Container(
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
              const SizedBox(height: 16),
              Text(
                event.title,
                style: TextStyle(
                  fontSize: context.sp(20),
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: cs.primary, size: 16),
                  const SizedBox(width: 8),
                  Text(event.date,
                      style: TextStyle(color: context.textPrimary)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, color: cs.primary, size: 16),
                  const SizedBox(width: 8),
                  Text(event.time,
                      style: TextStyle(color: context.textPrimary)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, color: cs.primary, size: 16),
                  const SizedBox(width: 8),
                  Text(event.location,
                      style: TextStyle(color: context.textPrimary)),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: context.sp(15),
                  color: context.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(event.description,
                  style: TextStyle(color: context.textSecondary)),
              if (event.performers.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Performers',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: context.sp(15),
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                ...event.performers.map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('• $p',
                          style: TextStyle(color: context.textPrimary)),
                    )),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}