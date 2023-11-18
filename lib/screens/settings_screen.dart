import 'package:flutter/material.dart';
import 'package:fpms/screens/alarms_screen.dart';
import 'package:fpms/screens/logs_screen.dart';
import 'package:fpms/screens/setup_screen.dart';
import '../models/settings_categories.dart';
import '../utils/utils.dart';
import 'modes_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final List<SettingCategory> _categories = const [
    SettingCategory(1, "Modes", "#A9CCE3"),
    SettingCategory(2, "Alarms", "#C5F0B3"),
    SettingCategory(3, "Setup", "#A9CCE3"),
    SettingCategory(4, "Logs", "#C5F0B3"),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: _categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).orientation == Orientation.landscape ? 3 : 2
        ),
        itemBuilder: (context, index) {
          return TileCategory(_categories[index]);
        },
      ),
    );
  }
}

class TileCategory extends StatelessWidget {
  final SettingCategory _category;
  const TileCategory(this._category, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(4.0),
          onTap: () {
            _navigateToBooksWithCategory(context, _category);
          },
          child: Container(
              alignment: AlignmentDirectional.center ,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: hexToColor(_category.colorBg)
              ),
              child: Text(
                _category.name,
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,)),
        ));
  }

  void _navigateToBooksWithCategory(BuildContext context, SettingCategory category) {
    if(category.name == 'Modes') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ModesScreen()));
    }
    if(category.name == 'Alarms') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AlarmsScreen()));
    }
    if(category.name == 'Setup') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => SetupScreen()));
    }
    if(category.name == 'Logs') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => LogsScreen()));
    }
  }
}

