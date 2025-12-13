class Contact {
  String id;
  String name;
  String number;
  String chatId;
  String userName;
  bool active;

  Contact({
    required this.id,
    required this.name,
    required this.number,
    required this.chatId,
    required this.userName,
    required this.active,
  });

  factory Contact.fromMap(String id, Map<dynamic, dynamic> data) {
    return Contact(
      id: id,
      name: data['name'] ?? '',
      number: data['number'] ?? '',
      chatId: data['chatId'] ?? '',
      userName: data['userName'] ?? '',
      active: data['active'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "number": number,
      "chatId": chatId,
      "userName": userName,
      "active": active,
    };
  }
}