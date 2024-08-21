import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stack_trace/stack_trace.dart';

class LoggerObserver extends ProviderObserver {
  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      print(provider);
      final formattedStackTrace = Trace.from(stackTrace).terse;
      Error.throwWithStackTrace(error, formattedStackTrace);
    }
  }
}
