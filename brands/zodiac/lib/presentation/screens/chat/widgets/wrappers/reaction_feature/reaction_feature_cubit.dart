import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/presentation/screens/chat/widgets/wrappers/reaction_feature/reaction_feature_state.dart';

class ReactionFeatureCubit extends Cubit<ReactionFeatureState> {
  ReactionFeatureCubit() : super(const ReactionFeatureState());
}
