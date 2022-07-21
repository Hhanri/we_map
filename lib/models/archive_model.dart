import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:we_map/constants/firebase_constants.dart';

class ArchiveModel extends Equatable {
  final String uid;
  final String archiveId;
  final String parentLogId;
  final DateTime date;
  final double waterLevel;
  final String note;

  const ArchiveModel({
    required this.uid,
    required this.archiveId,
    required this.parentLogId,
    required this.date,
    required this.waterLevel,
    required this.note,
  });

  factory ArchiveModel.fromJson(Map<String, dynamic> json) {
    return ArchiveModel(
      uid: json[FirebaseConstants.uid],
      archiveId: json[FirebaseConstants.archiveId],
      parentLogId: json[FirebaseConstants.parentLogId],
      date: (json[FirebaseConstants.date] as Timestamp).toDate(),
      waterLevel: json[FirebaseConstants.waterLevel],
      note: json[FirebaseConstants.note],
    );
  }

  static Map<String, dynamic> toJson(ArchiveModel model) {
    return {
      FirebaseConstants.uid: model.uid,
      FirebaseConstants.archiveId: model.archiveId,
      FirebaseConstants.parentLogId: model.parentLogId,
      FirebaseConstants.date: model.date,
      FirebaseConstants.waterLevel: model.waterLevel,
      FirebaseConstants.note: model.note,
    };
  }

  @override
  List<Object?> get props => [date, waterLevel, note];
}