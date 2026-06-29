/// Resolves a backend image reference to a URL that `Image.network` can load.
///
/// Admin-uploaded images (banners, advertisements, feedback photos) are now
/// stored in S3, so the API returns a full `https://…s3…/nabc/…` URL — those
/// pass through unchanged. Legacy rows may still hold a relative `/uploads/…`
/// path; those are prefixed with the backend origin (derived from `API_BASE`)
/// so old images keep working until they are migrated.
library;

const String _apiBase = String.fromEnvironment(
  'API_BASE',
  defaultValue: 'https://shanviaconsulting.com/api',
);

/// scheme://host[:port] of the backend, or '' when API_BASE is a relative
/// proxy path (then relative image paths stay same-origin).
String _origin() => _apiBase.startsWith('http') ? Uri.parse(_apiBase).origin : '';

/// - empty/null            → ''
/// - absolute (http/https) → returned unchanged (e.g. S3 URLs)
/// - relative (/uploads/…) → prefixed with the backend origin
String resolveImageUrl(String? raw) {
  final v = (raw ?? '').trim();
  if (v.isEmpty) return '';
  if (v.startsWith('http://') || v.startsWith('https://')) return v;
  final origin = _origin();
  if (origin.isEmpty) return v; // relative API base (proxy) → same-origin path
  return '$origin${v.startsWith('/') ? '' : '/'}$v';
}