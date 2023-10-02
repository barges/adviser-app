import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbars/simple_app_bar.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/domain/repositories/zodiac_edit_profile_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/screens/select_methods/select_methods_cubit.dart';
import 'package:zodiac/presentation/screens/select_methods/widgets/main_method_button.dart';
import 'package:zodiac/presentation/screens/select_methods/widgets/methods_list_widget.dart';
import 'package:zodiac/presentation/screens/select_methods/widgets/save_methods_button.dart';

class SelectMethodsScreen extends StatelessWidget {
  final List<int> selectedMethodIds;
  final int? mainMethodId;
  final Function(List<CategoryInfo>, int) returnCallback;

  const SelectMethodsScreen({
    Key? key,
    required this.selectedMethodIds,
    required this.returnCallback,
    this.mainMethodId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectMethodsCubit(
        selectedMethodIds,
        mainMethodId,
        returnCallback,
        zodiacGetIt.get<ZodiacEditProfileRepository>(),
      ),
      child: Scaffold(
        appBar: SimpleAppBar(
          title: SZodiac.of(context).selectMethodsZodiac,
        ),
        body: Builder(builder: (context) {
          final List<CategoryInfo>? methods =
              context.select((SelectMethodsCubit cubit) => cubit.state.methods);
          if (methods != null) {
            return SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: AppConstants.horizontalScreenPadding),
              child: Column(
                children: [
                  MethodsListWidget(methods: methods),
                  const SizedBox(
                    height: 24.0,
                  ),
                  MainMethodButton(methods: methods),
                ],
              ),
            ));
          } else {
            return const SizedBox.shrink();
          }
        }),
        bottomNavigationBar: const SaveMethodsButton(),
      ),
    );
  }
}
