import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/drawer_cubit.dart';

class BottomSection extends StatelessWidget {
  const BottomSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DrawerCubit cubit = context.read<DrawerCubit>();
    return Column(
      children: [
        const Divider(
          height: 1.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 24.0,
          ),
          child: Column(
            children: [
              _BottomSectionItem(
                icon: Assets.vectors.bookOpen.path,
                text: S.of(context).allOurBrands,
                onTap: cubit.goToAllBrands,
              ),
              const SizedBox(
                height: 16.0,
              ),
              _BottomSectionItem(
                icon: Assets.vectors.questionMark.path,
                text: S.of(context).customerSupport,
                onTap: cubit.goToCustomerSupport,
              ),
              const SizedBox(
                height: 16.0,
              ),
              Builder(builder: (context) {
                String? version =
                    context.select((DrawerCubit cubit) => cubit.state.version);
                bool copyButtonTapped = context.select(
                    (DrawerCubit cubit) => cubit.state.copyButtonTapped);

                return _BottomSectionItem(
                  icon: Assets.vectors.packageOpen.path,
                  text: '${S.of(context).version} ${version ?? ''}',
                  bottomText: copyButtonTapped
                      ? S.of(context).copied
                      : S.of(context).tapToCopy,
                  onTap: cubit.tapToCopy,
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomSectionItem extends StatelessWidget {
  final String icon;
  final String text;
  final VoidCallback onTap;
  final String? bottomText;

  const _BottomSectionItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.bottomText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              height: AppConstants.iconSize,
              width: AppConstants.iconSize,
              color: theme.iconTheme.color,
            ),
            const SizedBox(
              width: 12.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (bottomText != null)
                  Text(
                    bottomText!,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(fontSize: 12.0, color: theme.shadowColor),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
