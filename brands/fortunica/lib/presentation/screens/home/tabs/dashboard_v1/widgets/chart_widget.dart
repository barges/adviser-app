import 'package:shared_advisor_interface/app_constants.dart';
import 'package:blur/blur.dart';
import 'package:charts_painter/chart.dart';
import 'package:flutter/material.dart';
import 'package:fortunica/generated/l10n.dart';

class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  final List<_TestChart> _lst = [
    _TestChart(time: '9AM', value: 15.0),
    _TestChart(time: '', value: 18.0),
    _TestChart(time: '14PM', value: 25.0),
    _TestChart(time: '', value: 17.0),
    _TestChart(time: '19PM', value: 28.0),
    _TestChart(time: '', value: 20.0),
    _TestChart(time: '8AM', value: 12.0),
    _TestChart(time: '', value: 15.0),
    _TestChart(time: '14PM', value: 26.0),
    _TestChart(time: '', value: 15.0),
    _TestChart(time: '19PM', value: 10.0),
  ];

  int? selectedItem;

  double? maximumValue;

  @override
  void initState() {
    maximumValue = _lst.reduce((a, b) => a.value > b.value ? a : b).value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Blur(
      blur: 2.0,
      blurColor: Theme.of(context).canvasColor,
      overlay: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            SFortunica.of(context).comingSoonFortunica,
            style: Theme.of(context)
                .textTheme
                .displayLarge
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          Text(SFortunica.of(context).performanceOverviewAnalyticsFortunica,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Theme.of(context).shadowColor))
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.horizontalScreenPadding),
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    SFortunica.of(context).avgDailyEarningsFortunica,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                Text('\$105',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800))
              ],
            ),
            const SizedBox(
              height: 34.0,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  Chart(
                    width: MediaQuery.of(context).size.width,
                    height: 68.0,
                    state: ChartState(
                      ChartData.fromList(
                          _lst.map((e) => BarValue<void>(e.value)).toList(),
                          axisMax: maximumValue!),
                      behaviour: ChartBehaviour(
                          isScrollable: true,
                          onItemClicked: ((value) => setState(() {
                                selectedItem = value;
                              }))),
                      itemOptions: BarItemOptions(
                          maxBarWidth: 32.0,
                          minBarWidth: 32.0,
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          radius: BorderRadius.circular(4.0),
                          color: Theme.of(context).primaryColorLight,
                          colorForValue: ((defaultColor, value, [min]) =>
                              value == maximumValue!
                                  ? Theme.of(context).primaryColor
                                  : defaultColor)),
                      backgroundDecorations: [
                        HorizontalAxisDecoration(
                          showLines: false,
                          endWithChart: false,
                        )
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(height: 1.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: _getValuesOfXAxis(_lst),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Text('Monday', style: Theme.of(context).textTheme.labelMedium)
          ],
        ),
      ),
    );
  }

  List<Widget> _getValuesOfXAxis(List<_TestChart> values) {
    List<Widget> childrens = List.empty(growable: true);
    for (_TestChart value in values) {
      childrens.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SizedBox(
            width: 32.0,
            child: Center(
              child: Text(value.time,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).shadowColor)),
            )),
      ));
    }
    return childrens;
  }
}

///TODO - Delete this class
class _TestChart {
  final String time;
  final double value;

  _TestChart({required this.time, required this.value});
}
