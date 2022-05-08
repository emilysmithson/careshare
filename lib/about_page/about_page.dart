import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  static const routeName = '/about-page';


  const AboutPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double spacing = 16;
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Careshare'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Careshare is the genius idea of Emily and Tina...')

            ],
          )

        ),
      ),
    );
  }
}
