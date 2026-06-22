import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/helpers/location_provider.dart';
import 'package:rose_hr/common/helpers/snackbar_service.dart';
import 'package:rose_hr/common/helpers/timezone_helper.dart';
import 'package:rose_hr/common/widgets/bottom_sheet_wrapper.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/features/home/data/models/create_attendance_punch_request.dart';
import 'package:rose_hr/features/home/presentation/cubit/home_cubit.dart';
import 'package:rose_hr/features/home/presentation/cubit/shift_cubit.dart';
import 'package:rose_hr/features/home/presentation/cubit/timezone_cubit.dart';
import 'package:rose_hr/features/home/presentation/widgets/header_section.dart';
import 'package:rose_hr/theme/app_sizes.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/primary_text_button.dart';
import 'package:rose_hr/theme/theme_ext.dart';
import 'package:shimmer/shimmer.dart';

class HeaderAndShiftSection extends StatefulWidget {
  const HeaderAndShiftSection({super.key});

  @override
  State<HeaderAndShiftSection> createState() => _HeaderAndShiftSectionState();
}

class _HeaderAndShiftSectionState extends State<HeaderAndShiftSection>
    with WidgetsBindingObserver {
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // The countdown is always derived from the wall clock (projectedCheckout -
    // now), so a periodic rebuild is all that's needed to keep it ticking.
    // Because it's recomputed from the current time on every build, a pull to
    // refresh re-fetches the same target and does NOT reset the countdown.
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) {
        if (mounted) setState(() {});
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // When returning from the background, recompute immediately so the
    // countdown reflects the time that elapsed while the app was suspended
    // instead of waiting for the next periodic tick.
    if (state == AppLifecycleState.resumed && mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Calculates the time remaining until the projected checkout.
  ///
  /// [projectedCheckout] is an absolute instant (already in local time), so the
  /// remaining time is simply the difference from "now". This makes the value
  /// inherently correct after refreshes and after the app returns from the
  /// background. Returns zeroes when there is no checkout or it has passed.
  Map<String, int> _calculateRemaining(DateTime? projectedCheckout) {
    if (projectedCheckout == null) {
      return {'hours': 0, 'minutes': 0};
    }
    final difference = projectedCheckout.difference(TimezoneHelper.now());
    if (difference.isNegative) {
      return {'hours': 0, 'minutes': 0};
    }
    return {
      'hours': difference.inHours,
      'minutes': difference.inMinutes.remainder(60),
    };
  }

  /// Formats the remaining time with localized labels, e.g. "2 Hours 5 Minutes".
  String _formatRemaining(BuildContext context, Map<String, int> remaining) {
    final hours = remaining['hours'] ?? 0;
    final minutes = remaining['minutes'] ?? 0;
    return '$hours ${context.localizations.hours} $minutes ${context.localizations.minutes}';
  }

  /// Formats a 24-hour time value to 12-hour format with AM/PM
  String _formatHourTo12Hour(BuildContext context, int? hour) {
    if (hour == null) return context.localizations.timeUnavailablePlaceholder;
    final period = hour >= 12
        ? context.localizations.timePeriodPm
        : context.localizations.timePeriodAm;
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    return '$hour12:00 $period ';
  }

  /// Formats shift hours range from 24-hour to 12-hour format
  String _formatShiftHours(
    BuildContext context,
    int? shiftHourFrom,
    int? shiftHourTo,
  ) {
    return '${_formatHourTo12Hour(context, shiftHourFrom)} - ${_formatHourTo12Hour(context, shiftHourTo)}';
  }

  @override
  Widget build(BuildContext context) {
    // Capture the HomeCubit from the screen (which loads `projectedCheckout`)
    // before the inner BlocProvider below shadows it with a punch-only instance.
    final homeCubit = context.read<HomeCubit>();
    return BlocProvider(
      create: (context) => sl<ShiftCubit>()..getCurrentShift(),
      child: Builder(
        builder: (context) {
          return BlocProvider(
            create: (context) => sl<HomeCubit>(),
            child: Container(
              padding: EdgeInsets.only(bottom: AppSpacing.xxxl.r),
              color: context.colors.containerBackground,
              child: Column(
                children: [
                  const HeaderSection(),
                  BlocBuilder<TimezoneCubit, TimezoneState>(
                    builder: (context, state) {
                      // Default values for initial/loading/detecting states
                      final formattedDateTime = state is TimezoneLoaded
                          ? state.getFormattedDateTime(
                              context: context,
                              locale: context.localizations.localeName,
                            )
                          : context.localizations.loadingEllipsis;
                      final cityName =
                          (state is TimezoneLoaded && !state.isDetecting)
                          ? (state.cityName ?? state.locationName)
                          : context.localizations.loadingEllipsis;

                      if (state is TimezoneLoading) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey,
                          highlightColor: Colors.white,
                          child: SizedBox(
                            width: 100.w,
                            height: 100.h,
                          ),
                        );
                      }

                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: AppSpacing.xxl.r,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg.r,
                          vertical: AppSpacing.xl.r,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                          color: context.colors.surface,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: AppSpacing.md.h,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formattedDateTime,
                                  style: context.typography.regular14,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSpacing.xs.r,
                                    vertical: AppSpacing.xxs.r,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.colors.surface,
                                    borderRadius: BorderRadius.circular(
                                      AppSpacing.sm.r,
                                    ),
                                    border: Border.all(
                                      color: context.colors.containerBorder,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const AppVectorGraphic(
                                        path: Assets.vectorsLocationIcon,
                                      ),
                                      SizedBox(width: AppSpacing.xs.r),
                                      Text(
                                        cityName,
                                        style: context.typography.medium12,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Dynamic countdown based on projected checkout
                            BlocBuilder<HomeCubit, HomeState>(
                              bloc: homeCubit,
                              builder: (context, homeState) {
                                final remaining = _calculateRemaining(
                                  homeState.projectedCheckout,
                                );
                                final countdownText = _formatRemaining(
                                  context,
                                  remaining,
                                );

                                return Text.rich(
                                  textAlign: TextAlign.center,
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: context
                                            .localizations
                                            .timeLeftUntilYourShiftEnds,
                                        style: context.typography.regular16,
                                      ),
                                      TextSpan(
                                        text: '\n $countdownText',
                                        style: context.typography.medium18,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            PrimaryTextButton(
                              appButtonSize: AppButtonSize.xxLarge,
                              label: context.localizations.clockInClockOut,
                              onTap: () => _handleClockInOut(context),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleClockInOut(BuildContext context) async {
    final data = await LocationProvider.checkPermission();
    if (data == LocationPermissionStatus.locationServiceDisabled ||
        data == LocationPermissionStatus.denied ||
        data == LocationPermissionStatus.deniedForever) {
      if (context.mounted) {
        await goToPermissionBottomSheet(context).callSheet(context);
        if (context.mounted && context.canPop()) {
          context.pop();
        }
      }
    } else {
      await LocationProvider.requestPermission();
      if (data == LocationPermissionStatus.granted) {
        if (!context.mounted) return;

        await ordinaryClockInClockOutBottomSheet(context).callSheet(context);
      }
    }
  }

  BottomSheetWrapper goToPermissionBottomSheet(BuildContext context) {
    return BottomSheetWrapper(
      initialSize: 0.2.h,
      maxChildSize: 0.2.h,
      removeAutoScroll: true,
      disableDrag: true,
      useRootNavigator: true,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl.r,
          vertical: AppSpacing.xl.r,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.md.h,
          children: [
            Text(
              context.localizations.youShouldOpenLocationPermission,
              style: context.typography.semiBold18,
              textAlign: TextAlign.center,
            ),
            PrimaryTextButton(
              appButtonSize: AppButtonSize.xxLarge,
              label: context.localizations.goToSettingsPage,
              onTap: () async {
                await LocationProvider.openLocationSettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  BottomSheetWrapper ordinaryClockInClockOutBottomSheet(BuildContext context) {
    // Account for the Android/iOS system navigation bar so the punch button is
    // never hidden behind it. Grow the sheet by the bottom inset and pad the
    // content by the same amount.
    final screenHeight = MediaQuery.sizeOf(context).height;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final sheetSize = (0.42.h + bottomInset / screenHeight).clamp(0.0, 1.0);

    return BottomSheetWrapper(
      initialSize: sheetSize,
      maxChildSize: sheetSize,
      removeAutoScroll: true,
      disableDrag: true,
      useRootNavigator: true,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.xxl.r,
          right: AppSpacing.xxl.r,
          top: AppSpacing.xl.r,
          bottom: AppSpacing.xl.r + bottomInset,
        ),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<TimezoneCubit>()),
            BlocProvider(create: (context) => sl<HomeCubit>()),
            BlocProvider(
              create: (context) => sl<ShiftCubit>()..checkIfWithinShiftRadius(),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.md.h,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<ShiftCubit, ShiftState>(
                    builder: (context, state) {
                      if (state.locationCheckStatus ==
                          LocationCheckStatus.checkingBetweenRadiusLoading) {
                        return Shimmer.fromColors(
                          baseColor: context.colors.surfaceVariant,
                          highlightColor: context.colors.surface,
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.colors.surfaceVariant,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.xxl.r,
                              ),
                            ),
                            width: 100.w,
                            height: 18.h,
                          ),
                        );
                      }
                      if (state.locationCheckStatus ==
                              LocationCheckStatus
                                  .checkedBetweenRadiusSuccessfully &&
                          state.isWithinRadius != null &&
                          state.isWithinRadius!) {
                        return Text(
                          context.localizations.inRange,
                          style: context.typography.semiBold16.copyWith(
                            color: context.colors.success,
                          ),
                        );
                      } else if (state.locationCheckStatus ==
                              LocationCheckStatus
                                  .checkedBetweenRadiusSuccessfully &&
                          state.isWithinRadius != null &&
                          !state.isWithinRadius!) {
                        return Text(
                          context.localizations.outOfRange,
                          style: context.typography.semiBold16.copyWith(
                            color: context.colors.error,
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs.r,
                      vertical: AppSpacing.xxs.r,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
                      border: Border.all(color: context.colors.containerBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppVectorGraphic(
                          path: Assets.vectorsLocationIcon,
                        ),
                        SizedBox(width: AppSpacing.xs.r),
                        BlocBuilder<TimezoneCubit, TimezoneState>(
                          builder: (context, state) {
                            final cityName = state is TimezoneLoaded
                                ? (state.cityName ?? state.locationName)
                                : context.localizations.loadingEllipsis;
                            return Text(
                              cityName,
                              style: context.typography.medium14,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              BlocBuilder<ShiftCubit, ShiftState>(
                builder: (context, state) {
                  if (state.status == ShiftStatus.success) {
                    final shiftData = state.currentShiftResponse?.result?.data;
                    return Container(
                      margin: EdgeInsets.only(bottom: AppSpacing.xxxl.r),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.xxl.r,
                        vertical: AppSpacing.xl.r,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
                      ),
                      child: Text(
                        _formatShiftHours(
                          context,
                          shiftData?.shiftHourFrom,
                          shiftData?.shiftHourTo,
                        ),
                        style: context.typography.regular16,
                      ),
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.only(bottom: AppSpacing.xxxl.r),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.xxl.r,
                        vertical: AppSpacing.xl.r,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.containerBackground,
                        borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
                      ),
                      child: Text(
                        _formatShiftHours(context, null, null),
                        style: context.typography.regular16,
                      ),
                    );
                  }
                },
              ),
              BlocBuilder<TimezoneCubit, TimezoneState>(
                builder: (context, state) {
                  final date = state is TimezoneLoaded
                      ? state.getFormattedDate(
                          locale: context.localizations.localeName,
                        )
                      : context.localizations.loadingEllipsis;
                  return Text(
                    date,
                    style: context.typography.regular14,
                    textAlign: TextAlign.center,
                  );
                },
              ),
              BlocBuilder<TimezoneCubit, TimezoneState>(
                builder: (context, state) {
                  final time = state is TimezoneLoaded
                      ? state.getFormattedTime(context: context)
                      : context.localizations.loadingEllipsis;
                  return Text(
                    time,
                    style: context.typography.semiBold36,
                    textAlign: TextAlign.center,
                  );
                },
              ),
              BlocBuilder<ShiftCubit, ShiftState>(
                builder: (context, shiftState) {
                  final isLocationLoading =
                      shiftState.locationCheckStatus ==
                      LocationCheckStatus.checkingBetweenRadiusLoading;
                  final isOutOfRange =
                      shiftState.locationCheckStatus ==
                          LocationCheckStatus
                              .checkedBetweenRadiusSuccessfully &&
                      shiftState.isWithinRadius == false;
                  final isLocationDisabled =
                      isLocationLoading ||
                      isOutOfRange ||
                      shiftState.locationCheckStatus ==
                          LocationCheckStatus.initial;

                  return BlocConsumer<HomeCubit, HomeState>(
                    listener: (context, homeState) {
                      if (homeState.status == HomeStatus.success) {
                        final result =
                            homeState.createAttendancePunchResponse?.result;

                        // Check if the operation was actually successful
                        if (result?.success ?? false) {
                          if (context.mounted) {
                            final screenHeight = MediaQuery.sizeOf(
                              context,
                            ).height;
                            final bottomInset = MediaQuery.viewPaddingOf(
                              context,
                            ).bottom;
                            final sheetSize =
                                (0.42.h + bottomInset / screenHeight).clamp(
                                  0.0,
                                  1.0,
                                );
                            context.pop();
                            BottomSheetWrapper(
                              initialSize: sheetSize,
                              maxChildSize: sheetSize,
                              removeAutoScroll: true,
                              disableDrag: true,
                              useRootNavigator: true,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: bottomInset),
                                child: ClockInClockOutBottomSheet(
                                  clockImage: context.isDarkMode
                                      ? Assets.rastersFingerprintregisteredDark
                                      : Assets.rastersFingerPrintRegistered,
                                ),
                              ),
                            ).callSheet(context);
                          }
                        } else {
                          // Handle case where success is false (e.g., not in geofence)
                          if (context.mounted) {
                            context.pop();
                            SnackbarService.showError(
                              context,
                              result?.message ??
                                  context.localizations.punchOperationFailed,
                            );
                          }
                        }
                      } else if (homeState.status == HomeStatus.error) {
                        if (context.mounted) {
                          context.pop();
                          SnackbarService.showError(
                            context,
                            homeState.error ??
                                context.localizations.somethingWentWrong,
                          );
                        }
                      }
                    },
                    builder: (context, homeState) {
                      final isPunchLoading =
                          homeState.status == HomeStatus.loading;
                      final isDisabled = isLocationDisabled || isPunchLoading;

                      return PrimaryTextButton(
                        appButtonSize: AppButtonSize.xxLarge,
                        label: context.localizations.fingerPrintRegistration,
                        leading: isPunchLoading
                            ? (color) => SizedBox(
                                width: 20.r,
                                height: 20.r,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.r,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    color,
                                  ),
                                ),
                              )
                            : null,
                        onTap: isDisabled
                            ? null
                            : () async {
                                final deviceInfo =
                                    context.localizations.deviceInfoPlaceholder;
                                // Get current location
                                final location =
                                    await LocationProvider.getCurrentLocation();

                                // Get current datetime in the required format
                                final now = DateTime.now();
                                final actionDatetime =
                                    '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

                                if (context.mounted) {
                                  await context
                                      .read<HomeCubit>()
                                      .createAttendancePunchIn(
                                        CreateAttendancePunchRequest(
                                          geoInformation: GeoInformation(
                                            latitude: location.latitude,
                                            longitude: location.longitude,
                                          ),
                                          deviceInfo: deviceInfo,
                                          actionDatetime: actionDatetime,
                                        ),
                                      );
                                }
                              },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClockInClockOutBottomSheet extends StatelessWidget {
  const ClockInClockOutBottomSheet({
    required this.clockImage,
    super.key,
  });

  final String clockImage;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.containerBackground,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: AppSpacing.xs.h,
        children: [
          Text(
            context.localizations.thankYou,
            style: context.typography.regular16,
          ),
          Text(
            context.localizations.fingerprintRecordedSuccessfully,
            style: context.typography.semiBold28,
            textAlign: TextAlign.center,
          ),
          Text(
            context.localizations.wishYouProductiveDay,
            style: context.typography.regular16,
          ),
          SizedBox(height: 30.h),
          Image.asset(
            clockImage,
            colorBlendMode: BlendMode.srcIn,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
