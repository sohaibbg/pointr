import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension Dialogs on BuildContext {
  Future<void> _pushLoaderDialog(
    Completer<void> completer,
  ) =>
      showDialog(
        barrierDismissible: false,
        context: this,
        builder: (loaderContext) {
          completer.future.then(
            // using context after a future requires
            // us to confirm context.mounted. In this
            // case however, we've disabled the
            // context from being popped by the user.
            // If a stackTrace led you here, you are
            // likely calling pop() programmatically
            // at the wrong place
            (_) => loaderContext.pop(),
          );
          return PopScope(
            canPop: false,
            child: Dialog(
              child: Column(
                children: [
                  const LinearProgressIndicator(),
                  ElevatedButton(
                    onPressed: loaderContext.pop,
                    child: const Text("POP"),
                  ),
                ],
              ),
            ),
          );
        },
      );

  Future<T> loaderWithErrorDialog<T>(
    FutureOr<T> Function() computation, {
    Future<void>? Function(
      Object error, [
      StackTrace stackTrace,
    ])? errorDialogBuilder,
  }) async {
    if (computation is T Function()) return computation();
    final loadingCompleter = Completer<void>();
    _pushLoaderDialog(loadingCompleter);
    return (computation as Future Function())().then(
      (value) {
        loadingCompleter.complete();
        return value;
      },
      onError: (error, stackTrace) async {
        Future<bool> attemptParameterErrorBuilder() async {
          if (errorDialogBuilder == null) return false;
          final providedED = errorDialogBuilder(error, stackTrace);
          if (providedED == null) return false;
          await providedED;
          return true;
        }

        Future showParameterOrDefaultErrorDialog() async {
          final didPEBSucceed = await attemptParameterErrorBuilder();
          if (didPEBSucceed) return;
          await errorDialog(
            title: error.toString(),
            content: stackTrace.toString(),
          );
        }

        loadingCompleter.complete();
        await showParameterOrDefaultErrorDialog();
        Error.throwWithStackTrace(error, stackTrace);
      },
    );
  }

  Future errorDialog({
    String title = 'An error occurred',
    String content = 'Please try again later',
  }) =>
      showDialog(
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
}
