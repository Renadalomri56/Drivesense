//
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../../app/models/user_profile.dart';
// import '../../app/services/firebase_realtime_db.dart';
//
// class AddNewAccountScreen extends ConsumerStatefulWidget {
//   const AddNewAccountScreen({super.key});
//   @override
//   ConsumerState createState() => _AddNewAccountScreenState();
// }
//
// class _AddNewAccountScreenState extends ConsumerState<AddNewAccountScreen> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController idController = TextEditingController();
//   bool isAdmin = false;
//   FirebaseDatabaseHelper dbHelper = FirebaseDatabaseHelper.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         appBar: AppBar(title: Text('create_new_account'.tr())),
//         bottomNavigationBar: BottomAppBar(
//           child: ElevatedButton(
//             onPressed: () async {
//               if (_formKey.currentState!.validate()) {
//                 await dbHelper.addProfile(
//                   UserProfile(
//                     nameController.text,
//                     idController.text,
//                     isAdmin: isAdmin,
//                   ),
//                 );
//                 context.pop();
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               backgroundColor: Colors.green,
//               foregroundColor: Colors.white,
//             ),
//             child: Text('create_now'.tr()),
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 spacing: 20,
//                 children: [
//                   TextFormField(
//                     controller: nameController,
//                     decoration:  InputDecoration(
//                       labelText: 'name'.tr(),
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.person),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'please_enter_your_name'.tr();
//                       }
//                       return null;
//                     },
//                   ),
//                   TextFormField(
//                     controller: idController,
//                     decoration: InputDecoration(
//                       labelText: 'id'.tr(),
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.numbers),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'please_enter_your_id'.tr();
//                       }
//                       return null;
//                     },
//                   ),
//                   SegmentedButton<bool>(
//                     segments:  [
//                       ButtonSegment<bool>(value: true, label: Text('admin'.tr())),
//                       ButtonSegment<bool>(value: false, label: Text('driver'.tr())),
//                     ],
//                     selected: {isAdmin},
//                     onSelectionChanged: (selection) {
//                       setState(() {
//                         isAdmin = selection.first;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
