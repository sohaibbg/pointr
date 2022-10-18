import 'package:flutter/material.dart';
import 'package:pointr/my_theme.dart';
import 'package:sizer/sizer.dart';

class HorizontalChipScroller<T> extends StatelessWidget {
  const HorizontalChipScroller({
    required this.items,
    required this.onSelected,
    this.padding,
    this.bgColor,
    super.key,
  });
  final List<T> items;
  final Function(T item) onSelected;
  final EdgeInsets? padding;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) => ListView(
        padding: padding ?? EdgeInsets.only(left: 7.w),
        scrollDirection: Axis.horizontal,
        children: items
            .map(
              (item) => Padding(
                padding: EdgeInsets.only(right: 3.w),
                child: OutlinedButton.icon(
                  onPressed: () => onSelected(item),
                  style: MyTheme.outlineButtonStyle.copyWith(
                    backgroundColor: MaterialStatePropertyAll(
                      bgColor ?? Colors.white,
                    ),
                  ),
                  icon: const Icon(Icons.star),
                  label: Text(
                    item.toString(),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            )
            .toList(),
      );
}
