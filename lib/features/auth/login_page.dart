// import 'package:drivesense/features/auth/profile_model.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../app/services/firebase_realtime_db.dart';
//
// class LoginPage extends ConsumerStatefulWidget {
//   const LoginPage({super.key});
//   @override
//   ConsumerState<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends ConsumerState<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _idController = TextEditingController();
//   bool isAdmin = false;
//   bool rememberMe = false;
//   FirebaseDatabaseHelper databaseHelper = FirebaseDatabaseHelper.instance;
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     init();
//   }
//
//   void init() async {
//     await readData();
//     if (rememberMe) {
//       _login();
//     }
//   }
//
//   Future<void> readData() async {
//     final prefs = await SharedPreferences.getInstance();
//     _idController.text = prefs.getString('id') ?? '';
//     isAdmin = prefs.getBool('isAdmin') ?? false;
//     rememberMe = prefs.getBool('rememberMe') ?? false;
//     setState(() {});
//   }
//
//   Future<void> saveData() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('id', _idController.text);
//     await prefs.setBool('isAdmin', isAdmin);
//     await prefs.setBool('rememberMe', rememberMe);
//   }
//
//   @override
//   void dispose() {
//     _idController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _login() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         isLoading = true;
//       });
//
//       List<Profile> profiles = await databaseHelper.getProfiles();
//       Profile profile = profiles.firstWhere(
//         (element) => element.id == _idController.text,
//         orElse: () => Profile('', ''),
//       );
//
//       if (profile.id == _idController.text) {
//         saveData();
//         if (mounted) {
//           if (profile.isAdmin && isAdmin) {
//             context.go('/admin', extra: profile);
//             return;
//           }
//           if (!profile.isAdmin && !isAdmin) {
//             context.go('/home', extra: profile);
//             return;
//           }
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text('you_can_not_choose_wrong_profile_role'.tr())));
//         }
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('auth.invalid_id'.tr())));
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('auth.login'.tr()),
//           automaticallyImplyLeading: false,
//         ),
//         body: SingleChildScrollView(
//           padding: EdgeInsets.only(
//             left: 16,
//             right: 16,
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Lottie.asset('assets/lottie/login.json'),
//                 Text(
//                   'auth.welcome'.tr(),
//                   style: Theme.of(context).textTheme.headlineMedium,
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: _login,
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                   ),
//                   child: Text('auth.login'.tr()),
//                 ),
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Checkbox(
//                       value: rememberMe,
//                       onChanged: (newValue) {
//                         setState(() {
//                           rememberMe = newValue!;
//                         });
//                       },
//                       activeColor: Theme.of(context).primaryColor,
//                     ),
//                     const SizedBox(width: 6),
//                      Text(
//                       "remember_me".tr(),
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SegmentedButton<bool>(
//                   segments:  [
//                     ButtonSegment<bool>(value: true, label: Text('admin'.tr())),
//                     ButtonSegment<bool>(value: false, label: Text('driver'.tr())),
//                   ],
//                   selected: {isAdmin},
//                   onSelectionChanged: (selection) {
//                     setState(() {
//                       isAdmin = selection.first;
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 32),
//                 TextFormField(
//                   controller: _idController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration:  InputDecoration(
//                     labelText: 'id'.tr(),
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'auth.email_required'.tr();
//                     }
//                     return null;
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
