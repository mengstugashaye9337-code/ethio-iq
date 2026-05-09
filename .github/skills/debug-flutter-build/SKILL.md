---
name: debug-flutter-build
description: Use when: debugging and fixing Flutter build compilation errors, such as missing parameters, undefined types, or import issues.
---

# Debug Flutter Build Errors

## Workflow

1. **Reproduce the error**: Run `flutter run` or `flutter build` to get the error output.

2. **Parse errors**: Identify the specific errors from the output, noting file paths, line numbers, and error messages.

3. **Investigate files**: Read the affected files to understand the context around the errors.

4. **Fix issues**:
   - For missing parameters: Add the required named parameters to function calls.
   - For undefined types: Import the necessary classes or enums, or define them if missing.
   - For other issues: Apply appropriate fixes based on Dart/Flutter best practices.

5. **Validate**: Re-run the build to ensure errors are resolved.

## Tools to Use

- run_in_terminal: To run flutter commands.
- read_file: To examine code around errors.
- grep_search: To find definitions or usages of symbols.
- replace_string_in_file: To apply fixes.
- get_errors: To get a list of all errors.

## Examples

- Missing parameter: Add `tutorId: someValue` to the function call.
- Undefined enum: Import the file where UserRole is defined, or define it locally.