extension StringX on String {

  static const fullWidthRegExp = r'([\uff01-\uff5e])';
  static const halfWidthRegExp = r'([\u0021-\u007e])';
  static const halfFullWidthDelta = 0xfee0;

  String _convertWidth(String regExpPattern, int delta) {
    return replaceAllMapped(RegExp(regExpPattern),
            (m) => String.fromCharCode(m[1]!.codeUnits[0] + delta)
    );
  }

  String toFullWidth() => _convertWidth(halfWidthRegExp, halfFullWidthDelta);

  String toHalfWidth() => _convertWidth(fullWidthRegExp, -halfFullWidthDelta);

}