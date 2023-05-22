import 'package:flutter/cupertino.dart';

import '../utils/app_theme.dart';

Widget loginCreditWidget() {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'By DoVT2',
              style: AppTheme.loginHelpStyle,
            ),
            const SizedBox(height: 5),
            Text(
              'From HCM23_FR_NET01 with love ❤',
              style: AppTheme.loginHelpStyle,
            ),
          ],
        ),
      ),
    ),
  );
}
