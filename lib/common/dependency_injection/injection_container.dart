import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:rose_hr/common/networking/api_consumer.dart';
import 'package:rose_hr/common/networking/app_intercepters.dart';
import 'package:rose_hr/common/networking/dio_consumer.dart';
import 'package:rose_hr/common/networking/network_info.dart';
import 'package:rose_hr/features/auth/data/datasources/auth_datasource.dart';
import 'package:rose_hr/features/auth/data/repositories/auth_repository.dart';
import 'package:rose_hr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;
Future<void> init() async {
  ///! Data Sources
  sl
    ..registerLazySingleton<AuthDataSource>(() => AuthDataSource(sl<ApiConsumer>()))
    ///! Repositories
    ..registerLazySingleton<AuthRepository>(() => AuthRepository(sl<AuthDataSource>()))
    // Cubits/Blocs
    ..registerFactory<AuthBloc>(() => AuthBloc(sl<AuthRepository>()))
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
