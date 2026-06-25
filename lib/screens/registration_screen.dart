import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../widgets/custom_app_bar.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  String _selectedCategory = 'General Registrant';
  bool _acceptTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<String> _categories = [
    'General Registrant',
    'Sponsor',
    'Exhibitor',
    'Performer',
    'Volunteer',
  ];

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Registration',
        subtitle: 'NABC 2026',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.pagePad),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(context.cardPad),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(context.cardRadius),
                  border: Border.all(color: cs.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: cs.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Limited spots available. Register early to secure your place!',
                        style: TextStyle(
                          color: context.textPrimary,
                          fontSize: context.sp(13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _fieldLabel(context, 'First Name *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _firstNameCtrl,
                style: TextStyle(color: context.textPrimary),
                decoration: const InputDecoration(hintText: 'Enter your first name'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'First name is required' : null,
              ),
              const SizedBox(height: 16),

              _fieldLabel(context, 'Last Name *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _lastNameCtrl,
                style: TextStyle(color: context.textPrimary),
                decoration: const InputDecoration(hintText: 'Enter your last name'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Last name is required' : null,
              ),
              const SizedBox(height: 16),

              _fieldLabel(context, 'Email Address *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: context.textPrimary),
                decoration:
                    const InputDecoration(hintText: 'your.email@example.com'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email is required';
                  if (!v.contains('@')) return 'Please enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _fieldLabel(context, 'Phone Number *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: context.textPrimary),
                decoration:
                    const InputDecoration(hintText: '+1 (555) 123-4567'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Phone number is required' : null,
              ),
              const SizedBox(height: 16),

              _fieldLabel(context, 'Password *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordCtrl,
                obscureText: _obscurePassword,
                style: TextStyle(color: context.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Create a password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: context.textSecondary,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Password is required';
                  if (v.length < 6) return 'Minimum 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _fieldLabel(context, 'Confirm Password *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _confirmPasswordCtrl,
                obscureText: _obscureConfirmPassword,
                style: TextStyle(color: context.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Re-enter your password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: context.textSecondary,
                    ),
                    onPressed: () => setState(
                        () => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please confirm your password';
                  if (v != _passwordCtrl.text) return 'Passwords do not match';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _fieldLabel(context, 'Registration Category *'),
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
              const SizedBox(height: 20),

              Container(
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
                      'Pricing',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: context.sp(15),
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Registration Fee (3-days):',
                            style: TextStyle(
                              color: context.textPrimary,
                              fontSize: context.sp(13),
                            ),
                          ),
                        ),
                        Text(
                          '\$150',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: context.sp(15),
                            color: context.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Accommodation (Optional):',
                            style: TextStyle(
                              color: context.textPrimary,
                              fontSize: context.sp(13),
                            ),
                          ),
                        ),
                        Text(
                          'Book separately',
                          style: TextStyle(
                            color: context.textSecondary,
                            fontSize: context.sp(12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              CheckboxListTile(
                value: _acceptTerms,
                onChanged: (v) => setState(() => _acceptTerms = v!),
                title: Text(
                  'I agree to the Terms & Conditions',
                  style: TextStyle(
                    fontSize: context.sp(13),
                    color: context.textPrimary,
                  ),
                ),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: cs.primary,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _acceptTerms ? _submitForm : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Complete Registration',
                    style: TextStyle(
                      fontSize: context.sp(15),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Center(
                child: GestureDetector(
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Attendee lookup feature coming soon!')),
                  ),
                  child: Text(
                    'Already Registered? Look up your registration',
                    style: TextStyle(
                      color: cs.primary,
                      decoration: TextDecoration.underline,
                      fontSize: context.sp(13),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(BuildContext context, String label) {
    return Text(
      label,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: context.sp(13),
        color: context.textPrimary,
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    final cs = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Registration Successful!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thank you for registering, ${_firstNameCtrl.text}!'),
            const SizedBox(height: 12),
            const Text('A confirmation email will be sent to:'),
            const SizedBox(height: 4),
            Text(
              _emailCtrl.text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
            const SizedBox(height: 12),
            const Text('Keep your registration ID for check-in.'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text('Go to Login'),
          ),
        ],
      ),
    );
  }
}