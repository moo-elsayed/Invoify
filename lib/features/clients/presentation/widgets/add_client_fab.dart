import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/routing/routes.dart';
import 'package:invoify/features/clients/presentation/view_models/clients_cubit/clients_cubit.dart';

class AddClientFab extends StatefulWidget {
  const AddClientFab({super.key, required this.isVisibleListenable});

  final ValueListenable<bool> isVisibleListenable;

  @override
  State<AddClientFab> createState() => _AddClientFabState();
}

class _AddClientFabState extends State<AddClientFab>
    with WidgetsBindingObserver {
  final ValueNotifier<bool> _isKeyboardOpenNotifier = ValueNotifier<bool>(
    false,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FocusManager.instance.addListener(_checkKeyboardOrFocus);
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_checkKeyboardOrFocus);
    WidgetsBinding.instance.removeObserver(this);
    _isKeyboardOpenNotifier.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    _checkKeyboardOrFocus();
  }

  void _checkKeyboardOrFocus() {
    final focusWidget = FocusManager.instance.primaryFocus?.context?.widget;
    final hasInputFocus = focusWidget is EditableText;
    final bottomInset = WidgetsBinding
        .instance
        .platformDispatcher
        .views
        .first
        .viewInsets
        .bottom;
    final isKeyboardOpen = hasInputFocus || bottomInset > 0;

    if (_isKeyboardOpenNotifier.value != isKeyboardOpen) {
      _isKeyboardOpenNotifier.value = isKeyboardOpen;
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 75.h),
    child: ValueListenableBuilder<bool>(
      valueListenable: widget.isVisibleListenable,
      builder: (context, isScrollVisible, _) => ValueListenableBuilder<bool>(
        valueListenable: _isKeyboardOpenNotifier,
        builder: (context, isKeyboardOpen, child) {
          final shouldShow = isScrollVisible && !isKeyboardOpen;

          return Offstage(
            offstage: !shouldShow,
            child: AnimatedScale(
              scale: shouldShow ? 1.0 : 0.0,
              duration: isKeyboardOpen
                  ? Duration.zero
                  : const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              child: child,
            ),
          );
        },
        child: FloatingActionButton(
          onPressed: () {
            final cubit = context.read<ClientsCubit>();
            context
                .pushNamed(Routes.addEditClientView)
                .then((_) => cubit.getClients());
          },
          backgroundColor: context.colors.primary,
          child: Icon(Icons.add_rounded, color: Colors.white, size: 28.sp),
        ),
      ),
    ),
  );
}
