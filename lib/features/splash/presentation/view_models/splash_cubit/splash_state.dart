part of 'splash_cubit.dart';

enum SplashProcess {
  navigateToOnboarding,
  navigateToLogin,
  navigateToHome,
  none,
}

@immutable
abstract class SplashState extends Equatable {
  const SplashState(this.process);

  final SplashProcess process;

  @override
  List<Object?> get props => [process];
}

class SplashInitial extends SplashState {
  const SplashInitial() : super(SplashProcess.none);
}

class SplashSuccess extends SplashState {
  const SplashSuccess(super.process);
}
