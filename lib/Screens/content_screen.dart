import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  final content = Get.arguments[0];
  final title = Get.arguments[1];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          width: MediaQuery.of(context).size.width,
          height: 30,
          child: Marquee(
            text: title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 20.0,
            velocity: 100.0,
            pauseAfterRound: const Duration(seconds: 1),
            startPadding: 10.0,
            accelerationDuration: const Duration(seconds: 1),
            accelerationCurve: Curves.linear,
            decelerationDuration: const Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          ),
        ),
        actions: [
          SizedBox(
            width: 50,
          )
        ],
      ),
      body: Scrollbar(
        child: ListView.builder(
          itemBuilder: (ctx, index) => Container(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color.fromRGBO(255, 255, 255, 0.1),
              ),
              padding: const EdgeInsets.all(6),
              margin: const EdgeInsets.all(6),
              child: Text(
                "${content[index]}\n",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          itemCount: content.length,
        ),
      ),
    );
  }
}
