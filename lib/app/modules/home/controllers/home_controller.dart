import 'package:evolution/app/modules/home/repo/home_api_helper.dart';
import 'package:evolution/app/modules/home/repo/home_api_impl.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final HomeApiHelper homeApi = HomeApiImpl();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }


  Future<void> getCommonData() async {
    final responseData = await homeApi.getCommonData();

  }
}
