import 'package:injectable/injectable.dart';

@test
@injectable
class IInitialDisclaimersShownRepo {
  static final Map<String, bool> _flags = {};

  Future<bool> _fetch(String key) async {
    final value = _flags[key];
    switch (value) {
      case null:
        _flags[key] = false;
        return false;
      case _:
        return value;
    }
  }

  Future<bool> fetchDidShowNotResponsibleForRouteAccuracyDialog() =>
      _fetch('didShowNotResponsibleForRouteAccuracyDialog');
  Future<void> setNotResponsibleForRouteAccuracyDialogShown() async =>
      _flags['didShowNotResponsibleForRouteAccuracyDialog'] = true;
  Future<bool> fetchDidShowAlgorithmImperfectDialog() =>
      _fetch('didShowAlgorithmImperfectDialog');
  Future<void> setAlgorithmImperfectDialogShown() async =>
      _flags['didShowAlgorithmImperfectDialog'] = true;
}
