import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DetailsErrorPage extends StatelessWidget {
  const DetailsErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No Details Item could be found for this request'),
    );
  }
}
