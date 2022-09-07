import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/presentation/base_screen/listening_brand_controller.dart';

abstract class RunnableController extends ListeningBrandController {
  final RxBool isLoading = false.obs;

  RunnableController(CacheManager cacheManager)
      : super(cacheManager);

  Future<T> run<T>(Future<T> future) async {
    isLoading.value = true;
    try {
      final result = await future;
      return result;
    } on DioError catch (e) {
      isLoading.value = false;
      return Future.error(e);
    } catch (e) {
      isLoading.value = false;
      return Future.error(e);
    } finally {
      isLoading.value = false;
    }
  }
}
