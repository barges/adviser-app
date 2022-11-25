import 'package:bloc/bloc.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_type.dart';
import 'package:shared_advisor_interface/data/models/enums/sessions_types.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_sessions/customer_sessions_state.dart';

class CustomerSessionsCubit extends Cubit<CustomerSessionsState> {
  final List<ChatItemType> filters = [
    ChatItemType.all,
    ChatItemType.ritual,
    ChatItemType.private,
  ];

  ///TODO - Delete this hardcode!
  final List<ChatItem> items = const [
    ChatItem(
        type: ChatItemType.private,
        ritualIdentifier: SessionsTypes.private,
        content: 'Convallis proin faucibus amet etiam netus.'),
    ChatItem(
        type: ChatItemType.ritual,
        ritualIdentifier: SessionsTypes.palmreading,
        content: 'Convallis proin faucibus amet etiam netus.'),
    ChatItem(
        type: ChatItemType.history,
        ritualIdentifier: SessionsTypes.reading360,
        content: 'Convallis proin faucibus amet etiam netus.'),
    ChatItem(
        type: ChatItemType.history,
        ritualIdentifier: SessionsTypes.palmreading,
        content: 'Convallis proin faucibus amet etiam netus.'),
    ChatItem(
        type: ChatItemType.history,
        ritualIdentifier: SessionsTypes.ritual,
        content: 'Convallis proin faucibus amet etiam netus.'),
    ChatItem(
        type: ChatItemType.history,
        ritualIdentifier: SessionsTypes.public,
        content: 'Convallis proin faucibus amet etiam netus.'),
    ChatItem(
        type: ChatItemType.history,
        ritualIdentifier: SessionsTypes.lovecrushreading,
        content: 'Convallis proin faucibus amet etiam netus.'),
    ChatItem(
        type: ChatItemType.history,
        ritualIdentifier: SessionsTypes.private,
        content: 'Convallis proin faucibus amet etiam netus.'),
    ChatItem(
        type: ChatItemType.history,
        ritualIdentifier: SessionsTypes.astrology,
        content: 'Convallis proin faucibus amet etiam netus.'),
    ChatItem(
        type: ChatItemType.history,
        ritualIdentifier: SessionsTypes.aurareading,
        content: 'Convallis proin faucibus amet etiam netus.'),
  ];

  CustomerSessionsCubit() : super(const CustomerSessionsState());

  void changeFilterIndex(int newIndex) {
    emit(state.copyWith(currentFilterIndex: newIndex));
  }
}
