import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/helpers/location_provider.dart';
import 'package:rose_hr/common/helpers/snackbar_service.dart';
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

class HeaderAndShiftSection extends StatelessWidget {
  const HeaderAndShiftSection({super.key});

  /// Formats a 24-hour time value to 12-hour format with AM/PM
  String _formatHourTo12Hour(BuildContext context, int? hour) {
    if (hour == null) return '--:--';
    final period = hour >= 12 ? context.localizations.timePeriodPm : context.localizations.timePeriodAm;
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    return '$hour12:00 $period ';
  }

  /// Formats shift hours range from 24-hour to 12-hour format
  String _formatShiftHours(BuildContext context, int? shiftHourFrom, int? shiftHourTo) {
    return '${_formatHourTo12Hour(context, shiftHourFrom)} - ${_formatHourTo12Hour(context, shiftHourTo)}';
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<TimezoneCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<HomeCubit>(),
        ),
      ],
      child: Container(
        padding: EdgeInsets.only(bottom: AppSpacing.xxxl.r),
        color: context.colors.containerBackground,
        child: Column(
          children: [
            const HeaderSection(),
            BlocBuilder<TimezoneCubit, TimezoneState>(
              builder: (context, state) {
                // Default values for initial/loading states
                final formattedDateTime = state is TimezoneLoaded ? state.getFormattedDateTime() : '...';
                final cityName = state is TimezoneLoaded ? (state.cityName ?? state.locationName) : '...';

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: AppSpacing.xxl.r),
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
                              borderRadius: BorderRadius.circular(AppSpacing.sm.r),
                              border: Border.all(color: context.colors.containerBorder),
                            ),
                            child: Row(
                              children: [
                                const AppVectorGraphic(path: Assets.vectorsLocationIcon),
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
                      Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          children: [
                            TextSpan(
                              text: context.localizations.timeLeftUntilYourShiftEnds,
                              style: context.typography.regular16,
                            ),
                            TextSpan(
                              text: ' 9:00 ',
                              style: context.typography.semiBold28,
                            ),
                            TextSpan(
                              text: context.localizations.hours,
                              style: context.typography.regular16,
                            ),
                          ],
                        ),
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
      initialSize: 0.18.h,
      maxChildSize: 0.18.h,
      removeAutoScroll: true,
      disableDrag: true,
      useRootNavigator: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl.r, vertical: AppSpacing.xl.r),
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
    return BottomSheetWrapper(
      initialSize: 0.35.h,
      maxChildSize: 0.35.h,
      removeAutoScroll: true,
      disableDrag: true,
      useRootNavigator: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl.r, vertical: AppSpacing.xl.r),
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
                      if (state.locationCheckStatus == LocationCheckStatus.checkingBetweenRadiusLoading) {
                        return Shimmer.fromColors(
                          baseColor: context.colors.surfaceVariant,
                          highlightColor: context.colors.surface,
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.colors.surfaceVariant,
                              borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
                            ),
                            width: 100.w,
                            height: 18.h,
                          ),
                        );
                      }
                      if (state.locationCheckStatus == LocationCheckStatus.checkedBetweenRadiusSuccessfully &&
                          state.isWithinRadius != null &&
                          state.isWithinRadius!) {
                        return Text(
                          context.localizations.inRange,
                          style: context.typography.semiBold16.copyWith(
                            color: context.colors.error,
                          ),
                        );
                      } else if (state.locationCheckStatus == LocationCheckStatus.checkedBetweenRadiusSuccessfully &&
                          state.isWithinRadius != null &&
                          !state.isWithinRadius!) {
                        return Text(
                          'خارج النطاق',
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
                        const AppVectorGraphic(path: Assets.vectorsLocationIcon),
                        SizedBox(width: AppSpacing.xs.r),
                        BlocBuilder<TimezoneCubit, TimezoneState>(
                          builder: (context, state) {
                            final cityName = state is TimezoneLoaded ? (state.cityName ?? state.locationName) : '...';
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
                        color: context.colors.containerBackground,
                        borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
                      ),
                      child: Text(
                        _formatShiftHours(context, shiftData?.shiftHourFrom, shiftData?.shiftHourTo),
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
                  final date = state is TimezoneLoaded ? state.getFormattedDate() : '...';
                  return Text(
                    date,
                    style: context.typography.regular14,
                    textAlign: TextAlign.center,
                  );
                },
              ),
              BlocBuilder<TimezoneCubit, TimezoneState>(
                builder: (context, state) {
                  final time = state is TimezoneLoaded ? state.getFormattedTime() : '...';
                  return Text(
                    time,
                    style: context.typography.semiBold36,
                    textAlign: TextAlign.center,
                  );
                },
              ),
              // Text(
              //   'آخر تسجيل حدث 09:23 صباحًا',
              //   style: context.typography.regular14,
              //   textAlign: TextAlign.center,
              // ),
              BlocBuilder<ShiftCubit, ShiftState>(
                builder: (context, shiftState) {
                  final isLocationLoading = shiftState.locationCheckStatus == LocationCheckStatus.checkingBetweenRadiusLoading;
                  final isOutOfRange =
                      shiftState.locationCheckStatus == LocationCheckStatus.checkedBetweenRadiusSuccessfully &&
                      shiftState.isWithinRadius == false;
                  final isLocationDisabled =
                      isLocationLoading || isOutOfRange || shiftState.locationCheckStatus == LocationCheckStatus.initial;

                  return BlocConsumer<HomeCubit, HomeState>(
                    listener: (context, homeState) {
                      if (homeState.status == HomeStatus.success) {
                        final result = homeState.createAttendancePunchResponse?.result;

                        // Check if the operation was actually successful
                        if (result?.success ?? false) {
                          if (context.mounted) {
                            context.pop();
                            BottomSheetWrapper(
                              initialSize: 0.35.h,
                              maxChildSize: 0.35.h,
                              removeAutoScroll: true,
                              disableDrag: true,
                              useRootNavigator: true,
                              child: const ClockInClockOutBottomSheet(clockImage: Assets.rastersFingerPrintRegistered),
                            ).callSheet(context);
                          }
                        } else {
                          // Handle case where success is false (e.g., not in geofence)
                          if (context.mounted) {
                            context.pop();
                            SnackbarService.showError(
                              context,
                              result?.message ?? 'فشلت العملية',
                            );
                          }
                        }
                      } else if (homeState.status == HomeStatus.error) {
                        if (context.mounted) {
                          context.pop();
                          SnackbarService.showError(
                            context,
                            homeState.error ?? 'حدث خطأ ما',
                          );
                        }
                      }
                    },
                    builder: (context, homeState) {
                      final isPunchLoading = homeState.status == HomeStatus.loading;
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
                                  valueColor: AlwaysStoppedAnimation<Color>(color),
                                ),
                              )
                            : null,
                        onTap: isDisabled
                            ? null
                            : () async {
                                // Get current location
                                final location = await LocationProvider.getCurrentLocation();

                                // Get current datetime in the required format
                                final now = DateTime.now();
                                final actionDatetime =
                                    '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

                                const deviceInfo = 'Device Info'; // Replace with actual device info

                                if (context.mounted) {
                                  await context.read<HomeCubit>().createAttendancePunchIn(
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
            'شكرًا لك',
            style: context.typography.regular16,
          ),
          Text(
            'تم تسجيل بصمتك بنجاح!',
            style: context.typography.semiBold28,
          ),
          Text(
            'نتمنى لك يومًا مُثمرًا',
            style: context.typography.regular16,
          ),
          SizedBox(height: 30.h),
          Image.asset(
            clockImage,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
