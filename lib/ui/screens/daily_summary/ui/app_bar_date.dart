import 'package:calorie_counter/ui/screens/daily_summary/bloc/daily_summary_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class AppBarDate extends StatelessWidget {
  const AppBarDate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailySummaryBloc, DailySummaryState>(
      buildWhen: (previous, state) => state is LoadedDateTimeState,
      builder: (context, state) {
        if (state is InitialDailySummaryState) {
          return Container();
        }
        var dailySummaryBloc = state as LoadedDateTimeState;
        var dateTimeString = dailySummaryBloc.dateTimeString;
        var dateTime = dailySummaryBloc.dateTime;

        return _buildHeader(context, dateTimeString, dateTime);
      },
    );
  }

  Widget _buildHeader(BuildContext context, String dateTimeString, DateTime dateTime) {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: Column(children: <Widget>[
        Center(
          child: FittedBox(
            child: Container(
              margin: EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Daily Summary',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        NeumorphicButton(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.symmetric(horizontal: 60.0, vertical: 8.0),
          onPressed: () {
            _buildDatePicker(context, dateTime);
          },
          style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            shadowDarkColorEmboss: Color.fromRGBO(163, 177, 198, 1),
            shadowLightColorEmboss: Colors.white,
            color: Color.fromRGBO(193, 214, 233, 1),
          ),
          child: Row(
            children: <Widget>[
              Text(
                'Date:',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: FittedBox(
                      child: Text(
                        dateTimeString,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Neumorphic(
                child: Icon(Icons.chevron_right),
                style: NeumorphicStyle(
                  boxShape: NeumorphicBoxShape.circle(),
                  shape: NeumorphicShape.convex,
                  shadowDarkColorEmboss: Color.fromRGBO(163, 177, 198, 1),
                  shadowLightColorEmboss: Colors.white,
                  color: Color.fromRGBO(193, 214, 233, 1),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }

  void _buildDatePicker(BuildContext context, DateTime dateTime) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1920),
        lastDate: DateTime(2120));

    if (pickedDate != null) {
      context.read<DailySummaryBloc>().add(ChangeTimeEvent(pickedDate));
      context.read<DailySummaryBloc>().add(LoadTotalNutrientsEvent(pickedDate));
    }
  }
}
