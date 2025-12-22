class HackerNewsModel {
  final int id;
  final String author;
  final String title;
  final String url;
  final String updatedAt;

  HackerNewsModel({
    required this.id,
    required this.author,
    required this.title,
    required this.url,
    required this.updatedAt,
  });

  factory HackerNewsModel.formJson(Map<String, dynamic> json) =>
      HackerNewsModel(
        id: json["story_id"] ?? 0,
        author: json["author"] ?? "",
        title: json["title"] ?? "",
        url: json["url"] ?? "",
        updatedAt: json["updated_at"] ?? "",
      );
}
