import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/service/slider_widget.dart';
import 'package:zodiac/presentation/screens/add_service/add_service_cubit.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/tabs_widget.dart';

class DeliveryTimeSliderWidget extends StatelessWidget {
  const DeliveryTimeSliderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AddServiceCubit addServiceCubit = context.read<AddServiceCubit>();

    final DeliveryTimeTabType selectedDeliveryTimeTab = context
        .select((AddServiceCubit cubit) => cubit.state.selectedDeliveryTimeTab);

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: theme.canvasColor,
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            SZodiac.of(context).deliveryTimeZodiac,
            style: theme.textTheme.headlineMedium?.copyWith(fontSize: 17.0),
          ),
          const SizedBox(
            height: 12.0,
          ),
          Row(
            children: [
              Expanded(
                child: TabWidget(
                  title: SZodiac.of(context).minutesFullZodiac,
                  isSelected:
                      selectedDeliveryTimeTab == DeliveryTimeTabType.minutes,
                  unselectedColor: theme.scaffoldBackgroundColor,
                  onTap: () => addServiceCubit
                      .onDeliveryTimeTabChanged(DeliveryTimeTabType.minutes),
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: TabWidget(
                  title: SZodiac.of(context).hoursZodiac.capitalize ?? '',
                  isSelected:
                      selectedDeliveryTimeTab == DeliveryTimeTabType.hours,
                  unselectedColor: theme.scaffoldBackgroundColor,
                  onTap: () => addServiceCubit
                      .onDeliveryTimeTabChanged(DeliveryTimeTabType.hours),
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: TabWidget(
                  title: SZodiac.of(context).daysZodiac.capitalize ?? '',
                  isSelected:
                      selectedDeliveryTimeTab == DeliveryTimeTabType.days,
                  unselectedColor: theme.scaffoldBackgroundColor,
                  onTap: () => addServiceCubit
                      .onDeliveryTimeTabChanged(DeliveryTimeTabType.days),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12.0,
          ),
          Builder(builder: (context) {
            final double deliveryTime = context
                .select((AddServiceCubit cubit) => cubit.state.deliveryTime);
            return SliderWidget(
              value: deliveryTime,
              min: selectedDeliveryTimeTab.min,
              max: selectedDeliveryTimeTab.max,
              stepSize: 1,
              onChanged: addServiceCubit.onDeliveryTimeChanged,
              tooltipFormater: (value) => selectedDeliveryTimeTab.formatter(
                  context, value.toStringAsFixed(0)),
              labelFormatter: (value) => selectedDeliveryTimeTab.formatter(
                  context, value.toStringAsFixed(0)),
            );
          }),
        ],
      ),
    );
  }
}

enum DeliveryTimeTabType {
  minutes,
  hours,
  days;

  double get min {
    switch (this) {
      case minutes:
        return 10;
      case hours:
        return 1;
      case days:
        return 1;
    }
  }

  double get max {
    switch (this) {
      case minutes:
        return 60;
      case hours:
        return 23;
      case days:
        return 7;
    }
  }

  String formatter(BuildContext context, String value) {
    switch (this) {
      case minutes:
        return '$value ${SZodiac.of(context).minutesZodiac}';
      case hours:
        return '$value ${SZodiac.of(context).hoursZodiac}';
      case days:
        return '$value ${SZodiac.of(context).daysZodiac}';
    }
  }

  double get defaultValue {
    switch (this) {
      case minutes:
        return 20;
      case hours:
        return 12;
      case days:
        return 3;
    }
  }

  static DeliveryTimeTabType? fromSeconds(int? value) {
    if (value != null) {
      final Duration duration = Duration(seconds: value);

      if (duration.inDays > 0) {
        return DeliveryTimeTabType.days;
      } else if (duration.inHours > 0) {
        return DeliveryTimeTabType.hours;
      } else {
        return DeliveryTimeTabType.minutes;
      }
    }
    return null;
  }

  double? deliveryTimeFromSeconds(int? value) {
    if (value != null) {
      final Duration duration = Duration(seconds: value);

      switch (this) {
        case DeliveryTimeTabType.days:
          return duration.inDays.toDouble();
        case DeliveryTimeTabType.hours:
          return duration.inHours.toDouble();
        case DeliveryTimeTabType.minutes:
          return duration.inMinutes.toDouble();
      }
    }
    return null;
  }

  int toSeconds(int value) {
    Duration duration;
    switch (this) {
      case DeliveryTimeTabType.days:
        duration = Duration(days: value);
      case DeliveryTimeTabType.hours:
        duration = Duration(hours: value);
      case DeliveryTimeTabType.minutes:
        duration = Duration(minutes: value);
    }
    return duration.inSeconds;
  }
}
