import 'package:calorie_counter/data/local/data_source/main_data_source.dart';
import 'package:calorie_counter/ui/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/local/data_source/i_data_source.dart';

class App extends StatelessWidget {
  App({required this.mainDataSource});

  final MainDataSource mainDataSource;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [RepositoryProvider.value(value: mainDataSource)], child: MainScreen());
  }
}
