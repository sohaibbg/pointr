import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/i_initial_disclaimers_shown_repo.dart';

@dev
@prod
@Injectable(as: IInitialDisclaimersShownRepo)
class PInitialDisclaimersShownRepo implements IInitialDisclaimersShownRepo {
  SharedPreferences? _prefs;
  @override
  Future<bool> fetch(InitialDisclaimer id) async {
    _prefs ??= await SharedPreferences.getInstance();
    final value = _prefs!.getBool(id.name);
    if (value == null) await _prefs!.setBool(id.name, false);
    return value ?? false;
  }

  @override
  Future<void> setTrue(InitialDisclaimer id) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setBool(id.name, true);
  }
}
