import 'package:flutter/widgets.dart';
import 'package:puzzle_hack/utils/singleton.dart';

extension ToScreenSize on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;

  bool get isMobile => MediaQuery.of(this).size.width < 850;

  bool get isTablet =>
      MediaQuery.of(this).size.width < 1100 &&
      MediaQuery.of(this).size.width >= 850;

  bool get isDesktop => MediaQuery.of(this).size.width >= 1100;
}

extension SameOrder on List {
  bool isSameOrder(List another) {
    bool result = true;
    for (var i = 0; i < length; i++) {
      if (this[i] != another[i]) result = false;
    }
    return result;
  }
}

extension TwoInt on int {
  String get two => this < 9 ? "0$this" : toString();
}

extension ToInt on String {
  int get i => int.parse(this);
}

extension Global on State {
  Singleton get global => Singleton();
}

extension GlobalFul on StatefulWidget {
  Singleton get global => Singleton();
}

extension GlobalLess on StatelessWidget {
  Singleton get global => Singleton();
}
