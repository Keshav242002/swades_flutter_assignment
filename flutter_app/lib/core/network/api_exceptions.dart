class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class SlotAlreadyBookedException extends ApiException {
  const SlotAlreadyBookedException()
      : super('This slot has already been booked by another user.', statusCode: 409);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException()
      : super('Session expired. Please log in again.', statusCode: 401);
}

class NetworkException extends ApiException {
  const NetworkException()
      : super('No internet connection. Please check your network.');
}


class NotFoundException extends ApiException {
  const NotFoundException(super.message) : super.new(statusCode: 404);
}

class ForbiddenException extends ApiException {
  const ForbiddenException()
      : super('You are not authorized to perform this action.', statusCode: 403);
}
