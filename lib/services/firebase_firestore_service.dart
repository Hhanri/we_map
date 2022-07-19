import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:we_map/constants/firebase_constants.dart';
import 'package:we_map/models/archive_model.dart';
import 'package:we_map/models/image_model.dart';
import 'package:we_map/models/log_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:we_map/utils/extensions.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseFirestoreService {
  final FirebaseAuth authInstance = FirebaseAuth.instance;
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  final FirebaseStorage storageInstance = FirebaseStorage.instance;
  final Geoflutterfire geo = Geoflutterfire();

  Future<void> setLog({required LogModel logModel}) async {
    await firestoreInstance
      .collection(FirebaseConstants.logsCollection)
      .doc(logModel.geoPoint.hash)
      .set(LogModel.toJson(model: logModel));
  }

  Future<void> deleteLog({required LogModel log}) async {
    //delete log
    await firestoreInstance
      .collection(FirebaseConstants.logsCollection)
      .doc(log.logId)
      .collection(FirebaseConstants.archivesCollection)
      .get()
      .then((archivesDocs) {
        Future.forEach(archivesDocs.docs, (QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
          await deleteArchive(archive: ArchiveModel.fromJson(doc.data()));
        });
      });

    await firestoreInstance
      .collection(FirebaseConstants.logsCollection)
      .doc(log.logId)
      .delete();
  }

  Future<void> setArchive(ArchiveModel archive) async {
    await firestoreInstance
      .collection(FirebaseConstants.logsCollection)
      .doc(archive.parentLogId)
      .collection(FirebaseConstants.archivesCollection)
      .doc(archive.archiveId)
      .set(ArchiveModel.toJson(archive));
  }

  Future<void> deleteArchive({required ArchiveModel archive}) async {
    await firestoreInstance
      .collection(FirebaseConstants.logsCollection)
      .doc(archive.parentLogId)
      .collection(FirebaseConstants.archivesCollection)
      .doc(archive.archiveId)
      .collection(FirebaseConstants.imagesCollection)
      .get()
      .then((imagesDocs) {
        Future.forEach(imagesDocs.docs, (QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
          await deleteImageWithRef(image: ImageModel.fromJson(doc.data()));
        });
      });

    await firestoreInstance
      .collection(FirebaseConstants.logsCollection)
      .doc(archive.parentLogId)
      .collection(FirebaseConstants.archivesCollection)
      .doc(archive.archiveId)
      .delete();
  }

  Future<void> updateArchiveWithoutImages({required ArchiveModel newArchive}) async {
    await firestoreInstance
      .collection(FirebaseConstants.logsCollection)
      .doc(newArchive.parentLogId)
      .collection(FirebaseConstants.archivesCollection)
      .doc(newArchive.archiveId)
      .update(ArchiveModel.toJsonWithoutImages(newArchive));
  }

  Future<void> updateLog({required LogModel oldLog, required LogModel newLog}) async {
    if (newLog != oldLog) {
      print("LOGS DIFFERENT");
      await setLog(logModel: newLog);
    }
  }

  Future<void> setImage({required ImageModel imageModel}) async {
    await firestoreInstance
      .collection(FirebaseConstants.logsCollection)
      .doc(imageModel.parentLogId)
      .collection(FirebaseConstants.archivesCollection)
      .doc(imageModel.parentArchiveId)
      .collection(FirebaseConstants.imagesCollection)
      .add(ImageModel.toJson(imageModel));
  }

  Future<void> uploadImage({required ArchiveModel parentArchive, required XFile image}) async {
    final ImageModel imageModel = ImageModel(
        uid: authInstance.currentUser!.uid,
        parentLogId: parentArchive.parentLogId,
        parentArchiveId: parentArchive.archiveId,
        path: "logs/${parentArchive.parentLogUid}/${parentArchive.parentLogId}/archives/${parentArchive.archiveUid}/${parentArchive.archiveId}/images/${image.name}"
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
      .collection(FirebaseConstants.logsCollection)
      .doc(image.parentLogId)
      .collection(FirebaseConstants.archivesCollection)
      .doc(image.parentArchiveId)
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

  Stream<List<LogModel>> getLogsStream() {
    return firestoreInstance
      .collection(FirebaseConstants.logsCollection)
      .snapshots()
      .map((event) {
        return event.docs.map((doc) {
          return LogModel.fromJson(doc.data());
        }).toList();
      });
  }

  //GeoFlutterFire uses radius as Km, Google Maps' radius is in meters
  Stream<List<LogModel>> getLogsStreamRadius({required GeoFirePoint center, required double radius}) {
    print('RADIUS = $radius');
    final ref = firestoreInstance.collection(FirebaseConstants.logsCollection);
    return geo
      .collection(collectionRef: ref)
      .within(center: center, radius: radius / 1000, field: FirebaseConstants.position, strictMode: true)
      .map((event) {
        return event.map((doc) {
          return LogModel.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
    });
  }

  double getDistance({required LatLng northeast, required LatLng southwest}) {
    return GeoFirePoint.distanceBetween(to: southwest.coordinatesFromLatLng(), from: northeast.coordinatesFromLatLng())*1000;
  }

  Stream<List<ArchiveModel>> getArchivesStream({required LogModel log}) {
    return firestoreInstance
      .collection(FirebaseConstants.logsCollection)
      .doc(log.logId)
      .collection(FirebaseConstants.archivesCollection)
      .orderBy(FirebaseConstants.date)
      .snapshots()
      .map((event) {
        return event.docs.map((doc) {
          return ArchiveModel.fromJson(doc.data());
        }).toList();
      });
  }

  Stream<List<ImageModel>> getImagesStream({required ArchiveModel archive}) {
    return firestoreInstance
      .collection(FirebaseConstants.logsCollection)
      .doc(archive.parentLogId)
      .collection(FirebaseConstants.archivesCollection)
      .doc(archive.archiveId)
      .collection(FirebaseConstants.imagesCollection)
      .snapshots()
      .map((event) {
        return event.docs.map((doc) {
          return ImageModel.fromJson(doc.data());
        }).toList();
      });
  }
}