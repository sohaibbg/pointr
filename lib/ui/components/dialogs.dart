import 'dart:async';

import 'package:flutter/material.dart';

extension Dialogs on BuildContext {
  Future<T> loaderWithErrorDialog<T>(FutureOr<T> Function() computation) async {
    showDialog(
      context: this,
      builder: (context) => const Dialog(
        child: LinearProgressIndicator(),
      ),
    );
    late final T result;
    try {
      result = await computation();
    } catch (e) {
      errorDialog(
        'An error occurred',
        "Please try again later.",
      );
      rethrow;
    }
    pop();
    return result;
  }

  Future errorDialog(String title, String content) => showDialog(
        context: this,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: pop,
              child: const Text("Return"),
            ),
          ],
        ),
      );

  void pop<T extends Object?>([T? result]) => Navigator.of(this).pop(result);
}
