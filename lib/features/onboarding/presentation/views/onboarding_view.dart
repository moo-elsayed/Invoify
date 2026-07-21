import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/helpers/di.dart';
import '../view_models/onboarding_cubit/onboarding_cubit.dart';
import '../widgets/onboarding_view_body.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: BlocProvider(
      create: (context) => getIt.get<OnboardingCubit>(),
      child: const SafeArea(child: OnboardingViewBody()),
    ),
  );
}
