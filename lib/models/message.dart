class Message {
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime sentTime;
  final MessageType messageType;

  const Message({
    required this.senderId,
    required this.receiverId,
    required this.sentTime,
    required this.content,
    required this.messageType,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      Message(
        receiverId: json['receiverId'],
        senderId: json['senderId'],
        sentTime: json['sentTime'].toDate(),
        content: json['content'],
        messageType:
            MessageType.fromJson(json['messageType']),
      );

  Map<String, dynamic> toJson() => {
        'receiverId': receiverId,
        'senderId': senderId,
        'sentTime': sentTime,
        'content': content,
        'messageType': messageType.toJson(),
      };
}

class Updatefield {
  final String email;
  final String id;
  final String image;
  final DateTime lastActive;
  final String name;
  final String phoneNumber;
  final bool isOnline;

  const Updatefield({
    required this.email,
    required this.id,
    required this.image,
    required this.lastActive,
    required this.name,
    required this.phoneNumber,
    this.isOnline = false,
  });

  factory Updatefield.fromJson(Map<String, dynamic> json) =>
      Updatefield(
        email: json['email'].toString(),
        id: json['id'].toString(),
        image: json['image'].toString(),
        lastActive: json['lastActive'].toDate(), // Parse date string
        name: json['name'].toString(),
        phoneNumber: json['phoneNumber'].toString(),
        isOnline: json['isOnline'] ?? false,
      );

  Map<String, dynamic> toJson()  => {
      'email': email,
      'id': id,
      'image': image,
      'lastActive': lastActive, // Convert DateTime to ISO8601 string
      'name': name,
      'phoneNumber': phoneNumber,
      'isOnline': isOnline,
    };
}

enum MessageType {
  text,
  image;

  String toJson() => name;

  factory MessageType.fromJson(String json) =>
      values.byName(json);
}
