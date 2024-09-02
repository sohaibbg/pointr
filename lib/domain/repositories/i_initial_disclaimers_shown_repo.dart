import 'package:injectable/injectable.dart';

enum InitialDisclaimer {
  notResponsibleForRouteAccuracy(
    'notResponsibleForRouteAccuracy',
  ),
  algorithmImperfect(
    'algorithmImperfect',
  ),
  routeLegendIsTappable(
    'routeLegendIsTappable',
  );

  const InitialDisclaimer(this.name);

  final String name;
}

@test
@injectable
class IInitialDisclaimersShownRepo {
  static final Map<InitialDisclaimer, bool> _flags = {};

  Future<bool> fetch(
    InitialDisclaimer id,
  ) async {
    final value = _flags[id];
    switch (value) {
      case null:
        _flags[id] = false;
        return false;
      case _:
        return value;
    }
  }

  Future<void> setTrue(
    InitialDisclaimer id,
  ) async =>
      _flags[id] = true;
}
