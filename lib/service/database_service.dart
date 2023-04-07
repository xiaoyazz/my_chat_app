import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // Reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  // Update the user data
  // Future updateUserData(String fullName, String email) async {
  //   return await userCollection.doc(uid).set({
  //     "fullName": fullName,
  //     "email": email,
  //     "groups": [],
  //     "profilePic": "",
  //     "uid": uid,
  //   });
  // }

  // We can also use Save user data
  Future saveUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  // Get user data
  Future getUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // Get user groups
  getUserGroup() async {
    return userCollection.doc(uid).snapshots();
  }

  // Create a group
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "", // we don't have it yet
      "recentMessageSender": "",
    });
    // After the group created, we create a document reference
    // and update the member
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId":
          groupDocumentReference.id, // generated after the group is created
    });

    DocumentReference userDocumentReference = await userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  // Get the chat
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  // Get group admin
  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // Get group members
  getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  // Search
  searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  // Return a bool to check if the user joined a group
  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_${groupName}")) {
      return true;
    } else {
      return false;
    }
  }

  // Toggle the group join/exit button
  Future toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    // Doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // If user joined this group, remove the user and update both users and groups collections
    if (groups.contains("${groupId}_${groupName}")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_${groupName}"])
      });

      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_${userName}"])
      });
    }
    // If not, allow to join the group and update both users and groups collections
    else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_${groupName}"])
      });

      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_${userName}"])
      });
    }
  }

  // Send message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }
}
