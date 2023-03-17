import 'package:shared_advisor_interface/data/data_source/remote/home_services.dart';
import 'package:zodiac/domain/repositories/home_screen_repository.dart';
import 'package:injectable/injectable.dart';

import 'package:shared_advisor_interface/infrastructure/architecture/data/base_error.dart';
import 'package:shared_advisor_interface/infrastructure/architecture/data/base_response.dart';
import 'package:zodiac/zodiac.dart';

///Will be responsible to implement the home repository and having the functionality here

@Injectable(as: HomeScreenRepository)
class HomeScreenRepositoryImpl extends HomeScreenRepository {
  final HomeServices services;

  HomeScreenRepositoryImpl(this.services);

  @override
  Future<BaseResponse<String, BaseError>> getDate() => services.getDate();
}
