import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/user_info/detailed_user_info.dart';
import 'package:zodiac/presentation/screens/edit_profile/edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final ZodiacCachingManager _cachingManager;

  EditProfileCubit(this._cachingManager) : super(const EditProfileState()) {
    final DetailedUserInfo? detailedUserInfo =
        _cachingManager.getDetailedUserInfo();
    emit(state.copyWith(detailedUserInfo: detailedUserInfo));
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
