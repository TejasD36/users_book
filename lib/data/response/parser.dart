import '../../../core.dart';

class Parser {
  static Future<Either<AppException, Q>> parseResponse<Q, R>(Response response, ComputeCallback<dynamic, R> callback) async {
    try {
      switch (response.statusCode) {
        case HttpStatus.ok:
        case HttpStatus.created:
          {
            dynamic parsedData;
            if (response.data is List) {
              parsedData = List<Map<String, dynamic>>.from(response.data);
            } else if (response.data is Map) {
              parsedData = Map<String, dynamic>.from(response.data);
            } else {
              throw Exception("Unsupported response format");
            }

            final R result = await compute(callback, parsedData);
            return Right(result as Q);
          }
        default:
          return Left(UnknownError());
      }
    } catch (e) {
      return Left(UnknownError());
    }
  }

  static Future<T> parseResponseBody<T>(String responseBody, T Function(Map<String, dynamic>) fromJson) async {
    final Map<String, dynamic> jsonMap = json.decode(responseBody);
    return fromJson(jsonMap);
  }
}
