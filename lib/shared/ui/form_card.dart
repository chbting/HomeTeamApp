import 'package:flutter/material.dart';

class FormCard extends StatelessWidget {
  const FormCard({Key? key, this.title, required this.body}) : super(key: key);

  final String? title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title == null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(title!,
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
            body
          ],
        ),
      ),
    );
  }
}
