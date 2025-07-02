import '/core.dart';

abstract class BaseApiServices {
  Future<Either<AppException, Q>> getApi<Q>(
    String apiURL,
    Map<String, String> headers,
    Q Function(dynamic) fromJson, {
    bool disableTokenValidityCheck = false,
    Map<String, dynamic>? queryParams,
  });
}
