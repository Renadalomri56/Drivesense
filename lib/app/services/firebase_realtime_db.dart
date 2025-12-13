import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import '../../features/contacts/contact_model.dart';
import '../models/user_profile.dart';

class FirebaseDatabaseHelper {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  FirebaseDatabaseHelper._privateConstructor();

  static final FirebaseDatabaseHelper instance =
      FirebaseDatabaseHelper._privateConstructor();

  /// Write a value to a path
  Future<void> write(String path, dynamic value) async {
    await _database.ref(path).set(value);
  }

  /// Update values at a path (value must be a Map)
  Future<void> update(String path, Map<String, dynamic> value) async {
    await _database.ref(path).update(value);
  }

  Future<dynamic> read(String path) async {
    final snapshot = await _database.ref(path).get();
    return snapshot.value;
  }

  Future<List<UserProfile>> getProfiles() async {
    final profilesRef = _database.ref('profiles');
    final snapshot = await profilesRef.get();

    if (!snapshot.exists) return [];

    final data = snapshot.value as Map<dynamic, dynamic>;
    List<UserProfile> profiles = [];

    data.forEach((key, value) {
      profiles.add(UserProfile.fromJson(Map<String, dynamic>.from(value)));
    });

    return profiles;
  }

  void setAlertOff() async {
    await _database.ref('live/detected').set(false);
  }

  Future<void> addProfile(UserProfile profile) async {
    final newRef = _database.ref('profiles').child(profile.userId);
    await newRef.set(profile.toJson());
  }

  Future<void> updateProfile(UserProfile profile) async {
    await _database.ref('profiles').child(profile.userId).update(profile.toJson());
  }

  Future<void> deleteProfile(UserProfile profile) async {
    await _database.ref('profiles').child(profile.userId).remove();
  }

  /// Listen to changes at a path
  StreamSubscription<DatabaseEvent> listen(
    String path,
    void Function(dynamic data) onChange,
  ) {
    final ref = _database.ref(path);
    return ref.onValue.listen((event) {
      if (event.snapshot.value != null) {
        onChange(event.snapshot.value);
      }
    });
  }

  Future<List<Contact>> getContacts() async {
    final contactsRef = _database.ref('contacts');
    final snapshot = await contactsRef.get();

    if (!snapshot.exists) return [];

    final data = snapshot.value as Map<dynamic, dynamic>;
    List<Contact> contacts = [];

    data.forEach((key, value) {
      contacts.add(Contact.fromMap(key, Map<String, dynamic>.from(value)));
    });

    return contacts;
  }

  Future<void> addContact(String name, String number) async {
    final newRef = _database.ref('contacts').push();
    await newRef.set({
      "name": name,
      "number": number,
      "chatId": "",
      "active": false,
    });
  }

  Future<void> activateContact(Contact contact) async {
    final response = await http.get(
      Uri.parse(
        "https://api.telegram.org/bot8268822841:AAFIb7dUXPMNk3soX9d0TmtVxMzk6S-2RH4/getUpdates",
      ),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List results = body['result'] ?? [];

      if (results.isEmpty) {
        print("No messages found.");
        return;
      }

      final latest = results.last;

      final chatId = latest['message']['chat']['id'];
      final userName = latest['message']['chat']['username'];

      await _database.ref('contacts').child(contact.id).update({
        "chatId": chatId.toString(),
        "active": true,
        "userName": userName,
      });
    } else {
      print("Error: ${response.statusCode} ${response.body}");
    }
  }

  Future<void> deleteContact(Contact contact) async {
    await _database.ref('contacts').child(contact.id).remove();
  }

  void cancelListener(StreamSubscription<DatabaseEvent> subscription) {
    subscription.cancel();
  }
}
