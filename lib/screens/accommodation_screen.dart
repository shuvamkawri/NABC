import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/event_model.dart';
import '../utils/responsive.dart';
import '../widgets/custom_app_bar.dart';

class AccommodationScreen extends StatefulWidget {
  const AccommodationScreen({super.key});

  @override
  State<AccommodationScreen> createState() => _AccommodationScreenState();
}

class _AccommodationScreenState extends State<AccommodationScreen> {
  final List<Accommodation> accommodations = [
    Accommodation(
      id: '1',
      name: 'The OPUS White Plains',
      address: '3 Renaissance Square, White Plains, NY 10601',
      distanceFromVenue: 0.9,
      travelTimeMinutes: 4,
      ratePerNight: 0,
      imageUrl: 'https://via.placeholder.com/400x200?text=OPUS',
      phone: '+1 (914) 333-1111',
      website: 'www.theopuswhiteplains.com',
      amenities: ['Free WiFi', 'Gym', 'Pool', 'Restaurant'],
      tier: 'Premium',
    ),
    Accommodation(
      id: '2',
      name: 'Westchester Marriott',
      address: '670 White Plains Rd, Tarrytown, NY 10591',
      distanceFromVenue: 4.0,
      travelTimeMinutes: 9,
      ratePerNight: 0,
      imageUrl: 'https://via.placeholder.com/400x200?text=Marriott',
      phone: '+1 (914) 631-5700',
      website: 'www.marriott.com',
      amenities: ['Free WiFi', 'Gym', 'Pool', 'Business Center'],
      tier: 'Premium',
    ),
    Accommodation(
      id: '3',
      name: 'Hampton Inn White Plains',
      address: '200 West Main Street, Elmsford, NY 10523',
      distanceFromVenue: 3.7,
      travelTimeMinutes: 7,
      ratePerNight: 179,
      imageUrl: 'https://via.placeholder.com/400x200?text=Hampton',
      phone: '+1 (914) 592-5680',
      website: 'www.hamptoninn.com',
      amenities: ['Free WiFi', 'Gym', 'Complimentary Breakfast'],
      tier: 'Standard',
    ),
    Accommodation(
      id: '4',
      name: 'Sonesta White Plains Downtown',
      address: '66 Hale Ave, White Plains, NY 10601',
      distanceFromVenue: 1.7,
      travelTimeMinutes: 7,
      ratePerNight: 199,
      imageUrl: 'https://via.placeholder.com/400x200?text=Sonesta',
      phone: '+1 (914) 640-5500',
      website: 'www.sonesta.com',
      amenities: ['Free WiFi', 'Gym', 'Restaurant', 'Bar'],
      tier: 'Standard',
    ),
    Accommodation(
      id: '5',
      name: 'Springhill Suites',
      address: '480 White Plains Road, Tarrytown, NY 10591',
      distanceFromVenue: 4.9,
      travelTimeMinutes: 9,
      ratePerNight: 185,
      imageUrl: 'https://via.placeholder.com/400x200?text=Springhill',
      phone: '+1 (914) 592-5680',
      website: 'www.springhillsuites.com',
      amenities: ['Free WiFi', 'Gym', 'Kitchenette'],
      tier: 'Standard',
    ),
    Accommodation(
      id: '6',
      name: 'Hyatt House White Plains',
      address: '101 Corporate Park Drive, West Harrison, NY',
      distanceFromVenue: 3.8,
      travelTimeMinutes: 10,
      ratePerNight: 0,
      imageUrl: 'https://via.placeholder.com/400x200?text=Hyatt',
      phone: '+1 (914) 333-1234',
      website: 'www.hyatthouse.com',
      amenities: ['Free WiFi', 'Full Kitchen', 'Gym'],
      tier: 'Premium',
    ),
  ];

  String _selectedTier = 'All';

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedTier == 'All'
        ? accommodations
        : accommodations.where((a) => a.tier == _selectedTier).toList();

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Accommodation',
        subtitle: 'Book Your Stay',
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(context.pagePad),
            child: Row(
              children: [
                _chip(context, 'All'),
                const SizedBox(width: 8),
                _chip(context, 'Premium'),
                const SizedBox(width: 8),
                _chip(context, 'Standard'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: context.pagePad),
              itemCount: filtered.length,
              itemBuilder: (context, index) =>
                  _buildHotelCard(context, filtered[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String tier) {
    final cs = Theme.of(context).colorScheme;
    final selected = _selectedTier == tier;
    return FilterChip(
      label: Text(tier, style: TextStyle(fontSize: context.sp(12))),
      selected: selected,
      onSelected: (_) => setState(() => _selectedTier = tier),
      selectedColor: cs.primary,
      labelStyle: TextStyle(
        color: selected ? Colors.white : context.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildHotelCard(BuildContext context, Accommodation hotel) {
    final cs = Theme.of(context).colorScheme;
    final imageH = context.hp(22).clamp(150.0, 220.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(context.cardRadius),
        boxShadow: context.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.cardRadius),
        child: InkWell(
          onTap: () => _showHotelDetails(context, hotel),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: imageH,
                    width: double.infinity,
                    child: Image.network(
                      hotel.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: context.surfaceBg,
                        child: Center(
                          child: Icon(Icons.hotel,
                              color: context.textSecondary, size: 40),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: hotel.tier == 'Premium'
                            ? AppColors.accentGold
                            : AppColors.successGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        hotel.tier,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: context.sp(11),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(context.cardPad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotel.name,
                      style: TextStyle(
                        fontSize: context.sp(16),
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 14, color: context.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            hotel.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: context.textSecondary,
                              fontSize: context.sp(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _statCol(context, 'Distance',
                              '${hotel.distanceFromVenue} mi'),
                        ),
                        Expanded(
                          child: _statCol(context, 'Travel Time',
                              '${hotel.travelTimeMinutes} mins'),
                        ),
                        Expanded(
                          child: _statCol(
                            context,
                            'Per Night',
                            hotel.ratePerNight > 0
                                ? '\$${hotel.ratePerNight.toStringAsFixed(0)}'
                                : 'Contact',
                            valueColor: AppColors.accentRed,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: hotel.amenities
                          .map((a) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: cs.primary.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  a,
                                  style: TextStyle(
                                    fontSize: context.sp(10),
                                    color: cs.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCol(BuildContext context, String label, String value,
      {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: context.sp(10),
            color: context.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: context.sp(12),
            color: valueColor ?? context.textPrimary,
          ),
        ),
      ],
    );
  }

  void _showHotelDetails(BuildContext context, Accommodation hotel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SingleChildScrollView(
        child: Padding(
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
                hotel.name,
                style: TextStyle(
                  fontSize: context.sp(20),
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                hotel.address,
                style: TextStyle(
                  color: context.textSecondary,
                  fontSize: context.sp(13),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Amenities',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: context.sp(15),
                  color: context.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: hotel.amenities
                    .map((a) => Chip(
                          label: Text(a,
                              style: TextStyle(
                                  fontSize: context.sp(12),
                                  color: context.textPrimary)),
                          backgroundColor: context.surfaceBg,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rate per Night:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                      fontSize: context.sp(13),
                    ),
                  ),
                  Text(
                    hotel.ratePerNight > 0
                        ? '\$${hotel.ratePerNight.toStringAsFixed(0)}'
                        : 'Contact Hotel',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: context.sp(17),
                      color: AppColors.accentRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Visiting ${hotel.website}...')),
                    );
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Book Now'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}