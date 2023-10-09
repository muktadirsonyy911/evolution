import 'package:dartz/dartz.dart';
import 'package:evolution/app/common/api_provider/api_urls.dart';
import 'package:evolution/app/common/models/custom_error_model.dart';
import 'package:evolution/app/common/api_provider/api_provider.dart';
import 'package:evolution/app/common/utils/type_def.dart';
import 'package:evolution/app/modules/home/models/common_response_model.dart';
import 'package:evolution/app/modules/home/repo/home_api_helper.dart';

class HomeApiImpl implements HomeApiHelper {

  final ApiProvider apiProvider = ApiProvider();

  @override
  EitherModel<CommonResponseModel> getCommonData() async {
    Either<CustomErrorModel, CommonResponseModel> response =
        await apiProvider.get(url: ApiUrls.commonApiUrl, fromJson: CommonResponseModel.fromJson);
    return response;
  }
}
