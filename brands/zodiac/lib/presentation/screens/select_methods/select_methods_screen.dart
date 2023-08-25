import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbars/simple_app_bar.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/select_methods/select_methods_cubit.dart';

class SelectMethodsScreen extends StatelessWidget {
  final List<int> selectedCategoryIds;
  final int? mainCategoryId;
  final Function(List<CategoryInfo>, int) returnCallback;

  const SelectMethodsScreen({
    Key? key,
    required this.selectedCategoryIds,
    required this.returnCallback,
    this.mainCategoryId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectMethodsCubit(),
      child: Scaffold(
        appBar: SimpleAppBar(
          title: SZodiac.of(context).selectMethodsZodiac,
        ),
        body: Column(),
      ),
    );
  }
}
