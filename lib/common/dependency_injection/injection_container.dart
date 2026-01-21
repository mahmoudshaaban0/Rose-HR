import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:rose_hr/common/cubits/file_upload/file_upload_cubit.dart';
import 'package:rose_hr/common/networking/api_consumer.dart';
import 'package:rose_hr/common/networking/app_intercepters.dart';
import 'package:rose_hr/common/networking/dio_consumer.dart';
import 'package:rose_hr/common/networking/network_info.dart';
import 'package:rose_hr/features/account/data/datasources/account_datasource.dart';
import 'package:rose_hr/features/account/data/repositories/account_repository.dart';
import 'package:rose_hr/features/account/presentation/cubit/account_cubit.dart';
import 'package:rose_hr/features/attendance/data/datasources/attendance_datasource.dart';
import 'package:rose_hr/features/attendance/data/repositories/attendance_repository.dart';
import 'package:rose_hr/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:rose_hr/features/attendance/presentation/cubit/attendance_details_cubit.dart';
import 'package:rose_hr/features/auth/data/datasources/auth_datasource.dart';
import 'package:rose_hr/features/auth/data/repositories/auth_repository.dart';
import 'package:rose_hr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rose_hr/features/holiday_request/data/datasources/holiday_request_datasource.dart';
import 'package:rose_hr/features/holiday_request/data/repositories/holiday_request_repository.dart';
import 'package:rose_hr/features/holiday_request/presentation/bloc/holiday_request_cubit.dart';
import 'package:rose_hr/features/home/data/datasources/home_datasource.dart';
import 'package:rose_hr/features/home/data/repositories/home_repository.dart';
import 'package:rose_hr/features/home/presentation/cubit/home_cubit.dart';
import 'package:rose_hr/features/home/presentation/cubit/shift_cubit.dart';
import 'package:rose_hr/features/home/presentation/cubit/timezone_cubit.dart';
import 'package:rose_hr/features/permission_request/data/datasources/permission_request_datasource.dart';
import 'package:rose_hr/features/permission_request/data/repositories/permission_request_repository.dart';
import 'package:rose_hr/features/permission_request/presentation/cubit/permission_request_cubit.dart';
import 'package:rose_hr/features/permission_request/presentation/cubit/shift_id_cubit.dart';
import 'package:rose_hr/features/punch_correction/data/datasources/punch_correction_datasource.dart';
import 'package:rose_hr/features/punch_correction/data/repositories/punch_correction_repository.dart';
import 'package:rose_hr/features/punch_correction/presentation/cubit/punch_correction_cubit.dart';
import 'package:rose_hr/features/work_mission/data/datasources/work_mission_datasource.dart';
import 'package:rose_hr/features/work_mission/data/repositories/work_mission_repository.dart';
import 'package:rose_hr/features/work_mission/presentation/bloc/work_mission_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;
Future<void> init() async {
  ///! Data Sources
  sl
    ..registerLazySingleton<AuthDataSource>(() => AuthDataSource(sl<ApiConsumer>()))
    ..registerLazySingleton<HomeDataSource>(() => HomeDataSource(sl<ApiConsumer>()))
    ..registerLazySingleton<AccountDataSource>(() => AccountDataSource(sl<ApiConsumer>()))
    ..registerLazySingleton<AttendanceDataSource>(() => AttendanceDataSource(sl<ApiConsumer>()))
    ..registerLazySingleton<PermissionRequestDataSource>(() => PermissionRequestDataSource(sl<ApiConsumer>()))
    ..registerLazySingleton<PunchCorrectionDataSource>(() => PunchCorrectionDataSource(sl<ApiConsumer>()))
    ..registerLazySingleton<WorkMissionDataSource>(() => WorkMissionDataSource(sl<ApiConsumer>()))
    ..registerLazySingleton<HolidayRequestDataSource>(() => HolidayRequestDataSource(sl<ApiConsumer>()))
    // Repositories
    ..registerLazySingleton<AuthRepository>(() => AuthRepository(sl<AuthDataSource>()))
    ..registerLazySingleton<HomeRepository>(() => HomeRepository(sl<HomeDataSource>()))
    ..registerLazySingleton<AccountRepository>(() => AccountRepository(sl<AccountDataSource>()))
    ..registerLazySingleton<AttendanceRepository>(() => AttendanceRepository(sl<AttendanceDataSource>()))
    ..registerLazySingleton<PermissionRequestRepository>(() => PermissionRequestRepository(sl<PermissionRequestDataSource>()))
    ..registerLazySingleton<PunchCorrectionRepository>(() => PunchCorrectionRepository(sl<PunchCorrectionDataSource>()))
    ..registerLazySingleton<WorkMissionRepository>(() => WorkMissionRepository(sl<WorkMissionDataSource>()))
    ..registerLazySingleton<HolidayRequestRepository>(() => HolidayRequestRepository(sl<HolidayRequestDataSource>()))
    // Cubits/Blocs
    ..registerFactory<AuthBloc>(() => AuthBloc(sl<AuthRepository>()))
    ..registerFactory<HomeCubit>(() => HomeCubit(sl<HomeRepository>()))
    ..registerFactory<TimezoneCubit>(TimezoneCubit.new)
    ..registerFactory<AccountCubit>(() => AccountCubit(sl<AccountRepository>()))
    ..registerFactory<ShiftCubit>(() => ShiftCubit(sl<HomeRepository>()))
    ..registerFactory<AttendanceCubit>(() => AttendanceCubit(sl<AttendanceRepository>()))
    ..registerFactory<AttendanceDetailsCubit>(() => AttendanceDetailsCubit(sl<AttendanceRepository>()))
    ..registerFactory<PermissionRequestCubit>(() => PermissionRequestCubit(sl<PermissionRequestRepository>()))
    ..registerFactory<ShiftIdCubit>(() => ShiftIdCubit(sl<PermissionRequestRepository>()))
    ..registerFactory<PunchCorrectionCubit>(() => PunchCorrectionCubit(sl<PunchCorrectionRepository>()))
    ..registerFactory<FileUploadCubit>(FileUploadCubit.new)
    ..registerFactory<WorkMissionCubit>(() => WorkMissionCubit(sl<WorkMissionRepository>()))
    ..registerFactory<HolidayRequestCubit>(() => HolidayRequestCubit(sl<HolidayRequestRepository>()))
    ///! Core
    ..registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectivityChecker: sl()),
    )
    ..registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl
    ..registerLazySingleton<SharedPreferences>(() => sharedPreferences)
    ..registerLazySingleton<AppIntercepters>(AppIntercepters.new)
    ..registerLazySingleton<PrettyDioLogger>(
      () => PrettyDioLogger(requestBody: true, requestHeader: true, responseHeader: true),
    )
    ..registerLazySingleton<InternetConnectionChecker>(InternetConnectionChecker.new)
    ..registerLazySingleton<Dio>(Dio.new);
}
