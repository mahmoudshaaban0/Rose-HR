import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class BottomSheetWrapper extends StatefulWidget {
  const BottomSheetWrapper({
    required this.child,
    super.key,
    this.dragControl,
    this.initialSize,
    this.minChildSize,
    this.maxChildSize,
    this.closeBottomSheetOnDrag,
    this.disableDrag,
    this.thenFunction,
    this.removeAutoScroll = false,
    this.useSolidBackground = false,
    this.useRootNavigator = false,
  });
  final Widget child;
  final DraggableScrollableController? dragControl;
  final double? initialSize;
  final double? maxChildSize;
  final double? minChildSize;
  final Function? thenFunction;
  final bool? closeBottomSheetOnDrag;
  final bool? disableDrag;
  final bool removeAutoScroll;
  final bool useSolidBackground;
  final bool? useRootNavigator;

  @override
  State<BottomSheetWrapper> createState() => _BottomSheetWrapperState();

  Future<void> callSheet(
    BuildContext context, {
    double initialChildSize = .80,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      elevation: 0,
      backgroundColor: context.colors.surface,
      isScrollControlled: true,
      useRootNavigator: useRootNavigator ?? false,
      builder: (context) {
        //  final ctrl = DraggableScrollableController();
        final ctrl = dragControl ?? DraggableScrollableController();

        if (disableDrag ?? false) {
          ctrl.addListener(() {
            if (ctrl.size < (initialSize ?? .8) || ctrl.size > (initialSize ?? .8)) {
              ctrl.jumpTo(initialSize ?? .8);
            }
          });
        }

        return PopScope(
          child: DraggableScrollableSheet(
            initialChildSize: initialSize == null ? initialChildSize : initialSize!,
            maxChildSize: maxChildSize ?? 1.0,
            controller: ctrl,
            minChildSize: minChildSize ?? .17,
            expand: false,
            builder: (ctx, scrl) {
              return removeAutoScroll
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: this,
                    )
                  : SingleChildScrollView(
                      controller: scrl,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: this,
                      ),
                    );
            },
          ),
        );
      },
    ).then((value) {
      if (thenFunction != null) {
        thenFunction?.call();
      }
    });
  }
}

class _BottomSheetWrapperState extends State<BottomSheetWrapper> {
  bool showDragger = true;
  bool copyBool = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.dragControl?.addListener(updateDragger);
  }

  void updateDragger() {
    try {
      if (!(widget.dragControl?.isAttached ?? false)) return;
      showDragger = (widget.dragControl?.size ?? 0) < 0.88;
      // print('==> dragControl: ${widget.dragControl?.size}');
      if (copyBool != showDragger) {
        copyBool = showDragger;
        key.currentState?.setState(() {});
      }
    } on Exception catch (e) {
      log('122, Error: $e');
    }
  }

  final GlobalKey key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      updateDragger();
    });
    return GestureDetector(
      onVerticalDragUpdate: widget.closeBottomSheetOnDrag ?? false
          ? (details) {
              if (details.primaryDelta! > 0) {
                Navigator.pop(context);
              }
            }
          : null,
      child: ClipRRect(
        borderRadius: widget.useSolidBackground
            ? const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )
            : BorderRadius.circular(25),
        child: ColoredBox(
          color: widget.useSolidBackground ? context.colors.surface : Colors.transparent,
          child: Column(
            children: [
              Align(
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: context.colors.outlineVariant,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              StatefulBuilder(
                key: key,
                builder: (context, setState) {
                  return Container(
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      border: Border.all(
                        color: context.colors.surface,
                        width: 0,
                        strokeAlign: 0,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(3),
                        topRight: Radius.circular(3),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: AppSpacing.md,
                        ),
                      ],
                    ),
                  );
                },
              ),
              Expanded(child: widget.child),
            ],
          ),
        ),
      ),
    );
  }
}
