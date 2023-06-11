import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/widgets/app_bar.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        text: 'Notifications',
      ),
    );
  }
}
