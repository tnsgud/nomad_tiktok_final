import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostViewModel extends StateNotifier<List<Post>> {
  PostViewModel(super.state);

  final storeInstance = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  getData() async {
    var email = user.email!;
    var collection = await storeInstance
        .collection(email)
        .orderBy('createTime', descending: false)
        .get();
    var docs = collection.docs;

    state = docs.map((e) {
      var data = e.data();

      data['id'] = e.id;

      return Post.formJSON(data);
    }).toList();
  }

  add(Post post) async {
    var email = user.email!;
    var collection = storeInstance.collection(email);
    var map = post.toMap();

    await collection.add(map);

    state = [...state, post];
  }

  remove(Post post) async {
    var email = user.email!;
    var collection = storeInstance.collection(email);

    collection.doc(post.id).delete();
    state.remove(post);

    state = [...state];
  }
}
