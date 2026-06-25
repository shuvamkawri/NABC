import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/responsive.dart';
import '../services/attendee_service.dart';
import '../utils/session.dart';
import '../utils/us_phone_formatter.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      debugPrint('🔐 [LOGIN] validation failed — aborting');
      return;
    }
    FocusScope.of(context).unfocus();
    final phone = '+1 ${_phoneCtrl.text.trim()}';
    debugPrint('🔐 [LOGIN] login tapped with "$phone"');
    setState(() => _loading = true);
    try {
      final attendee = await AttendeeService.findByPhone(phone);
      await Session.signIn(attendee);
      if (!mounted) return;
      debugPrint('✅ [LOGIN] session started → navigating to dashboard');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        ),
      );
    } on AttendeeException catch (e) {
      debugPrint('❌ [LOGIN] AttendeeException: ${e.message}');
      if (!mounted) return;
      _showError(e.message);
    } catch (e, st) {
      debugPrint('🚨 [LOGIN] unexpected error: $e\n$st');
      if (!mounted) return;
      _showError('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.accentRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pad = context.pagePad;
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(pad),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.hp(4)),
                // Logo area
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: context.wp(22).clamp(76.0, 100.0),
                        height: context.wp(22).clamp(76.0, 100.0),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: AppColors.primaryGradient,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryBlue.withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(Icons.celebration,
                            color: Colors.white,
                            size: context.wp(12).clamp(36.0, 52.0)),
                      ),
                      SizedBox(height: context.hp(2)),
                      Text(
                        'NABC 2026',
                        style: TextStyle(
                          fontSize: context.sp(26),
                          fontWeight: FontWeight.w900,
                          color: cs.primary,
                        ),
                      ),
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: context.sp(14),
                          color: context.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.hp(4)),
                Text(
                  'Phone Number',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: context.sp(13),
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [UsPhoneInputFormatter()],
                  decoration: _inputDeco(context,
                      '000-000-0000', Icons.phone_outlined),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Phone number is required';
                    }
                    final digits = v.replaceAll(RegExp(r'\D'), '');
                    if (digits.length < 10) {
                      return 'Enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            'Login',
                            style: TextStyle(
                              fontSize: context.sp(15),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: context.hp(2)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(
      BuildContext context, String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: context.textSecondary),
      prefixText: '+1 ',
      prefixStyle: TextStyle(
        color: context.textPrimary,
        fontWeight: FontWeight.w600,
        fontSize: context.sp(15),
      ),
    );
  }
}