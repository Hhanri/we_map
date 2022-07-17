import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:we_map/constants/firebase_constants.dart';
import 'package:we_map/models/archive_model.dart';
import 'package:we_map/models/image_model.dart';
import 'package:we_map/models/log_model.dart';
import 'package:we_map/services/location_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:we_map/utils/extensions.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseFirestoreService {
  final FirebaseAuth authInstance = FirebaseAuth.instance;
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  final FirebaseStorage storageInstance = FirebaseStorage.instance;
  final Geoflutterfire geo = Geoflutterfire();

  Future<void> addLocalPoint() async {
    if (await LocationService.getLocationPermission()) {
      final Position position = await LocationService.getLocation();
      final GeoFirePoint geoPoint = position.geoFireFromPosition();
      await setLog(logModel: LogModel.emptyLog(geoFirePoint: geoPoint, uid: authInstance.currentUser!.uid));
    } else {
      print("NO LOCATION PERMISSION");
    }
  }

  Future<void> setLog({required LogModel logModel}) async {
    await firestoreInstance
      .collection(FirebaseConstants.logsCollection)
      .doc(logModel.geoPoint.hash)
      .set(LogModel.toJson(model: logModel));
  }

  Future<void> deleteLog({required String logId}) async {
    //delete log
    await firestoreInstance
      .collection(FirebaseConstants.logsCollection)
      .doc(logId)
      .delete();
    //delete archives previously from this log
    await firestoreInstance
      .collection(FirebaseConstants.archivesCollection)
      .where(FirebaseConstants.parentLogId, isEqualTo: logId)
      .get()
      .then((logsDocs) {
        Future.forEach(logsDocs.docs, (QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
          final currentArchive = ArchiveModel.fromJson(doc.data());
          await deleteArchive(archiveId: currentArchive.archiveId);
        });
      });
  }

  Future<void> setArchive(ArchiveModel archive) async {
    await firestoreInstance
      .collection(FirebaseConstants.archivesCollection)
      .doc(archive.archiveId)
      .set(ArchiveModel.toJson(archive));
  }

  Future<void> deleteArchive({required String archiveId}) async {
    await firestoreInstance
      .collection(FirebaseConstants.archivesCollection)
      .doc(archiveId)
      .delete();
    await firestoreInstance
      .collection(FirebaseConstants.imagesCollection)
      .where(FirebaseConstants.parentArchiveId, isEqualTo: archiveId)
      .get()
      .then((imagesDocs) {
        Future.forEach(imagesDocs.docs, (QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
          final ImageModel currentImage = ImageModel.fromJson(doc.data());
          await deleteImage(image: currentImage);
        });
      });
  }

  Future<void> updateArchiveWithoutImages({required ArchiveModel newArchive}) async {
    await firestoreInstance
      .collection(FirebaseConstants.archivesCollection)
      .doc(newArchive.archiveId)
      .update(ArchiveModel.toJsonWithoutImages(newArchive));
  }

  Future<void> updateArchiveParentLogId({required String parentLogId, required String newParentLogId}) async {
    await firestoreInstance
      .collection(FirebaseConstants.archivesCollection)
      .where(FirebaseConstants.parentLogId, isEqualTo: parentLogId)
      .get()
      .then((snapshot) {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
          doc.reference.update(
            {FirebaseConstants.parentLogId: newParentLogId}
          );
        }
      });
  }

  Future<void> updateLog({required LogModel oldLog, required LogModel newLog}) async {
    if (newLog != oldLog) {
      print("LOGS DIFFERENT");
      await setLog(logModel: newLog);
      if (newLog.logId != oldLog.logId) {
        await firestoreInstance
          .collection(FirebaseConstants.logsCollection)
          .doc(oldLog.logId)
          .delete();
        await updateArchiveParentLogId(
          parentLogId: oldLog.logId,
          newParentLogId: newLog.logId
        );
      }
    }
  }

  Future<void> setImage({required ImageModel imageModel}) async {
    await firestoreInstance
      .collection(FirebaseConstants.imagesCollection)
      .add(ImageModel.toJson(imageModel));
  }

  Future<void> uploadImage({required String parentLogId, required String parentArchiveId, required XFile image, required String uid}) async {
    final ImageModel imageModel = ImageModel(
        uid: authInstance.currentUser!.uid,
        parentLogId: parentLogId,
        parentArchiveId: parentArchiveId,
        path: "images/$uid/${image.name}"
    );
    final Reference ref = storageInstance.ref().child(imageModel.path);
    await ref.putData(await image.readAsBytes(), SettableMetadata(contentType: "image/jpeg"));
    await setImage(imageModel: imageModel);
  }

  Future<void> deleteImage({required ImageModel image}) async {
    await storageInstance
        .ref(image.path)
        .delete();
    await firestoreInstance
      .collection(FirebaseConstants.imagesCollection)
      .where(FirebaseConstants.path, isEqualTo: image.path)
      .where(FirebaseConstants.parentArchiveId, isEqualTo: image.parentArchiveId)
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

  Stream<List<ArchiveModel>> getArchivesStream({required String parentLogId}) {
    return firestoreInstance
      .collection(FirebaseConstants.archivesCollection)
      .where(FirebaseConstants.parentLogId, isEqualTo: parentLogId)
      .orderBy(FirebaseConstants.date)
      .snapshots()
      .map((event) {
        return event.docs.map((doc) {
          return ArchiveModel.fromJson(doc.data());
        }).toList();
      });
  }

  Stream<List<ImageModel>> getImagesStream({required String parentArchiveId}) {
    return firestoreInstance
      .collection(FirebaseConstants.imagesCollection)
      .where(FirebaseConstants.parentArchiveId, isEqualTo: parentArchiveId)
      .snapshots()
      .map((event) {
        return event.docs.map((doc) {
          return ImageModel.fromJson(doc.data());
        }).toList();
      });
  }
}