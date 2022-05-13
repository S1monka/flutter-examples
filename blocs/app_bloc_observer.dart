import 'package:bloc/bloc.dart';
import 'package:food_app/core/data/failures.dart';
import 'package:food_app/core/di/injection.dart';
import 'package:food_app/core/utils/app_show_message.dart';
import 'package:food_app/features/auth/bloc/auth_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (error is TokenInvalidFailure) {
      getIt<AuthBloc>().add(LoggedOut());
    } else if (error is Failure) {
      showMessage(error.message, MessageType.error);
    }
  }
}
