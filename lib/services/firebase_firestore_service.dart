import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:we_map/constants/firebase_constants.dart';
import 'package:we_map/models/post_model.dart';
import 'package:we_map/models/image_model.dart';
import 'package:we_map/models/topic_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:we_map/utils/extensions.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseFirestoreService {
  final FirebaseAuth authInstance = FirebaseAuth.instance;
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  final FirebaseStorage storageInstance = FirebaseStorage.instance;
  final Geoflutterfire geo = Geoflutterfire();

  Future<void> setTopic({required TopicModel topicModel}) async {
    await firestoreInstance
      .collection(FirebaseConstants.topicsCollection)
      .doc(topicModel.geoPoint.hash)
      .set(TopicModel.toJson(model: topicModel));
  }

  Future<void> deleteTopic({required TopicModel topic}) async {
    await firestoreInstance
      .collection(FirebaseConstants.topicsCollection)
      .doc(topic.topicId)
      .collection(FirebaseConstants.postsCollection)
      .get()
      .then((postsDocs) {
        Future.forEach(postsDocs.docs, (QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
          await deletePost(post: PostModel.fromJson(doc.data()));
        });
      });

    await firestoreInstance
      .collection(FirebaseConstants.topicsCollection)
      .doc(topic.topicId)
      .delete();
  }

  Future<void> setPost({required PostModel post, required List<XFile> images}) async {
    await firestoreInstance
      .collection(FirebaseConstants.topicsCollection)
      .doc(post.parentTopicId)
      .collection(FirebaseConstants.postsCollection)
      .doc(post.postId)
      .set(PostModel.toJson(post));

    if (images.isNotEmpty) {
      for (XFile file in images) {
        uploadImage(parentPost: post, image: file);
      }
    }
  }

  Future<void> deletePost({required PostModel post}) async {
    await firestoreInstance
      .collection(FirebaseConstants.topicsCollection)
      .doc(post.parentTopicId)
      .collection(FirebaseConstants.postsCollection)
      .doc(post.postId)
      .collection(FirebaseConstants.imagesCollection)
      .get()
      .then((imagesDocs) {
        Future.forEach(imagesDocs.docs, (QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
          await deleteImageWithRef(image: ImageModel.fromJson(doc.data()));
        });
      });

    await firestoreInstance
      .collection(FirebaseConstants.topicsCollection)
      .doc(post.parentTopicId)
      .collection(FirebaseConstants.postsCollection)
      .doc(post.postId)
      .delete();
  }

  Future<void> updateTopic({required TopicModel oldTopic, required TopicModel newTopic}) async {
    if (newTopic != oldTopic) {
      await setTopic(topicModel: newTopic);
    }
  }

  Future<void> setImage({required ImageModel imageModel}) async {
    await firestoreInstance
      .collection(FirebaseConstants.topicsCollection)
      .doc(imageModel.parentTopicId)
      .collection(FirebaseConstants.postsCollection)
      .doc(imageModel.parentPostId)
      .collection(FirebaseConstants.imagesCollection)
      .add(ImageModel.toJson(imageModel));
  }

  Future<void> uploadImage({required PostModel parentPost, required XFile image}) async {
    final ImageModel imageModel = ImageModel(
        uid: authInstance.currentUser!.uid,
        parentTopicId: parentPost.parentTopicId,
        parentPostId: parentPost.postId,
        path: "${FirebaseConstants.topicsCollection}/${parentPost.uid}/${parentPost.parentTopicId}/${FirebaseConstants.postsCollection}/${parentPost.postId}/${FirebaseConstants.imagesCollection}/${image.name}"
    );
    final Reference ref = storageInstance.ref(imageModel.path);
    await ref.putData(await image.readAsBytes(), SettableMetadata(contentType: "image/jpeg"));
    await setImage(imageModel: imageModel);
  }

  Future<void> deleteImageFromStorage({required String path}) async {
    await storageInstance
      .ref(path)
      .delete();
  }

  Future<void> deleteImageWithRef({required ImageModel image}) async {
    await storageInstance
        .ref(image.path)
        .delete();

    await firestoreInstance
      .collection(FirebaseConstants.topicsCollection)
      .doc(image.parentTopicId)
      .collection(FirebaseConstants.postsCollection)
      .doc(image.parentPostId)
      .collection(FirebaseConstants.imagesCollection)
      .where(FirebaseConstants.path, isEqualTo: image.path)
      .get()
      .then((imagesDocs) {
        Future.forEach(imagesDocs.docs, (QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
          await doc.reference.delete();
        });
      });
  }

  Future<String> downloadURL(String imagePath) async {
    String downloadURL = await storageInstance.ref(imagePath).getDownloadURL();
    return downloadURL;
  }

  Stream<List<TopicModel>> getTopicsStream() {
    return firestoreInstance
      .collection(FirebaseConstants.topicsCollection)
      .snapshots()
      .map((event) {
        return event.docs.map((doc) {
          return TopicModel.fromJson(doc.data());
        }).toList();
      });
  }

  //GeoFlutterFire uses radius as Km, Google Maps' radius is in meters
  Stream<List<TopicModel>> getTopicsStreamRadius({required GeoFirePoint center, required double radius}) {
    print('RADIUS = $radius');
    final ref = firestoreInstance.collection(FirebaseConstants.topicsCollection);
    return geo
      .collection(collectionRef: ref)
      .within(center: center, radius: radius / 1000, field: FirebaseConstants.position, strictMode: true)
      .map((event) {
        return event.map((doc) {
          return TopicModel.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
    });
  }

  double getDistance({required LatLng northeast, required LatLng southwest}) {
    return GeoFirePoint.distanceBetween(to: southwest.coordinatesFromLatLng(), from: northeast.coordinatesFromLatLng())*1000;
  }

  Stream<List<PostModel>> getPostsStream({required TopicModel topic}) {
    return firestoreInstance
      .collection(FirebaseConstants.topicsCollection)
      .doc(topic.topicId)
      .collection(FirebaseConstants.postsCollection)
      .orderBy(FirebaseConstants.date)
      .snapshots()
      .map((event) {
        return event.docs.map((doc) {
          return PostModel.fromJson(doc.data());
        }).toList();
      });
  }

  Stream<List<ImageModel>> getImagesStream({required PostModel post}) {
    return firestoreInstance
      .collection(FirebaseConstants.topicsCollection)
      .doc(post.parentTopicId)
      .collection(FirebaseConstants.postsCollection)
      .doc(post.postId)
      .collection(FirebaseConstants.imagesCollection)
      .snapshots()
      .map((event) {
        return event.docs.map((doc) {
          return ImageModel.fromJson(doc.data());
        }).toList();
      });
  }
}