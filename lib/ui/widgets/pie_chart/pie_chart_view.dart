import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartView extends StatefulWidget {
  final Map<String, double> data;
  final List<Color> listOfColor;
  final Widget child;

  PieChartView({Key key, this.data, this.listOfColor, this.child}) : super(key: key);

  @override
  _PieChartViewState createState() => _PieChartViewState();
}

class _PieChartViewState extends State<PieChartView> {
  @override
  Widget build(BuildContext context) {
    var colors;

    if (widget.data == null) {
      colors = [Colors.black, Colors.transparent];
    } else if (widget.data != null) {
      colors = widget.listOfColor;
    }

    return LayoutBuilder(
        builder: (scontext, constraints) => Neumorphic(
              style: NeumorphicStyle(
                depth: -15,
                boxShape: NeumorphicBoxShape.circle(),
                shadowDarkColorEmboss: Color.fromRGBO(163, 177, 198, 1),
                shadowLightColorEmboss: Colors.white,
                color: Color.fromRGBO(193, 214, 233, 1),
              ),
              child: Container(
                child: Stack(children: <Widget>[
                  _buildPieChart(colors),
                  Positioned.fill(
                    child: widget.child,
                  )
                ]),
              ),
            ));
  }

  Widget _buildPieChart(List<Color> colors) {
    if (widget.data == null) {
      final Map<String, double> mapData = Map();
      mapData.putIfAbsent('Placeholder', () => 0);
      mapData.putIfAbsent('Empty', () => 100);

      return PieChart(
        dataMap: mapData,
        initialAngleInDegree: 11,
        legendOptions: LegendOptions(showLegends: false),
        colorList: colors,
        chartRadius: MediaQuery.of(context).size.width,
        chartValuesOptions: ChartValuesOptions(
            chartValueStyle: defaultChartValueStyle.copyWith(
          color: Colors.black.withOpacity(0),
        )),
      );
    } else {
      return PieChart(
        dataMap: widget.data,
        initialAngleInDegree: 11,
        legendOptions: LegendOptions(showLegends: false),
        colorList: widget.listOfColor,
        chartRadius: MediaQuery.of(context).size.width,
        chartValuesOptions: ChartValuesOptions(
            chartValueStyle: defaultChartValueStyle.copyWith(
          color: Colors.black.withOpacity(0),
        )),
      );
    }
  }
}
