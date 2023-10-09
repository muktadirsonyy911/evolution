import 'package:evolution/app/common/utils/type_def.dart';
import 'package:evolution/app/modules/home/models/common_response_model.dart';

abstract class HomeApiHelper {
 EitherModel<CommonResponseModel> getCommonData();
}
