import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/responsive.dart';

class FindFriendScreen extends StatefulWidget {
  const FindFriendScreen({super.key});

  @override
  State<FindFriendScreen> createState() => _FindFriendScreenState();
}

class _FindFriendScreenState extends State<FindFriendScreen> {
  final _searchCtrl = TextEditingController();
  bool _searching = false;
  bool _searched = false;
  String _searchMode = 'name';

  final List<Map<String, String>> _mockResults = [
    {'name': 'Riya Chatterjee', 'phone': '+1 555-101', 'city': 'New York, NY', 'registered': 'Yes', 'badge': 'NABC-2026-1023'},
    {'name': 'Sourav Ghosh', 'phone': '+1 555-202', 'city': 'New Jersey, NJ', 'registered': 'Yes', 'badge': 'NABC-2026-2041'},
    {'name': 'Ananya Bose', 'phone': '+1 555-303', 'city': 'Boston, MA', 'registered': 'Yes', 'badge': 'NABC-2026-3089'},
  ];

  List<Map<String, String>> _results = [];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    if (_searchCtrl.text.trim().isEmpty) return;
    setState(() {
      _searching = true;
      _searched = false;
    });
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _searching = false;
      _searched = true;
      _results = _mockResults
          .where((r) => _searchMode == 'name'
              ? r['name']!
                  .toLowerCase()
                  .contains(_searchCtrl.text.toLowerCase())
              : r['phone']!.contains(_searchCtrl.text))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find Friend & Family')),
      body: Column(
        children: [
          Container(
            color: context.cardBg,
            padding: EdgeInsets.all(context.pagePad),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _modeButton(
                        context,
                        label: 'By Name',
                        icon: Icons.person_search,
                        active: _searchMode == 'name',
                        onTap: () => setState(() => _searchMode = 'name'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _modeButton(
                        context,
                        label: 'By Phone',
                        icon: Icons.phone_outlined,
                        active: _searchMode == 'phone',
                        onTap: () => setState(() => _searchMode = 'phone'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        keyboardType: _searchMode == 'phone'
                            ? TextInputType.phone
                            : TextInputType.name,
                        decoration: InputDecoration(
                          hintText: _searchMode == 'name'
                              ? 'Search by full name...'
                              : 'Search by phone number...',
                          prefixIcon: Icon(
                            _searchMode == 'name'
                                ? Icons.person_search
                                : Icons.phone_outlined,
                            color: context.textSecondary,
                          ),
                        ),
                        onSubmitted: (_) => _search(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _searching ? null : _search,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _searching
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.search),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _searching
                ? const Center(child: CircularProgressIndicator())
                : !_searched
                    ? _buildHint(context)
                    : _results.isEmpty
                        ? _buildNotFound(context)
                        : ListView.builder(
                            padding: EdgeInsets.all(context.pagePad),
                            itemCount: _results.length,
                            itemBuilder: (_, i) =>
                                _buildResultTile(context, _results[i]),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _modeButton(BuildContext context,
      {required String label,
      required IconData icon,
      required bool active,
      required VoidCallback onTap}) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? cs.primary : context.surfaceBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 16,
                color: active ? Colors.white : context.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : context.textSecondary,
                fontWeight: FontWeight.w700,
                fontSize: context.sp(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHint(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_alt_outlined,
              size: 80,
              color: context.textSecondary.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            'Search for a friend or family member',
            style: TextStyle(
              color: context.textSecondary,
              fontSize: context.sp(14),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Results are shown from registered attendees only',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.textSecondary,
              fontSize: context.sp(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off_outlined,
              size: 60,
              color: context.textSecondary.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            'No registered attendee found',
            style: TextStyle(
              color: context.textSecondary,
              fontSize: context.sp(14),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try searching by a different name or phone number',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.textSecondary,
              fontSize: context.sp(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultTile(BuildContext context, Map<String, String> person) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(context.cardPad),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(context.cardRadius),
        boxShadow: context.cardShadow,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: cs.primary.withValues(alpha: 0.12),
            child: Text(
              person['name']![0],
              style: TextStyle(
                color: cs.primary,
                fontWeight: FontWeight.w800,
                fontSize: context.sp(17),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person['name']!,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: context.sp(14),
                    color: context.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.phone_outlined,
                        size: 12, color: context.textSecondary),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        person['phone']!,
                        style: TextStyle(
                          color: context.textSecondary,
                          fontSize: context.sp(12),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 12, color: context.textSecondary),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        person['city']!,
                        style: TextStyle(
                          color: context.textSecondary,
                          fontSize: context.sp(12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.successGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'ID: ${person['badge']}',
                    style: TextStyle(
                      color: AppColors.successGreen,
                      fontSize: context.sp(10),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.message_outlined,
                color: cs.primary, size: 20),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Message sent to ${person['name']}')),
            ),
          ),
        ],
      ),
    );
  }
}