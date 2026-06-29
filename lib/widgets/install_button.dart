import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../utils/pwa_install.dart' as pwa;

/// A header icon button that lets users install the PWA at any time.
///
/// Renders nothing unless running on the web *and* the app is installable
/// (native install prompt available, or iOS Safari where manual steps are
/// shown). Auto-hides once the app is installed (standalone mode).
class InstallButton extends StatefulWidget {
  final Color? color;
  final double size;
  const InstallButton({super.key, this.color, this.size = 22});

  @override
  State<InstallButton> createState() => _InstallButtonState();
}

class _InstallButtonState extends State<InstallButton> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _ready = pwa.isInstallReady();
      // The native prompt can arrive after load — re-check when it does.
      pwa.registerOnReady(_refresh);
    }
  }

  void _refresh() {
    if (!mounted) return;
    setState(() => _ready = pwa.isInstallReady());
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb || !_ready) return const SizedBox.shrink();
    return IconButton(
      tooltip: 'Install app',
      icon: Icon(
        Icons.install_mobile_rounded,
        color: widget.color ?? Colors.white.withValues(alpha: 0.88),
        size: widget.size,
      ),
      onPressed: () => pwa.promptInstall(),
    );
  }
}