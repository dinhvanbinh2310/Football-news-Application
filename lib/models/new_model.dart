class News {
  final String? id;
  final String title;
  final String content;
  final String? imageUrl;
  final String? description;
  final DateTime createdAt;

  News({
    this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    this.description,
    required this.createdAt,
  });

  // Hàm tạo đối tượng News từ JSON
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['_id'] ?? json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'description': description,
      'createdAt': createdAt?.toIso8601String(), // Định dạng ISO chuẩn
    };
  }
}
