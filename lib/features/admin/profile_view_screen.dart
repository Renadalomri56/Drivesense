import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timelines_plus/timelines_plus.dart';
import '../../app/models/user_profile.dart';
import '../../app/services/firebase_realtime_db.dart';
import '../../app/theme/theme_provider.dart';
import '../reports_driver/session_provider.dart';
import '../reports_driver/trip_session_model.dart';

class ProfileViewScreen extends ConsumerStatefulWidget {
  final UserProfile profile;
  final UserProfile myProfile;

  const ProfileViewScreen({
    super.key,
    required this.profile,
    required this.myProfile,
  });

  @override
  ConsumerState createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends ConsumerState<ProfileViewScreen> {
  FirebaseDatabaseHelper dbHelper = FirebaseDatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr()),
        actions: [
          IconButton(
            onPressed: () {
              if (widget.profile.userId == widget.myProfile.userId) {
                // you can not remove your own profile
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('you_can_not_remove_your_own_profile'.tr()),
                  ),
                );
                return;
              }
              dbHelper.deleteProfile(widget.profile);
              context.pop(context);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: CircleAvatar(
                radius: 80,
                child: Text(
                  widget.profile.name[0].toUpperCase(),
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              widget.profile.name.toUpperCase(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: Text(
              widget.profile.userId.toUpperCase(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          Expanded(child: ReportsScreen(profile: widget.profile)),
        ],
      ),
    );
  }
}

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key, required this.profile});

  final UserProfile profile;

  @override
  ReportsScreenState createState() => ReportsScreenState();
}

class ReportsScreenState extends ConsumerState<ReportsScreen> {
  late DatabaseReference db;

  @override
  void initState() {
    super.initState();
    db = FirebaseDatabase.instance.ref(
      'profiles/${widget.profile.userId}/sessions',
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final sessionState = ref.watch(reportingSessionProvider);

    return FutureBuilder(
      future: TripSessionModel.fetchAll(db),
      builder: (context, asyncSnapshot) {
        final List<TripSessionModel> data = asyncSnapshot.data ?? [];
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (asyncSnapshot.hasError) {
          return Center(child: Text('Error: ${asyncSnapshot.error}'));
        }
        if (data.isEmpty) {
          return Center(child: Text('no_data_found'.tr()));
        }

        return Timeline.tileBuilder(
          shrinkWrap: true,
          theme: TimelineThemeData(
            indicatorTheme: IndicatorThemeData(size: 16),
            connectorTheme: ConnectorThemeData(indent: 10),
          ),
          builder: TimelineTileBuilder.fromStyle(
            contentsAlign: ContentsAlign.basic,
            connectorStyle: ConnectorStyle.solidLine,
            indicatorStyle: IndicatorStyle.dot,
            endConnectorStyle: ConnectorStyle.transparent,
            nodePositionBuilder: (context, index) => 0.3,
            itemExtent: 120,
            oppositeContentsBuilder: (context, index) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  DateFormat(
                    'EEEE, dd-MM-yyyy',
                    context.locale.languageCode,
                  ).format(data[index].date),
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () {
                    TripSessionModel.delete(db, data[index]);
                    setState(() {});
                  },
                  child: Text(
                    'delete'.tr(),
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            contentsBuilder: (context, index) => Card(
              color: themeMode == ThemeMode.light
                  ? Color(0xff8294d5)
                  : Color(0xff223c73),
              child: ListTile(
                title: Text(
                  'trip_session'.tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${'started_at'.tr()} ${DateFormat('hh:mm:ss').format(data[index].startTime)}',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      '${'ended_at'.tr()} ${DateFormat('hh:mm:ss').format(data[index].endTime)}',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      '${'duration'.tr()}   ${timeDiff(data[index].startTime, data[index].endTime)}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                trailing: CircleAvatar(
                  backgroundColor: themeMode == ThemeMode.light
                      ? Color(0xffcdb2ea)
                      : Color(0xff450a85),
                  radius: 25,
                  child: Text(
                    data[index].mistakesCount.toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            itemCount: data.length,
          ),
        );
      },
    );
  }

  String timeDiff(DateTime start, DateTime end) {
    Duration diff = end.difference(start);
    int hours = diff.inHours;
    int minutes = diff.inMinutes % 60;
    int seconds = diff.inSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
