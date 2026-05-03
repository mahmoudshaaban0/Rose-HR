import 'package:rose_hr/common/error/exceptions.dart';
import 'package:rose_hr/common/error/failures.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/notifications/data/datasources/notifications_datasource.dart';
import 'package:rose_hr/features/notifications/data/models/notifications_response_model.dart';

class NotificationsRepository {
  NotificationsRepository(this.notificationsDatasource);
  final NotificationsDataSource notificationsDatasource;

  Future<Result<NotificationsResponseModel>> getNotifications() async {
    try {
      final response = await notificationsDatasource.getNotifications();
      return Success(response);
    } on NoInternetConnectionException catch (e) {
      return Error(NetworkFailure(e.toString()));
    } on BadCertificateException catch (e) {
      return Error(NetworkFailure(e.toString()));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.toString()));
    } on FormatException catch (e) {
      return Error(DataFailure('Invalid data format: ${e.message}'));
    } on Exception catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }
}
