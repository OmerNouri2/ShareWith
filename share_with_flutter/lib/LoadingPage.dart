import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Center(
        child: SpinKitCircle(
          size: 140,
          // color: Color.fromARGB(255, 7, 176, 255),
          itemBuilder: (context, index) {
            final colors = [Colors.white70, Color.fromARGB(255, 7, 176, 255)];
            final color = colors[index % colors.length];
            return DecoratedBox(
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle));
          },
        ),
      ),
    );
  }
}
