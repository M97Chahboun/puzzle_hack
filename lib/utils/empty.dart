class Empty {
  final double? x;
  final double? y;
  final int value;

  Empty({this.x, this.y, this.value = 16});
  Empty copyWith({double? x, double? y}) {
    return Empty(x: x ?? this.x, y: y ?? this.y, value: value);
  }

  @override
  String toString() {
    return "x:$x,y:$y";
  }

  @override
  bool operator ==(Object other) =>
      other is Empty &&
      other.runtimeType == runtimeType &&
      other.x == x &&
      other.y == y;

  @override
  int get hashCode => (x! + y!).hashCode;
}
