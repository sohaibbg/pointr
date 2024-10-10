import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          return const PopScope(
            canPop: false,
            child: Dialog(
              child: LinearProgressIndicator(),
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
          await simpleDialog(
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

  Future simpleDialog({
    String title = 'An error occurred',
    String content = 'Please try again later',
    Widget? alternativeAction,
  }) =>
      showDialog(
        context: this,
        useRootNavigator: false,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: pop,
              child: const Text("Return"),
            ),
            if (alternativeAction != null) alternativeAction,
          ],
        ),
      );

  Future<String?> textFieldDialog({
    String? title,
    required String hintText,
    required String confirmText,
    bool showPasteFromClipboardBtn = false,
  }) async {
    final textCtl = TextEditingController();
    final text = await showDialog(
      context: this,
      builder: (context) => AlertDialog(
        title: title != null ? Text(title) : null,
        content: TextField(
          controller: textCtl,
          autofocus: true,
          decoration: InputDecoration(
            labelText: hintText,
          ),
          onSubmitted: context.pop,
        ),
        actions: [
          TextButton(
            onPressed: context.pop,
            child: const Text("Return"),
          ),
          if (showPasteFromClipboardBtn)
            TextButton.icon(
              onPressed: () async {
                final pasted = await Clipboard.getData(
                  Clipboard.kTextPlain,
                );
                if (pasted == null) return;
                if (pasted.text == null) return;
                textCtl.text = pasted.text!;
              },
              label: const Text("Paste from Clipboard"),
              icon: const Icon(Icons.paste),
            ),
          ElevatedButton(
            autofocus: true,
            onPressed: () => context.pop(
              textCtl.text,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    textCtl.dispose();
    return text;
  }
}
