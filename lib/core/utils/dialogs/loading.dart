import 'package:flutter/material.dart';

import '../../components/loading.dart';

void dialogLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) {
      return PopScope(
        canPop: false,
        child: const Center(child: LoadingComponent()),
      );
    },
  );
}
