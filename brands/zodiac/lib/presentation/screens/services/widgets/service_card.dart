import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_delete_alert.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/data/models/enums/service_status.dart';
import 'package:zodiac/data/models/services/service_item.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/app_image_widget.dart';
import 'package:zodiac/presentation/common_widgets/blackout_widget.dart';
import 'package:zodiac/presentation/screens/services/services_cubit.dart';
import 'package:zodiac/zodiac_extensions.dart';

class ServiceCard extends StatelessWidget {
  final ServiceItem serviceItem;

  const ServiceCard({Key? key, required this.serviceItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ServicesCubit servicesCubit = context.read<ServicesCubit>();
    final ServiceStatus? status = serviceItem.status;
    final isRejected = status == ServiceStatus.rejected;
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: theme.canvasColor,
          borderRadius: const BorderRadius.all(Radius.circular(18.0))),
      child: Column(
        children: [
          Stack(
            children: [
              BlackoutWidget(
                child: AppImageWidget(
                  uri: Uri.parse(serviceItem.image ?? ''),
                  width: double.infinity,
                  height: 130.0,
                ),
              ),
              Container(
                height: 130.0,
                padding:
                    const EdgeInsets.all(AppConstants.horizontalScreenPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            serviceItem.name ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.displaySmall?.copyWith(
                                fontSize: 14.0,
                                color: theme.backgroundColor,
                                overflow: TextOverflow.ellipsis),
                          ),
                          const Spacer(),
                          if (status != null)
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 4.0,
                                  ),
                                  child: _LabelWidget(
                                    text: status.getTitle(context),
                                    textColor: theme.backgroundColor,
                                    color: status.labelBackgroundColor,
                                  ),
                                ),
                                if (isRejected)
                                  Assets.zodiac.vectors.infoSquareSmall.svg(
                                    height: 19.0,
                                    color: theme.backgroundColor,
                                  ),
                              ],
                            ),
                          const SizedBox(height: 8.0),
                          _LabelWidget(
                            text: serviceItem.durationView ?? '',
                            textColor: theme.primaryColor,
                            color: theme.canvasColor,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: _LabelWidget(
                        text: SZodiac.of(context).newZodiac.toUpperCase(),
                        textColor: theme.backgroundColor,
                        color: AppColors.promotion,
                      ),
                    ),
                    // TODO Implement in next version
                    /*const SoldWidget(
                      sold: 168,
                      like: 160,
                      unlike: 8,
                    )*/
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
                // TODO Implement in next version
                /*AppElevatedButton(
                  title: serviceItem.isActive
                      ? SZodiac.of(context).completeZodiac
                      : SZodiac.of(context).activateZodiac,
                  color: theme.primaryColor,
                  onPressed: () => context.push(
                    route: const ZodiacCompleteService(),
                  ),
                ),*/
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (serviceItem.type != null)
                      Row(
                        children: [
                          SvgPicture.asset(
                            serviceItem.type!.iconPath,
                            color: theme.primaryColor,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            serviceItem.type!.getTitle(context),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
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
                        if (await showDeleteAlert(
                              context,
                              SZodiac.of(context).doYouWantDeleteServicesZodiac(
                                  serviceItem.name ?? ''),
                              description: SZodiac.of(context)
                                  .itWillBeRemovedFromServicesZodiac,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LabelWidget extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color color;
  const _LabelWidget(
      {Key? key,
      required this.text,
      required this.textColor,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6.0,
        vertical: 2.0,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        text.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          fontSize: 12.0,
          color: textColor,
        ),
      ),
    );
  }
}
