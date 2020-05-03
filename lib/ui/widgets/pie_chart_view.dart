import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartView extends StatefulWidget {

  final Map<String, double> data;
  final List<Color> listOfColor;
  final Widget child;

  PieChartView({
    Key key, 
    this.data,
    this.listOfColor,
    this.child
  }): super(key: key);

  @override
  _PieChartViewState createState() => _PieChartViewState();
}

class _PieChartViewState extends State<PieChartView> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (scontext, constraints) => Neumorphic(
          boxShape: NeumorphicBoxShape.circle(),
          style: NeumorphicStyle(
            depth: -20,
            shadowDarkColorEmboss: Color.fromRGBO(163,177,198, 1),
            shadowLightColorEmboss: Colors.white,
            color: Color.fromRGBO(193,214,233, 1),
          ),
          child: Container(
            child: Stack(
              children: <Widget> [
                PieChart(
                  dataMap: widget.data,
                  showLegends: false,
                  colorList: widget.listOfColor,
                  chartRadius: MediaQuery.of(context).size.width,
                  chartValueStyle: defaultChartValueStyle.copyWith(
                  color: Colors.black.withOpacity(0),
                  ),
                ),

                Positioned.fill(
                  child: widget.child,
                )
              ] 
            ),
          ),
        )
    );
  }
}