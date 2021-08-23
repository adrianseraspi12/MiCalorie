import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Snackbar {
  final BuildContext _context;
  SnackBar? snackbar;

  Snackbar(this._context);

  showSnackbar(
      String content,
      String snackbarActionLabel,
      VoidCallback snackbarActionCallback,
      VoidCallback onDismissCallback) {
    if (snackbar != null) {
      removeSnackbar();
    }
    snackbar = SnackBar(
      content: Text(content),
      action: SnackBarAction(
          label: snackbarActionLabel,
          onPressed: snackbarActionCallback
      ),
    );

    ScaffoldMessenger.of(_context).showSnackBar(snackbar!).closed.then((reason) => {
     if (reason == SnackBarClosedReason.dismiss ||
          reason == SnackBarClosedReason.hide ||
          reason == SnackBarClosedReason.swipe ||
          reason == SnackBarClosedReason.timeout)
        {
          onDismissCallback()
        }
    });
  }

  removeSnackbar() {
    ScaffoldMessenger.of(_context).removeCurrentSnackBar();
  }
}
