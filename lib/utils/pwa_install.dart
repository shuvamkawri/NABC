// Cross-platform PWA install facade. Resolves to the web implementation when
// compiled for the web, and a no-op stub otherwise.
export 'pwa_install_stub.dart'
    if (dart.library.js_interop) 'pwa_install_web.dart';