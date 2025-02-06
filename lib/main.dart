import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_template_cli/commands/create_command.dart';
import 'package:flutter_template_cli/commands/list_command.dart';
import 'package:flutter_template_cli/commands/add_command.dart';
import 'package:flutter_template_cli/commands/remove_command.dart';
import 'package:flutter_template_cli/commands/edit_command.dart';

void main(List<String> arguments) async {
  final runner = CommandRunner('flt', 'Flutter Template CLI')
    ..addCommand(CreateCommand())
    ..addCommand(ListCommand())
    ..addCommand(AddCommand())
    ..addCommand(RemoveCommand())
    ..addCommand(EditCommand());

  try {
    await runner.run(arguments);
  } catch (e) {
    print('Error: $e');
    exit(64);
  }
}
