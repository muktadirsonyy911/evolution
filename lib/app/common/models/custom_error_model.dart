import '../enums/error_from.dart';

class CustomErrorModel {
  int errorCode;
  ErrorFrom errorFrom;
  String msg;
  Function()? onRetry;

  CustomErrorModel({
    required this.errorCode,
    required this.errorFrom,
    required this.msg,
    this.onRetry,
  });
}
