class FirebaseConstants {

  //collections
  static const String logsCollection = 'logs';
  static const String archivesCollection = 'archives';
  static const String imagesCollection = 'images';
  static const String usersCollection = 'users';

  //parameters
    //logs
  static const String logId = 'logId';
  static const String position = 'position';
  static const String geopoint = 'geopoint';
  static const String streetName = 'streetName';
    //archives
  static const String archiveId = 'archiveId';
  static const String parentLogUid = 'parentLogUid';
  static const String parentLogId = 'parentLogId';
  static const String date = 'date';
  static const String waterLevel = 'waterLevel';
  static const String note = 'note';
    //images
  static const String parentArchiveId = 'parentArchiveId';
  static const String path = 'path';
  static const String url = 'url';
    //users
  static const String uid = 'uid';
  static const String username = 'username';
}