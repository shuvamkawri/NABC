import 'package:flutter/services.dart';

/// Formats input as a US phone number while typing, e.g. `832-276-2558`.
///
/// The `+1 ` country code is shown separately as a field prefix (so it is not
/// part of the editable text), which keeps digit handling unambiguous. Combine
/// the field value with `+1 ` to match the backend's stored format.
class UsPhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Keep digits only, drop a leading US country code, cap at 10 digits.
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 11 && digits.startsWith('1')) {
      digits = digits.substring(1);
    }
    if (digits.length > 10) digits = digits.substring(0, 10);

    final text = _format(digits);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  static String _format(String digits) {
    if (digits.isEmpty) return '';
    final buf =
        StringBuffer(digits.substring(0, digits.length < 3 ? digits.length : 3));
    if (digits.length >= 4) {
      final pre = digits.substring(3, digits.length < 6 ? digits.length : 6);
      buf.write('-$pre');
    }
    if (digits.length >= 7) {
      final line = digits.substring(6, digits.length < 10 ? digits.length : 10);
      buf.write('-$line');
    }
    return buf.toString();
  }
}
