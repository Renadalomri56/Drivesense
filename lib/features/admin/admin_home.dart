import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/models/user_profile.dart';
import '../../app/providers/current_profile_provider.dart';
import '../../app/services/firebase_realtime_db.dart';

class AdminHome extends ConsumerStatefulWidget {
  const AdminHome({super.key});
  @override
  AdminHomeState createState() => AdminHomeState();
}

class AdminHomeState extends ConsumerState<AdminHome> {
  FirebaseDatabaseHelper dbHelper = FirebaseDatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    final profile = ref.read(currentUserProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Drive Sense'),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/settings');
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     context.push('/add-new-account');
      //   },
      //   backgroundColor: Color(0xff450a85),
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff450a85).withOpacity(0.8), Color(0xffba3edd)],
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
                    child: Image.asset('assets/icons/admin.png'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              'accounts'.tr(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<UserProfile>>(
              future: dbHelper.getProfiles(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, size: 40),
                        Text(snapshot.error.toString()),
                      ],
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final contacts = snapshot.data!;

                if (contacts.isEmpty) {
                  return Center(child: Text("no_profiles".tr()));
                }
                return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final p = contacts[index];
                    return ListTile(
                      onTap: () {
                        context.push(
                          '/view-profile',
                          extra: {"profile": p, "myProfile": profile},
                        );
                      },
                      leading: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: CircleAvatar(
                          child: Text(
                            p.name[0].toUpperCase(),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                      title: Text(p.name, style: const TextStyle(fontSize: 14)),
                      subtitle: Text(
                        p.userId,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
