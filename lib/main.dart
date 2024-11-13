// ignore_for_file: camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_chart_graph_map_project/views/show_map_ui.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const flutterChartGraphMap());
}

class flutterChartGraphMap extends StatefulWidget {
  const flutterChartGraphMap({super.key});

  @override
  State<flutterChartGraphMap> createState() => _flutterChartGraphMapState();
}

class _flutterChartGraphMapState extends State<flutterChartGraphMap> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShowMapUI(),
      theme: ThemeData(
        textTheme: GoogleFonts.kanitTextTheme(
          Theme.of(context).textTheme
        )
      ),
    );
  }
}