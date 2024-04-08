import 'package:diet_junkie/design.dart';
import 'package:diet_junkie/object/height.dart';
import 'package:diet_junkie/provider/height_provider.dart';
import 'package:diet_junkie/widget/background_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HeightPage extends HookConsumerWidget {
  HeightPage({
    Key? key,
  }) : super(key: key);

  TextEditingController _controllers = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late List<Height> chartData = [];
    late ChartSeriesController _chartSeriesController;
    return Stack(
      children: [
        const BackgroundContainer(),
        Scaffold(
            backgroundColor: Colors.transparent,

            //APPBAR

            appBar: AppBar(
              title: Text('Diet Addict'),
              backgroundColor: Colors.transparent,
            ),

            //CONTENT

            body: ref.watch(HeightProvider.heightStream).when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text(err.toString())),
                  data: (ideas) {
                    return Padding(
                        padding: EdgeInsets.all(5),
                        child: SfCartesianChart(
                            series: <LineSeries<Height, DateTime>>[
                              LineSeries<Height, DateTime>(
                                onRendererCreated:
                                    (ChartSeriesController controller) {
                                  _chartSeriesController = controller;
                                },
                                dataSource: ideas,
                                color: Color.fromARGB(255, 0, 0, 0),
                                xValueMapper: (Height sales, _) => sales.date,
                                yValueMapper: (Height sales, _) => sales.height,
                              )
                            ],
                            primaryXAxis: DateTimeAxis(
                                minimum: DateTime(2023, 3, 20),
                                maximum: DateTime(2023, 8, 20),
                                majorGridLines: const MajorGridLines(
                                  width: 0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                edgeLabelPlacement: EdgeLabelPlacement.shift,
                                title: AxisTitle(text: 'Jours')),
                            primaryYAxis: NumericAxis(
                                axisLine: const AxisLine(width: 0),
                                interval: 10,
                                minimum: 70,
                                maximum: 95,
                                majorTickLines: const MajorTickLines(size: 0),
                                title: AxisTitle(text: 'Poids'))));
                  },
                ),
            bottomNavigationBar: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: brown75,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                            child: Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: TextField(
                                autofocus: true,
                                cursorColor: white,
                                style: whiteTextStyle(20),
                                onChanged: (value) {},
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^(.*|[0-9]*)'))
                                ],
                                controller: _controllers,
                              ),
                            ),
                            IconButton(
                              iconSize: 75,
                              color: white,
                              icon: Icon(Icons.add),
                              onPressed: _controllers.text != ''
                                  ? (() {
                                      ref.read(HeightProvider.addHeight(Height(
                                          double.parse(_controllers.text),
                                          DateTime.now())));
                                    })
                                  : null,
                            ),
                          ],
                        ))))))
      ],
    );
  }
}
