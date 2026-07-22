import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invoify/core/helpers/extensions.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({
    super.key,
    required this.onChanged,
    this.initialValue = false,
  });

  final ValueChanged<bool> onChanged;
  final bool initialValue;

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      setState(() {
        isChecked = !isChecked;
      });
      widget.onChanged(isChecked);
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 22.w,
      height: 22.h,
      decoration: BoxDecoration(
        color: isChecked ? context.colors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: isChecked ? context.colors.primary : context.colors.border,
          width: 1.5.w,
        ),
      ),
      child: isChecked
          ? Icon(Icons.check_rounded, size: 16.sp, color: Colors.white)
          : null,
    ),
  );
}
