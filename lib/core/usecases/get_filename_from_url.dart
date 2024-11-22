String getFileNameFromUrl(String url) {
  Uri uri = Uri.parse(url);

  return uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
}
