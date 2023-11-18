import 'package:flutter/material.dart';

class LightDarkProvider extends ChangeNotifier {
   ThemeData _themData = ThemeData.dark();
   bool darkMode = true;

   getTheme() => _themData;

   setTheme(ThemeData theme) {
     _themData = theme;

     notifyListeners();
   }
   void setDarkMode() {
     _themData = ThemeData.dark();
     darkMode = true;
     notifyListeners();
   }
   void setLightMode() {
     _themData = ThemeData.light();
     darkMode = false;
     notifyListeners();
   }
}