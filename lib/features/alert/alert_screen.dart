import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../app/services/firebase_realtime_db.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  FirebaseDatabaseHelper dbHelper = FirebaseDatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('alert'.tr()), centerTitle: true),
      body: Column(
        children: [
          Lottie.asset('assets/lottie/Sleeping.json'),
          Text(
            'drowsiness_detected'.tr(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'stop_driving_and_take_a_break'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              context.pop();
              dbHelper.setAlertOff();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff450a85),
              foregroundColor: Color(0xffccafea),
            ),
            child: Text('${'i_am_good_now'.tr()} 👍'),
          ),
        ],
      ),
    );
  }
}
