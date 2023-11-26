import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethod {
  getUserByUseremail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap, String? id) {
    FirebaseFirestore.instance.collection("users").doc(id).set(userMap);
  }

  updateActiveStatus(String? id, String token) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({'pushToken': token});
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  Future<void> addConversationMessages(String chatRoomId, messageMap) async {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  getUserChats(String itIsMyName) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }
}
