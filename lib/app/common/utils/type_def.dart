import 'package:dartz/dartz.dart';
import 'package:evolution/app/common/models/custom_error_model.dart';

/// [EitherModel] used when [EitherResponse] get right
/// then convert that response to model type [T]
/// string(left) means has error
/// T(right) means convert response to model successfully
typedef EitherModel<T> = Future<Either<CustomErrorModel, T>>;