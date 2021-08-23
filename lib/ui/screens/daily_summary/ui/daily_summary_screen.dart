import 'package:calorie_counter/ui/screens/daily_summary/bloc/daily_summary_bloc.dart';
import 'package:calorie_counter/data/local/data_source/main_data_source.dart';
import 'package:calorie_counter/ui/screens/daily_summary/ui/app_bar_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'daily_summary_content_screen.dart';

class DailySummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DailySummaryBloc(RepositoryProvider.of<MainDataSource>(context)),
      child: Scaffold(
          backgroundColor: Color.fromRGBO(193, 214, 233, 1),
          body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AppBarDate(),
                    DailySummaryContentScreen()
                  ],
                ),
              )
          )
      )
    );
  }
}
