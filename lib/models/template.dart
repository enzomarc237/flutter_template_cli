import 'package:freezed_annotation/freezed_annotation.dart';

part 'template.freezed.dart';
part 'template.g.dart';

@freezed
class Template with _$Template {
  factory Template({
    required String name,
    required String repoUrl,
    @Default([]) List<String> postCreateCommands,
    @Default('main') String branch,
    String? description,
    @Default({}) Map<String, String> variables,
    @Default(false) bool cached,
    DateTime? lastUsed,
  }) = _Template;

  factory Template.fromJson(Map<String, dynamic> json) => _$TemplateFromJson(json);
}
