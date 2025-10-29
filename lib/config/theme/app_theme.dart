import 'package:flutter/material.dart';

class AppTheme {
  static final primary = Color(0xFF2862F5);

  ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: primary,

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white, // fondo blanco
        isDense: true, // altura compacta
        contentPadding: EdgeInsets.symmetric(
          // padding interno
          horizontal: 16,
          vertical: 14,
        ),

        // Texto del hint/label (gris suave)
        hintStyle: TextStyle(color: Color(0xFF9AA3AF)),
        labelStyle: TextStyle(color: Color(0xFF9AA3AF)),

        // Borde por defecto: gris muy claro y redondeado
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),

        // Al enfocar: azul fino
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: primary, width: 1.8),
        ),

        // En error
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.red, width: 1.8),
        ),

        // Que el label no “flote” (queda como placeholder)
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
