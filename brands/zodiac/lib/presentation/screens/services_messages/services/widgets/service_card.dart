import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_alert.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/data/models/services/service_item.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/app_image_widget.dart';
import 'package:zodiac/presentation/screens/services_messages/services/services_cubit.dart';
import 'package:zodiac/presentation/screens/services_messages/services/widgets/sold_widget.dart';
import 'package:zodiac/zodiac_extensions.dart';

class ServiceCard extends StatelessWidget {
  final ServiceItem serviceItem;

  const ServiceCard({Key? key, required this.serviceItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ServicesCubit servicesCubit = context.read<ServicesCubit>();
    String status =
        statusIntToTranslationString(context, serviceItem.status).toUpperCase();
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: theme.canvasColor,
          borderRadius: const BorderRadius.all(Radius.circular(18.0))),
      child: Column(
        children: [
          Stack(
            children: [
              AppImageWidget(
                uri: Uri.parse(serviceItem.image ?? ''),
                width: double.infinity,
                height: 130.0,
              ),
              Container(
                height: 130.0,
                padding:
                    const EdgeInsets.all(AppConstants.horizontalScreenPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 238.0,
                          child: Text(
                            serviceItem.name ?? '',
                            style: theme.textTheme.displaySmall?.copyWith(
                                fontSize: 14.0,
                                color: theme.canvasColor,
                                overflow: TextOverflow.ellipsis),
                            maxLines: 2,
                          ),
                        ),
                        const Spacer(),
                        if (status != '')
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.promotion,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 6.0,
                            ),
                            child: Text(
                              status,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontSize: 12.0,
                                color: theme.canvasColor,
                              ),
                            ),
                          ),
                        const SizedBox(height: 8.0),
                        const _TimeWidget()
                      ],
                    ),
                    const SoldWidget(
                      sold: 168,
                      like: 160,
                      unlike: 8,
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(
              AppConstants.horizontalScreenPadding,
            ),
            width: MediaQuery.of(context).size.width -
                AppConstants.horizontalScreenPadding * 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width -
                      AppConstants.horizontalScreenPadding * 2,
                  child: Text(
                    serviceItem.description ?? '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 7,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 14.0,
                      color: theme.shadowColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Assets.zodiac.vectors.onlineService.svg(),
                    const SizedBox(width: 8.0),
                    Text(
                      'Online service',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 14.0,
                        color: theme.primaryColor,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        serviceItem.price != null
                            ? serviceItem.price!.toCurrencyFormat('\$', 2)
                            : '',
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontSize: 14.0,
                          color: theme.hoverColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          if (serviceItem.id != null) {
                            context.push(
                                route: ZodiacEditService(
                                    serviceId: serviceItem.id!));
                          }
                        },
                        child: Assets.zodiac.vectors.edit.svg()),
                    const SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: () async {
                        if (await showOkCancelAlert(
                              context: context,
                              title: SZodiac.of(context)
                                  .doYouWantDeleteServicesZodiac(
                                      serviceItem.name ?? ''),
                              description: SZodiac.of(context)
                                  .itWillBeRemovedFromServicesZodiac,
                              okText: SZodiac.of(context).deleteZodiac,
                              okTextColor: theme.errorColor,
                              allowBarrierClick: false,
                              isCancelEnabled: true,
                            ) ==
                            true) {
                          if (serviceItem.id != null) {
                            servicesCubit.deleteService(serviceItem.id!);
                          }
                        }
                      },
                      child: Assets.vectors.delete.svg(),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeWidget extends StatelessWidget {
  const _TimeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: theme.canvasColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        '20 MIN',
        style: theme.textTheme.labelSmall?.copyWith(
          fontSize: 12.0,
          color: theme.primaryColor,
        ),
      ),
    );
  }
}

String statusIntToTranslationString(BuildContext context, int? status) {
  if (status == null) {
    return '';
  }

  switch (status) {
    case 0:
      return SZodiac.of(context).newZodiac;
    case 1:
      return SZodiac.of(context).approvedZodiac;
    case 2:
      return SZodiac.of(context).rejectedZodiac;
    case 3:
      return SZodiac.of(context).tempZodiac;
    default:
      return '';
  }
}
