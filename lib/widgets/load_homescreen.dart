import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/* splash screen 
 *
 * 메인 화면 로딩 스크린.
*/
class LoadHomeScreen extends StatelessWidget {
  const LoadHomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade300,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/cau.png",
            color: Colors.black.withOpacity(0.8),
          ),
          const SizedBox(
            height: 50,
          ),
          const Text("로딩중입니다..."),
          const SpinKitThreeBounce(
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
