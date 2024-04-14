import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injector.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  generateForDir: [
    'lib/domain/repositories',
    'lib/data/interface_adapters',
  ],
)
void configureDependencies() => getIt.init(
      environment: env,
    );

const env = String.fromEnvironment(
  'env',
  defaultValue: 'prod',
);
