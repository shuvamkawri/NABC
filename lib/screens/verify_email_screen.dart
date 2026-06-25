import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import 'main_app_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final List<TextEditingController> _otpCtrl =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _loading = false;
  int _resendSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _resendSeconds = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendSeconds == 0) {
        t.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _otpCtrl) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otp => _otpCtrl.map((c) => c.text).join();

  Future<void> _verify() async {
    if (_otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all 6 digits')),
      );
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainAppScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final boxSize = context.wp(12).clamp(42.0, 56.0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.pagePad),
        child: Column(
          children: [
            SizedBox(height: context.hp(4)),
            Container(
              width: context.wp(20).clamp(68.0, 90.0),
              height: context.wp(20).clamp(68.0, 90.0),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.mark_email_read_outlined,
                  color: cs.primary,
                  size: context.wp(10).clamp(34.0, 46.0)),
            ),
            SizedBox(height: context.hp(3)),
            Text(
              'Check Your Email',
              style: TextStyle(
                fontSize: context.sp(22),
                fontWeight: FontWeight.w900,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We sent a 6-digit OTP to\n${widget.email}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.textSecondary,
                fontSize: context.sp(13),
              ),
            ),
            SizedBox(height: context.hp(5)),
            // OTP boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (i) {
                final isFilled = _otpCtrl[i].text.isNotEmpty;
                final fillColor = context.isDark
                    ? const Color(0xFF2C2C2E)
                    : Colors.white;
                final textColor = context.isDark
                    ? Colors.white
                    : const Color(0xFF1A1A1A);
                final borderColor = context.isDark
                    ? const Color(0xFF3A3A3C)
                    : const Color(0xFFDDDDDD);

                return Container(
                  width: boxSize,
                  height: boxSize * 1.2,
                  margin: EdgeInsets.symmetric(
                      horizontal: context.isSmall ? 3 : 4),
                  child: TextField(
                    controller: _otpCtrl[i],
                    focusNode: _focusNodes[i],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    cursorColor: cs.primary,
                    style: TextStyle(
                      fontSize: context.sp(20),
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: isFilled
                          ? cs.primary.withValues(alpha: 0.08)
                          : fillColor,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: isFilled ? cs.primary : borderColor,
                          width: isFilled ? 1.5 : 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: cs.primary, width: 2),
                      ),
                    ),
                    onChanged: (v) {
                      if (v.isNotEmpty && i < 5) {
                        _focusNodes[i + 1].requestFocus();
                      } else if (v.isEmpty && i > 0) {
                        _focusNodes[i - 1].requestFocus();
                      }
                      setState(() {});
                    },
                  ),
                );
              }),
            ),
            SizedBox(height: context.hp(4)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _verify,
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
                        'Verify & Continue',
                        style: TextStyle(
                          fontSize: context.sp(15),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            if (_resendSeconds > 0)
              Text(
                'Resend OTP in $_resendSeconds seconds',
                style: TextStyle(
                  color: context.textSecondary,
                  fontSize: context.sp(13),
                ),
              )
            else
              TextButton(
                onPressed: () {
                  _startTimer();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('OTP resent to your email.')),
                  );
                },
                child: Text(
                  'Resend OTP',
                  style: TextStyle(
                    color: cs.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: context.sp(14),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}