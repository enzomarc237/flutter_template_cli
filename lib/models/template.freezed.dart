// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Template _$TemplateFromJson(Map<String, dynamic> json) {
  return _Template.fromJson(json);
}

/// @nodoc
mixin _$Template {
  String get name => throw _privateConstructorUsedError;
  String get repoUrl => throw _privateConstructorUsedError;
  List<String> get postCreateCommands => throw _privateConstructorUsedError;
  String get branch => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<String, String> get variables => throw _privateConstructorUsedError;
  bool get cached => throw _privateConstructorUsedError;
  DateTime? get lastUsed => throw _privateConstructorUsedError;

  /// Serializes this Template to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Template
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateCopyWith<Template> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateCopyWith<$Res> {
  factory $TemplateCopyWith(Template value, $Res Function(Template) then) =
      _$TemplateCopyWithImpl<$Res, Template>;
  @useResult
  $Res call(
      {String name,
      String repoUrl,
      List<String> postCreateCommands,
      String branch,
      String? description,
      Map<String, String> variables,
      bool cached,
      DateTime? lastUsed});
}

/// @nodoc
class _$TemplateCopyWithImpl<$Res, $Val extends Template>
    implements $TemplateCopyWith<$Res> {
  _$TemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Template
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? repoUrl = null,
    Object? postCreateCommands = null,
    Object? branch = null,
    Object? description = freezed,
    Object? variables = null,
    Object? cached = null,
    Object? lastUsed = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      repoUrl: null == repoUrl
          ? _value.repoUrl
          : repoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      postCreateCommands: null == postCreateCommands
          ? _value.postCreateCommands
          : postCreateCommands // ignore: cast_nullable_to_non_nullable
              as List<String>,
      branch: null == branch
          ? _value.branch
          : branch // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      variables: null == variables
          ? _value.variables
          : variables // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      cached: null == cached
          ? _value.cached
          : cached // ignore: cast_nullable_to_non_nullable
              as bool,
      lastUsed: freezed == lastUsed
          ? _value.lastUsed
          : lastUsed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemplateImplCopyWith<$Res>
    implements $TemplateCopyWith<$Res> {
  factory _$$TemplateImplCopyWith(
          _$TemplateImpl value, $Res Function(_$TemplateImpl) then) =
      __$$TemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String repoUrl,
      List<String> postCreateCommands,
      String branch,
      String? description,
      Map<String, String> variables,
      bool cached,
      DateTime? lastUsed});
}

/// @nodoc
class __$$TemplateImplCopyWithImpl<$Res>
    extends _$TemplateCopyWithImpl<$Res, _$TemplateImpl>
    implements _$$TemplateImplCopyWith<$Res> {
  __$$TemplateImplCopyWithImpl(
      _$TemplateImpl _value, $Res Function(_$TemplateImpl) _then)
      : super(_value, _then);

  /// Create a copy of Template
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? repoUrl = null,
    Object? postCreateCommands = null,
    Object? branch = null,
    Object? description = freezed,
    Object? variables = null,
    Object? cached = null,
    Object? lastUsed = freezed,
  }) {
    return _then(_$TemplateImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      repoUrl: null == repoUrl
          ? _value.repoUrl
          : repoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      postCreateCommands: null == postCreateCommands
          ? _value._postCreateCommands
          : postCreateCommands // ignore: cast_nullable_to_non_nullable
              as List<String>,
      branch: null == branch
          ? _value.branch
          : branch // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      variables: null == variables
          ? _value._variables
          : variables // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      cached: null == cached
          ? _value.cached
          : cached // ignore: cast_nullable_to_non_nullable
              as bool,
      lastUsed: freezed == lastUsed
          ? _value.lastUsed
          : lastUsed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TemplateImpl implements _Template {
  _$TemplateImpl(
      {required this.name,
      required this.repoUrl,
      final List<String> postCreateCommands = const [],
      this.branch = 'main',
      this.description,
      final Map<String, String> variables = const {},
      this.cached = false,
      this.lastUsed})
      : _postCreateCommands = postCreateCommands,
        _variables = variables;

  factory _$TemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemplateImplFromJson(json);

  @override
  final String name;
  @override
  final String repoUrl;
  final List<String> _postCreateCommands;
  @override
  @JsonKey()
  List<String> get postCreateCommands {
    if (_postCreateCommands is EqualUnmodifiableListView)
      return _postCreateCommands;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_postCreateCommands);
  }

  @override
  @JsonKey()
  final String branch;
  @override
  final String? description;
  final Map<String, String> _variables;
  @override
  @JsonKey()
  Map<String, String> get variables {
    if (_variables is EqualUnmodifiableMapView) return _variables;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_variables);
  }

  @override
  @JsonKey()
  final bool cached;
  @override
  final DateTime? lastUsed;

  @override
  String toString() {
    return 'Template(name: $name, repoUrl: $repoUrl, postCreateCommands: $postCreateCommands, branch: $branch, description: $description, variables: $variables, cached: $cached, lastUsed: $lastUsed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.repoUrl, repoUrl) || other.repoUrl == repoUrl) &&
            const DeepCollectionEquality()
                .equals(other._postCreateCommands, _postCreateCommands) &&
            (identical(other.branch, branch) || other.branch == branch) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._variables, _variables) &&
            (identical(other.cached, cached) || other.cached == cached) &&
            (identical(other.lastUsed, lastUsed) ||
                other.lastUsed == lastUsed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      repoUrl,
      const DeepCollectionEquality().hash(_postCreateCommands),
      branch,
      description,
      const DeepCollectionEquality().hash(_variables),
      cached,
      lastUsed);

  /// Create a copy of Template
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateImplCopyWith<_$TemplateImpl> get copyWith =>
      __$$TemplateImplCopyWithImpl<_$TemplateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TemplateImplToJson(
      this,
    );
  }
}

abstract class _Template implements Template {
  factory _Template(
      {required final String name,
      required final String repoUrl,
      final List<String> postCreateCommands,
      final String branch,
      final String? description,
      final Map<String, String> variables,
      final bool cached,
      final DateTime? lastUsed}) = _$TemplateImpl;

  factory _Template.fromJson(Map<String, dynamic> json) =
      _$TemplateImpl.fromJson;

  @override
  String get name;
  @override
  String get repoUrl;
  @override
  List<String> get postCreateCommands;
  @override
  String get branch;
  @override
  String? get description;
  @override
  Map<String, String> get variables;
  @override
  bool get cached;
  @override
  DateTime? get lastUsed;

  /// Create a copy of Template
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateImplCopyWith<_$TemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
