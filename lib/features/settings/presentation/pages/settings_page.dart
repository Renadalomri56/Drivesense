import 'package:drivesense/app/widgets/show_confirm_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../app/services/firebase_realtime_db.dart';
import '../../../../app/theme/theme_provider.dart';
import '../../../../services/auth_controller.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends ConsumerState<SettingsPage> {
  final FirebaseDatabaseHelper _databaseHelper =
      FirebaseDatabaseHelper.instance;

  final double spacing = 8;
  bool soundAlert = false;
  bool vibration = false;
  bool contactsAlert = false;
  bool mobileAlerts = false;

  @override
  void initState() {
    super.initState();
    readSettings();
  }

  void readSettings() async {
    final settings = await _databaseHelper.read("settings");
    soundAlert = settings['buzzer'];
    vibration = settings['vibration'];
    contactsAlert = settings['contacts'];
    mobileAlerts = settings['alerts'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ThemeMode themeMode = ref.watch(themeModeProvider);
    final authController = ref.read(authControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text('settings.title'.tr())),
      body: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'settings.language'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: spacing),
          SegmentedButton<Locale>(
            segments: <ButtonSegment<Locale>>[
              ButtonSegment<Locale>(
                value: Locale('en'),
                label: Text('language.en'.tr()),
              ),
              ButtonSegment<Locale>(
                value: Locale('ar'),
                label: Text('language.ar'.tr()),
              ),
            ],
            selected: <Locale>{context.locale},
            onSelectionChanged: (selection) async {
              final Locale newLocale = selection.first;
              await context.setLocale(newLocale);
            },
          ),
          SizedBox(height: spacing),
          Text(
            'settings.theme'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: spacing),
          SegmentedButton<ThemeMode>(
            segments: <ButtonSegment<ThemeMode>>[
              ButtonSegment<ThemeMode>(
                value: ThemeMode.system,
                label: Text('system'.tr()),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.light,
                label: Text('light'.tr()),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.dark,
                label: Text('dark'.tr()),
              ),
            ],
            selected: <ThemeMode>{themeMode},
            onSelectionChanged: (selection) {
              ref
                  .read(themeModeProvider.notifier)
                  .setThemeMode(selection.first);
            },
          ),
          SizedBox(height: spacing),
          Text(
            'sound_alert'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: spacing),
          SegmentedButton<bool>(
            segments: <ButtonSegment<bool>>[
              ButtonSegment<bool>(value: true, label: Text('on'.tr())),
              ButtonSegment<bool>(value: false, label: Text('off'.tr())),
            ],
            selected: <bool>{soundAlert},
            onSelectionChanged: (selection) async {
              setState(() {
                soundAlert = selection.first;
                _databaseHelper.update("settings", {"buzzer": soundAlert});
              });
            },
          ),
          SizedBox(height: spacing),
          Text(
            'vibration'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: spacing),
          SegmentedButton<bool>(
            segments: <ButtonSegment<bool>>[
              ButtonSegment<bool>(value: true, label: Text('on'.tr())),
              ButtonSegment<bool>(value: false, label: Text('off'.tr())),
            ],
            selected: <bool>{vibration},
            onSelectionChanged: (selection) async {
              setState(() {
                vibration = selection.first;
                _databaseHelper.update("settings", {"vibration": vibration});
              });
            },
          ),
          SizedBox(height: spacing),
          Text(
            'contacts_alerts'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: spacing),
          SegmentedButton<bool>(
            segments: <ButtonSegment<bool>>[
              ButtonSegment<bool>(value: true, label: Text('on'.tr())),
              ButtonSegment<bool>(value: false, label: Text('off'.tr())),
            ],
            selected: <bool>{contactsAlert},
            onSelectionChanged: (selection) async {
              setState(() {
                contactsAlert = selection.first;
                _databaseHelper.update("settings", {"contacts": contactsAlert});
              });
            },
          ),
          SizedBox(height: spacing),
          Text(
            'mobile_alerts'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: spacing),
          SegmentedButton<bool>(
            segments: <ButtonSegment<bool>>[
              ButtonSegment<bool>(value: true, label: Text('on'.tr())),
              ButtonSegment<bool>(value: false, label: Text('off'.tr())),
            ],
            selected: <bool>{mobileAlerts},
            onSelectionChanged: (selection) async {
              setState(() {
                mobileAlerts = selection.first;
                _databaseHelper.update("settings", {"alerts": mobileAlerts});
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              bool isConfirmed = await showConfirmationDialog(
                'settings.logout_confirmation'.tr(),
                'are_you_sure'.tr(),
                context,
              );
              if (!isConfirmed) {
                return;
              }
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('rememberMe', false);
              context.go('/login');
              authController.signOut();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('settings.logout'.tr()),
          ),
        ],
      ),
    );
  }
}
