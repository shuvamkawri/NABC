import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../constants/colors.dart';
import '../utils/responsive.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  String _selectedCategory = 'General';
  int _rating = 0;
  XFile? _image;
  Uint8List? _imageBytes;
  Position? _position;
  bool _fetchingLocation = false;
  bool _submitting = false;

  final List<String> _categories = [
    'General', 'Food', 'Accommodation', 'Transportation',
    'Event / Program', 'Volunteer', 'Safety', 'Other',
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      // Read bytes so the preview works on web (no dart:io File).
      final bytes = await picked.readAsBytes();
      if (!mounted) return;
      setState(() {
        _image = picked;
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _fetchLocation() async {
    setState(() => _fetchingLocation = true);
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever) {
        setState(() => _fetchingLocation = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Location permission denied. Enable in settings.')),
        );
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
          locationSettings:
              const LocationSettings(accuracy: LocationAccuracy.high));
      setState(() {
        _position = pos;
        _fetchingLocation = false;
      });
    } catch (e) {
      setState(() => _fetchingLocation = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not get location: $e')),
      );
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a rating')),
      );
      return;
    }
    setState(() => _submitting = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _submitting = false);
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Feedback Submitted'),
        content: const Text(
            'Thank you for your feedback! Your input helps us improve NABC 2026.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.pagePad),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRatingCard(context),
              const SizedBox(height: 16),
              _buildFormCard(context),
              const SizedBox(height: 16),
              _buildPhotoCard(context),
              const SizedBox(height: 16),
              _buildLocationCard(context),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : Text(
                          'Submit Feedback',
                          style: TextStyle(
                            fontSize: context.sp(15),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.cardPad),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(context.cardRadius),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        children: [
          Text(
            'Overall Rating',
            style: TextStyle(
              fontSize: context.sp(15),
              fontWeight: FontWeight.w800,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              return GestureDetector(
                onTap: () => setState(() => _rating = i + 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    i < _rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: AppColors.accentGold,
                    size: context.isSmall ? 34 : 40,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            _rating == 0
                ? 'Tap to rate'
                : ['', 'Poor', 'Fair', 'Good', 'Very Good', 'Excellent'][_rating],
            style: TextStyle(
              color: _rating == 0
                  ? context.textSecondary
                  : AppColors.accentGold,
              fontWeight: FontWeight.w700,
              fontSize: context.sp(13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.cardPad),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(context.cardRadius),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Feedback Details',
            style: TextStyle(
              fontSize: context.sp(15),
              fontWeight: FontWeight.w800,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Category',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: context.sp(13),
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            dropdownColor: context.cardBg,
            style: TextStyle(
                color: context.textPrimary, fontSize: context.sp(13)),
            items: _categories
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => _selectedCategory = v!),
          ),
          const SizedBox(height: 14),
          Text(
            'Subject',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: context.sp(13),
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _titleCtrl,
            style: TextStyle(color: context.textPrimary),
            decoration: const InputDecoration(
              hintText: 'Brief subject of your feedback',
            ),
            validator: (v) =>
                v == null || v.isEmpty ? 'Subject is required' : null,
          ),
          const SizedBox(height: 14),
          Text(
            'Message',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: context.sp(13),
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _messageCtrl,
            maxLines: 5,
            style: TextStyle(color: context.textPrimary),
            decoration: const InputDecoration(
              hintText: 'Share your feedback, suggestions, or concerns...',
            ),
            validator: (v) =>
                v == null || v.isEmpty ? 'Message is required' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.cardPad),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(context.cardRadius),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attach Photo (optional)',
            style: TextStyle(
              fontSize: context.sp(15),
              fontWeight: FontWeight.w800,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          if (_imageBytes != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(
                _imageBytes!,
                height: context.hp(20).clamp(130.0, 180.0),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () => setState(() {
                _image = null;
                _imageBytes = null;
              }),
              icon: const Icon(Icons.delete_outline,
                  color: AppColors.accentRed, size: 16),
              label: const Text('Remove photo',
                  style: TextStyle(color: AppColors.accentRed)),
            ),
          ] else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_outlined, size: 18),
                    label: const Text('Camera'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined, size: 18),
                    label: const Text('Gallery'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.cardPad),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(context.cardRadius),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location (optional)',
            style: TextStyle(
              fontSize: context.sp(15),
              fontWeight: FontWeight.w800,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Share your location so we can better understand the issue context.',
            style: TextStyle(
              color: context.textSecondary,
              fontSize: context.sp(12),
            ),
          ),
          const SizedBox(height: 12),
          if (_position != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.successGreen.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.successGreen.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on,
                      color: AppColors.successGreen, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location captured',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.successGreen,
                            fontSize: context.sp(12),
                          ),
                        ),
                        Text(
                          'Lat: ${_position!.latitude.toStringAsFixed(5)}, Lng: ${_position!.longitude.toStringAsFixed(5)}',
                          style: TextStyle(
                            color: context.textSecondary,
                            fontSize: context.sp(11),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _position = null),
                    child: Icon(Icons.close,
                        color: context.textSecondary, size: 16),
                  ),
                ],
              ),
            ),
          ] else
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _fetchingLocation ? null : _fetchLocation,
                icon: _fetchingLocation
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child:
                            CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.my_location_outlined, size: 18),
                label: Text(_fetchingLocation
                    ? 'Getting location...'
                    : 'Include My Location'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}