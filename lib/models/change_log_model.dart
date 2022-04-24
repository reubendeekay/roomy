class ChangeLogModel {
  final double version;
  final String mainDescription;
  final List<dynamic> changes;
  final List<dynamic> imageUrls;
  final String developerEmail;
  final Map<String, dynamic> downloadUrl;

  ChangeLogModel(
      {this.version,
      this.mainDescription,
      this.changes,
      this.imageUrls,
      this.developerEmail,
      this.downloadUrl});
}
