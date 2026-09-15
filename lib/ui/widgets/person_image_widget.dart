import 'package:flutter/material.dart';

class PersonImageWidget extends StatelessWidget {
  const PersonImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      foregroundColor: Theme.of(context).scaffoldBackgroundColor,
      backgroundImage: const AssetImage('assets/images/person.jpeg'),
      radius: 18,
    );
  }
}
