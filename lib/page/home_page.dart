import 'package:diet_junkie/design.dart';
import 'package:diet_junkie/object/macro.dart';
import 'package:diet_junkie/page/add_page.dart';
import 'package:diet_junkie/provider/consumed_aliments.dart';
import 'package:diet_junkie/widget/alims_display_widget.dart';
import 'package:diet_junkie/widget/background_container.dart';
import 'package:diet_junkie/widget/custom_drawer.dart';
import 'package:diet_junkie/widget/display_total.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        const BackgroundContainer(),
        Scaffold(
          backgroundColor: Colors.transparent,

          //APPBAR

          appBar: AppBar(
            title: const Text('Diet Addict'),
            backgroundColor: Colors.transparent,
          ),

          //DRAWER

          drawer: CustomDrawer(),

          //CONTENT

          body: ref.watch(ConsumedAlimentProvider.consumedAlimentStream).when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text(err.toString())),
              data: (ideas) {
                return Padding(
                  padding: EdgeInsets.all(5),
                  child: ListView.builder(
                    itemCount: ideas.length,
                    itemBuilder: (_, index) {
                      return AlimListDisplayWidget(
                          aliment: ideas[index],
                          onPressed: () {
                            ref.read(ConsumedAlimentProvider
                                .deleteAlimentFromFirebase(
                                    ideas[index].alimentId!));
                          });
                    },
                  ),
                );
              }),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.all(5),
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: brown75,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  ref.watch(ConsumedAlimentProvider.consumedAlimentStream).when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, stack) =>
                            Center(child: Text(err.toString())),
                        data: (ideas) {
                          return DisplayTotal(
                              macro: Macros(
                            ideas.fold(
                                0,
                                (previousValue, element) =>
                                    previousValue + element.calorie),
                            ideas.fold(
                                0,
                                (previousValue, element) =>
                                    previousValue + element.protide),
                            ideas.fold(
                                0,
                                (previousValue, element) =>
                                    previousValue + element.lipide),
                            ideas.fold(
                                0,
                                (previousValue, element) =>
                                    previousValue + element.glucide),
                          ));
                        },
                      ),
                  Container(
                    decoration: BoxDecoration(
                      color: yellow50,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: IconButton(
                        icon: Icon(Icons.add),
                        iconSize: 50,
                        color: white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddPage()),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
