class BugReport {
  final String description;
  final String screenshotUrl;
  final String appVersion;
  final String reporter;

  BugReport({
    required this.description,
    required this.screenshotUrl,
    required this.appVersion,
    required this.reporter,
  });

  factory BugReport.fromJson(Map<String, dynamic> json) {
    return BugReport(
      description: json['description'],
      screenshotUrl: json['screenshot_url'],
      appVersion: json['app_version'],
      reporter: json['reporter'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'screenshot_url': screenshotUrl,
      'app_version': appVersion,
      'reporter': reporter,
    };
  }

  BugReport copyWith({
    String? description,
    String? screenshotUrl,
    String? appVersion,
    String? reporter,
  }) {
    return BugReport(
      description: description ?? this.description,
      screenshotUrl: screenshotUrl ?? this.screenshotUrl,
      appVersion: appVersion ?? this.appVersion,
      reporter: reporter ?? this.reporter,
    );
  }
}
