import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'set_loc_btn_view_model.dart';

class SetLocBtn extends ConsumerWidget {
  const SetLocBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = SetLocBtnViewModel(context, ref);
    if (!vm.showSetStopButton) return const SizedBox();
    return ElevatedButton(
      onPressed: vm.confirmLoc,
      child: Text(vm.buttonLabel),
    );
  }
}
