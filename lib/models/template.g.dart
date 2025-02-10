// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TemplateImpl _$$TemplateImplFromJson(Map<String, dynamic> json) =>
    _$TemplateImpl(
      name: json['name'] as String,
      repoUrl: json['repoUrl'] as String,
      postCreateCommands: (json['postCreateCommands'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      branch: json['branch'] as String? ?? 'main',
      description: json['description'] as String?,
      variables: (json['variables'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      cached: json['cached'] as bool? ?? false,
      lastUsed: json['lastUsed'] == null
          ? null
          : DateTime.parse(json['lastUsed'] as String),
    );

Map<String, dynamic> _$$TemplateImplToJson(_$TemplateImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'repoUrl': instance.repoUrl,
      'postCreateCommands': instance.postCreateCommands,
      'branch': instance.branch,
      'description': instance.description,
      'variables': instance.variables,
      'cached': instance.cached,
      'lastUsed': instance.lastUsed?.toIso8601String(),
    };
