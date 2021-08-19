import 'package:calorie_counter/ui/widgets/pie_chart/pie_chart_view.dart';
import 'package:calorie_counter/util/extension/ext_number_rounding.dart';
import 'package:flutter/material.dart';

import '../neumorphic/circular_view.dart';

class NutrientPieChartView extends StatelessWidget {
  final int calories;
  final int carbs;
  final int fat;
  final int protein;
  final isShowChartIfEmpty;

  NutrientPieChartView(
      {Key? key,
      this.calories = 0,
      this.carbs = 0,
      this.fat = 0,
      this.protein = 0,
      this.isShowChartIfEmpty = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var fullNutrientsData = _getNutrientPercentage();
    var height = MediaQuery.of(context).size.height;
    final calorieColors = [Colors.green, Colors.red, Colors.blue];
    final carbsColor = [Colors.green, Colors.transparent];
    final fatColor = [Colors.red, Colors.transparent];
    final proteinColor = [Colors.blue, Colors.transparent];

    double carbsPercentage;
    double fatPercentage;
    double proteinPercentage;

    if (calories >= 0 && carbs == 0 && fat == 0 && protein == 0) {
      carbsPercentage = 0;
      fatPercentage = 0;
      proteinPercentage = 0;
    } else {
      carbsPercentage = fullNutrientsData[NutrientDataType.CARBS]!['Carbs'].roundTo(1);
      fatPercentage = fullNutrientsData[NutrientDataType.FAT]!['Fat'].roundTo(1);
      proteinPercentage = fullNutrientsData[NutrientDataType.PROTEIN]!['Protein'].roundTo(1);
    }

    return Column(
      children: <Widget>[
        SizedBox(
          height: height * 0.35,
          child: Container(
            margin: EdgeInsets.only(top: 16.0),
            child: PieChartView(
                listOfColor: calorieColors,
                data: fullNutrientsData[NutrientDataType.CALORIES],
                child: CircularView(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    Text(
                      '$calories',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Calories',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ]),
                )),
          ),
        ),
        SizedBox(
          height: height * 0.25,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                _buildPieChart(carbsColor, fullNutrientsData[NutrientDataType.CARBS], carbs,
                    carbsPercentage, 'Carbs'),
                _buildPieChart(
                    fatColor, fullNutrientsData[NutrientDataType.FAT], fat, fatPercentage, 'Fat'),
                _buildPieChart(proteinColor, fullNutrientsData[NutrientDataType.PROTEIN], protein,
                    proteinPercentage, 'Protein')
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPieChart(List<Color> listOfColor, Map<String, double>? data, int? nutrientGram,
      double nutrientPercentage, String title) {
    if (calories >= 0 && carbs == 0 && fat == 0 && protein == 0 && !isShowChartIfEmpty) {
      return Expanded(flex: 1, child: Container());
    }

    final fontColor = listOfColor[0];

    return Expanded(
        flex: 1,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: PieChartView(
              listOfColor: listOfColor,
              data: data,
              child: CircularView(
                  child: Align(
                      alignment: Alignment.center,
                      child: FittedBox(
                        child: Container(
                          margin: EdgeInsets.all(4.0),
                          child: Text(
                            '${nutrientGram}g',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ))),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16.0),
            child: Column(
              children: <Widget>[
                Text(title,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    )),
                Text('$nutrientPercentage%',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: fontColor,
                      fontWeight: FontWeight.w700,
                    )),
              ],
            ),
          )
        ]));
  }

  Map<NutrientDataType, Map<String, double>?> _getNutrientPercentage() {
    if (calories >= 0 && carbs == 0 && fat == 0 && protein == 0) {
      Map<NutrientDataType, Map<String, double>?> fullNutrientsData = Map();
      fullNutrientsData.putIfAbsent(NutrientDataType.CALORIES, () => null);
      fullNutrientsData.putIfAbsent(NutrientDataType.CARBS, () => null);
      fullNutrientsData.putIfAbsent(NutrientDataType.FAT, () => null);
      fullNutrientsData.putIfAbsent(NutrientDataType.PROTEIN, () => null);
      return fullNutrientsData;
    }

    final computedCarbs = carbs * 4;
    final computedFat = fat * 9;
    final computedProtein = protein * 4;
    final totalNutrient = computedCarbs + computedFat + computedProtein;

    final carbPercentage = (computedCarbs / totalNutrient) * 100;
    final fatPercentage = (computedFat / totalNutrient) * 100;
    final proteinPercentage = (computedProtein / totalNutrient) * 100;

    Map<String, double> calorieData = Map();
    calorieData.putIfAbsent('Carbs', () => carbPercentage);
    calorieData.putIfAbsent('Fat', () => fatPercentage);
    calorieData.putIfAbsent('Protein', () => proteinPercentage);

    Map<String, double> carbsData = Map();
    carbsData.putIfAbsent('Carbs', () => carbPercentage);
    carbsData.putIfAbsent('Other', () => (100 - carbPercentage));

    Map<String, double> fatData = Map();
    fatData.putIfAbsent('Fat', () => fatPercentage);
    fatData.putIfAbsent('Other', () => (100 - fatPercentage));

    Map<String, double> proteinData = Map();
    proteinData.putIfAbsent('Protein', () => proteinPercentage);
    proteinData.putIfAbsent('Other', () => (100 - proteinPercentage));

    Map<NutrientDataType, Map<String, double>> fullNutrientsData = Map();
    fullNutrientsData.putIfAbsent(NutrientDataType.CALORIES, () => calorieData);
    fullNutrientsData.putIfAbsent(NutrientDataType.CARBS, () => carbsData);
    fullNutrientsData.putIfAbsent(NutrientDataType.FAT, () => fatData);
    fullNutrientsData.putIfAbsent(NutrientDataType.PROTEIN, () => proteinData);

    return fullNutrientsData;
  }
}

enum NutrientDataType { CALORIES, CARBS, FAT, PROTEIN }
