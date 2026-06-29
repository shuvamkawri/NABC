// Web implementation: bridges to the install helpers defined in web/index.html.
import 'dart:js_interop';

@JS('nabcIsInstallReady')
external bool _isInstallReady();

@JS('nabcIsStandalone')
external bool _isStandalone();

@JS('nabcInstall')
external void _install();

@JS('nabcRegisterReady')
external void _registerReady(JSFunction cb);

/// Whether the app can currently be installed (native prompt available, or iOS).
bool isInstallReady() => _isInstallReady();

/// Whether the app is already running as an installed PWA (standalone).
bool isStandalone() => _isStandalone();

/// Trigger the install flow (native prompt, or platform-specific instructions).
Future<void> promptInstall() async => _install();

/// Register a callback fired when the install state changes (prompt becomes
/// available, or the app gets installed).
void registerOnReady(void Function() cb) =>
    _registerReady((() => cb()).toJS);