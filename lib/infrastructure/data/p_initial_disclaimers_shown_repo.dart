import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/i_initial_disclaimers_shown_repo.dart';

@dev
@prod
@Injectable(as: IInitialDisclaimersShownRepo)
class PInitialDisclaimersShownRepo implements IInitialDisclaimersShownRepo {
  SharedPreferences? _prefs;
  Future<bool> _fetch(String key) async {
    _prefs ??= await SharedPreferences.getInstance();
    final value = _prefs!.getBool(key);
    if (value == null) await _prefs!.setBool(key, false);
    return value ?? false;
  }

  Future<void> _setTrue(String key) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setBool(key, true);
  }

  @override
  Future<bool> fetchDidShowAlgorithmImperfectDialog() =>
      _fetch('didShowAlgorithmImperfectDialog');

  @override
  Future<void> setAlgorithmImperfectDialogShown() =>
      _setTrue('didShowAlgorithmImperfectDialog');

  @override
  Future<bool> fetchDidShowNotResponsibleForRouteAccuracyDialog() =>
      _fetch('didShowNotResponsibleForRouteAccuracyDialog');

  @override
  Future<void> setNotResponsibleForRouteAccuracyDialogShown() =>
      _setTrue('didShowNotResponsibleForRouteAccuracyDialog');
}
