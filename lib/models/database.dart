import 'package:adventist_meet/chat_screens/sign_in_screen.dart';
import 'package:adventist_meet/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:adventist_meet/chat_screens/message_screen.dart';

class FirestoreProvider extends ChangeNotifier {
  UserModel? _userDetail;

  streamUser() async {
    DocumentSnapshot userId = await usersRef.doc(googleAccount?.id).get();

    _userDetail = UserModel.fromFireStore(userId);
    //Call this whenever there is some change in any field of change notifier.
    notifyListeners();
  }

  UserModel? get userDocument => _userDetail;
}

class FirestoreStreamProvider {
  Stream<List<UserModel>> getStream() {
    return usersRef.snapshots().map((anyNameILike) => anyNameILike.docs
        .map((userId) => UserModel.fromFireStore(userId))
        .toList());
  }
}

// class DatabaseWork {
//   //Add message to database
//   Future addMessage(String chatRoomId, String messageId, Map messageInfoMap) {
//     return FirebaseFirestore.instance
//         .collection('chatrooms')
//         .doc(chatRoomId)
//         .collection('chats')
//         .doc(messageId)
//         .set(messageInfoMap);
//   }

// //To update the last message sent
//   updateLastMessageSent(String chatRoomId, lastMessageInfoMap) {
//     return FirebaseFirestore.instance
//         .collection('chatrooms')
//         .doc(chatRoomId)
//         .update(lastMessageInfoMap);
//   }

//   createNonExistentChatRoom(String chatRoomId, chatRoomInfoMap) async {
//     final snapShot = await FirebaseFirestore.instance
//         .collection('chatrooms')
//         .doc(chatRoomId)
//         .get();

//     //To check if chatRoom already exist
//     if (snapShot.exists) {
//       //Chat room alrady exist
//       return true;
//     } else {
//       //Chatroom doesnt exist
//       return FirebaseFirestore.instance
//           .collection('chatrooms')
//           .doc(chatRoomId)
//           .set(chatRoomInfoMap);
//     }
//   }
// }
