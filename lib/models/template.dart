class Template {
  final String name;
  final String repoUrl;
  final List<String> postCreateCommands;

  Template({
    required this.name,
    required this.repoUrl,
    this.postCreateCommands = const [],
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'repoUrl': repoUrl,
        'postCreateCommands': postCreateCommands,
      };

  factory Template.fromJson(Map<String, dynamic> json) => Template(
        name: json['name'],
        repoUrl: json['repoUrl'],
        postCreateCommands: List<String>.from(json['postCreateCommands'] ?? []),
      );
}
