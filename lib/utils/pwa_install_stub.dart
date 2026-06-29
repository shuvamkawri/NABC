// Non-web fallback: PWA install isn't applicable, so everything is a no-op.

bool isInstallReady() => false;
bool isStandalone() => false;
Future<void> promptInstall() async {}
void registerOnReady(void Function() cb) {}