
import 'package:drivesense/features/drive/providers/online_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers/current_profile_provider.dart';
import '../reports_driver/session_provider.dart';
import 'camera_stream_widget.dart';

class DriveScreen extends ConsumerStatefulWidget {
  const DriveScreen( {super.key});

  @override
  DriveScreenState createState() => DriveScreenState();
}

class DriveScreenState extends ConsumerState<DriveScreen> {
  bool isDriving = false;
  late DatabaseReference db;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(currentUserProfileProvider);
    db = FirebaseDatabase.instance.ref(
      'profiles/${profile?.userId}/sessions',
    );
  }

  @override
  Widget build(BuildContext context) {
    final online = ref.watch(onlineStatusProvider);
    final reporter = ref.read(reportingSessionProvider.notifier);
    final profile = ref.read(currentUserProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Drive Sense'), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff061a5a).withOpacity(0.8), Color(0xff177dbc)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.black38,
                  child: Text(
                    profile?.name[0].toUpperCase() ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${'welcome'.tr()} 👋',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        profile?.name ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  width: 80,
                  height: 60,
                  child: Transform.scale(
                    scale: 1.5,
                    child: Image.asset('assets/icons/lic.png'),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Builder(
                  builder: (context) {
                    if (isDriving) {
                      return PiCameraStream();
                    }
                    return CircleAvatar(
                      radius: 100,
                      backgroundImage: AssetImage('assets/images/logo.png'),
                    );
                  },
                ),
                SizedBox(height: 50),
                Builder(
                  builder: (context) {
                    if (online) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.circle, color: Colors.green),
                          SizedBox(width: 10),
                          Text(
                            'ready'.tr(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.circle, color: Colors.red),
                        SizedBox(width: 10),
                        Text(
                          'offline'.tr(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 50),
                Builder(
                  builder: (context) {
                    if (isDriving) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('detecting'.tr()),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  reporter.endSession(db);
                                  setState(() {
                                    isDriving = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigoAccent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                child: Text('finish'.tr()),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('click_start_to_begin_with_driving'.tr()),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  reporter.startSession();
                                  setState(() {
                                    isDriving = true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                child: Text('start'.tr()),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
