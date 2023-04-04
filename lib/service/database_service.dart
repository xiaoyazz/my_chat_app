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
      "groupId": "", // we don't have it yet
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
}
