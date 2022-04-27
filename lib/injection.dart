import 'package:get_it/get_it.dart';
import 'package:poms/helper/auth/auth.dart';

final getIt = GetIt.instance;
void configureInjection() {
  //Authentication auth = Authentication(AuthInitial());
  //getIt.registerSingleton<Authentication>(Authentication(AuthInitial()));
  getIt.registerFactory<Authentication>(() => Authentication(AuthInitial()));
  //getIt.registerSingleton(auth);
}
