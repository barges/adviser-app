import 'package:zodiac/domain/repositories/home_screen_repository.dart';
import 'package:shared_advisor_interface/infrastructure/architecture/base_usecase.dart';
import 'package:injectable/injectable.dart';

import 'package:shared_advisor_interface/infrastructure/architecture/data/base_error.dart';
import 'package:shared_advisor_interface/infrastructure/architecture/data/base_response.dart';

import 'package:zodiac/zodiac.dart';

@injectable
class HomeScreenUseCase extends BaseUseCase<HomeScreenRepository> {
  HomeScreenUseCase(HomeScreenRepository repository) : super(repository);

  Future<BaseResponse<String, BaseError>> getData() async =>
      repository.getDate();
}
