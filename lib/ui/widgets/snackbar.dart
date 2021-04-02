import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Snackbar {
  final GlobalKey<ScaffoldState> _scaffoldKey;
  SnackBar snackbar;

  Snackbar(this._scaffoldKey);

  showSnackbar(String content, String snackbarActionLabel,
      Function snackbarActionCallback, Function onDismissCallback) {
    if (snackbar != null) {
      removeSnackbar();
    }
    snackbar = SnackBar(
      content: Text(content),
      action: SnackBarAction(
          label: snackbarActionLabel, onPressed: snackbarActionCallback),
    );

    _scaffoldKey.currentState.showSnackBar(snackbar).closed.then((reason) => {
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
    _scaffoldKey.currentState.removeCurrentSnackBar();
  }
}
