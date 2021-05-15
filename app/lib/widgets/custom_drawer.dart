import 'package:app/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: Utils.secondaryBackground,
      ),
    );
  }
}
