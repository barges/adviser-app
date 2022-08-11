// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "confirmNewPassword":
            MessageLookupByLibrary.simpleMessage("Confirm new password"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "forgetYourPassword":
            MessageLookupByLibrary.simpleMessage("Forget your password"),
        "hello": MessageLookupByLibrary.simpleMessage("Hello"),
        "login": MessageLookupByLibrary.simpleMessage("Log in"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "pleaseEnterAtLeast8Characters": MessageLookupByLibrary.simpleMessage(
            "Please enter at least 8 characters"),
        "requestNewPassword":
            MessageLookupByLibrary.simpleMessage("Request a new password"),
        "sellYourServicesDuringAChatReading":
            MessageLookupByLibrary.simpleMessage(
                "Sell your services during a chat reading"),
        "signIn": MessageLookupByLibrary.simpleMessage("Sign in"),
        "thePasswordsMustMatch":
            MessageLookupByLibrary.simpleMessage("The passwords must match"),
        "theUserWasNotFound":
            MessageLookupByLibrary.simpleMessage("The user was not found")
      };
}
