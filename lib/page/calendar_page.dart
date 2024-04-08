import 'package:diet_junkie/design.dart';
import 'package:diet_junkie/provider/consumed_aliments.dart';
import 'package:diet_junkie/widget/background_container.dart';
import 'package:diet_junkie/widget/cell_calendar.dart';
import 'package:diet_junkie/widget/display_total.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends HookConsumerWidget {
  CalendarPage({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        const BackgroundContainer(),
        Scaffold(
          appBar: AppBar(
            title: const Text('Diet Addict'),
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Center(
            child: TableCalendar(
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: HeaderStyle(),
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
              selectedDayPredicate: (day) {
                return isSameDay(
                    ref.watch(ConsumedAlimentProvider.selectedDayProvider),
                    day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                ref
                    .read(ConsumedAlimentProvider.selectedDayProvider.notifier)
                    .update((state) => selectedDay);
              },
              calendarStyle: CalendarStyle(
                  defaultTextStyle: blackTextStyle(13),
                  todayTextStyle: whiteTextStyle(13),
                  withinRangeTextStyle: blackTextStyle(13)),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, day2) {
                  return CellCalendar(selected: false, day: day, day2: day2);
                },
                selectedBuilder: (context, day, day2) {
                  return CellCalendar(selected: true, day: day, day2: day2);
                },
                todayBuilder: (context, day, day2) {
                  return CellCalendar(selected: false, day: day, day2: day2);
                },
                outsideBuilder: (context, day, day2) {
                  return CellCalendar(
                      selected: false, day: day, day2: day2, outRange: true);
                },
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.all(5),
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: brown75,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(children: [
                      Text(
                        '${ref.watch(ConsumedAlimentProvider.selectedDayProvider.notifier).state.day}/${ref.watch(ConsumedAlimentProvider.selectedDayProvider.notifier).state.month}',
                        style: whiteTextStyle(20),
                      ),
                      ref.watch(ConsumedAlimentProvider.dataByDay).when(
                            loading: () => const Center(
                                child: CircularProgressIndicator()),
                            error: (err, stack) =>
                                Center(child: Text(err.toString())),
                            data: (macros) => DisplayTotal(macro: macros),
                          ),
                    ]),
                  ),
                  Flexible(
                      flex: 1,
                      child: Column(children: [
                        Text(
                          '${ref.watch(ConsumedAlimentProvider.selectedDayProvider.notifier).state.day}/${ref.watch(ConsumedAlimentProvider.selectedDayProvider.notifier).state.month}',
                          style: whiteTextStyle(20),
                        ),
                        ref.watch(ConsumedAlimentProvider.dataByWeek).when(
                              loading: () => const Center(
                                  child: CircularProgressIndicator()),
                              error: (err, stack) =>
                                  Center(child: Text(err.toString())),
                              data: (macros) => DisplayTotal(macro: macros),
                            ),
                      ])),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
