import 'package:flutter/cupertino.dart';

import '../generated/l10n.dart';

class TextHelper {
  static late S s;

  static void ensureInitialized(BuildContext context) {
    s = S.of(context);
  }
}
