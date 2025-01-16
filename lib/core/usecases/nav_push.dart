import 'package:flutter/material.dart';

void navPush(BuildContext context, Widget view) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => view));
}

void navReplace(BuildContext context, Widget view) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => view));
}

void navPop(BuildContext context) {
  Navigator.of(context).pop();
}
