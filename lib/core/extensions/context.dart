import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  Size get _size => MediaQuery.of(this).size;
  double get height => _size.height;
  double get width => _size.width;
}
