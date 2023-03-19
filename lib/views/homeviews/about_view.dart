import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/widgets/app_bar.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(text: 'About'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: const [
            Text(
              'ReliefMate',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: GlobalVariables.appBarColor,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'ReliefMate is a mobile app that connects the victims of disaster with helping bodies nationwide. It is the first app of its kind in the world. It\'s free, easy-to-use, and can be downloaded in just a couple of minutes. ',
              style: TextStyle(
                fontSize: 15,
                color: GlobalVariables.appBarBackgroundColor,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'ReliefMate is created to make sure that victims of disasters get the help they need in an emergency. Natural disasters are a major problem that the world faces today. They can strike at any time and place, without warning. And, when they do, the damage they cause can be absolutely devastating.',
              style: TextStyle(
                fontSize: 15,
                color: GlobalVariables.appBarBackgroundColor,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Disasters can happen anytime and anywhere. They can be caused by natural phenomena like floods, earthquakes or by human activities like wars. In the aftermath of a natural disaster, victims are often left stranded and without essential resources. In the recent years, the frequency of natural calamities such as floods, earthquakes, and landslides have increased manifold. As a result, the number of people who require relief assistance has also increased. However, the traditional methods of providing relief are not very efficient',
              style: TextStyle(
                fontSize: 15,
                color: GlobalVariables.appBarBackgroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
