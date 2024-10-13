import 'package:flutter/material.dart';

import '../../config/injector.dart';
import '../repositories/i_initial_disclaimers_shown_repo.dart';

final _flagRepo = getIt.call<IInitialDisclaimersShownRepo>();

Future<bool> shouldFlagBeShown(
  InitialDisclaimer flag, {
  required BuildContext context,
}) async {
  final hasAlreadyShown = await _flagRepo.fetch(flag);
  if (hasAlreadyShown) return false;
  if (!context.mounted) return false;
  return true;
}

Future<void> flagTutorialAsSuccessfullyShown(
  InitialDisclaimer id,
) =>
    _flagRepo.setTrue(id);
