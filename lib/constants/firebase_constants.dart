class FirebaseConstants {

  //collections
  static const String topicsCollection = 'topics';
  static const String postsCollection = 'posts';
  static const String imagesCollection = 'images';
  static const String usersCollection = 'users';
  static const String commentsCollection = 'comments';

  //parameters
    //topic
  static const String topicId = 'topicId';
  static const String position = 'position';
  static const String geopoint = 'geopoint';
  static const String topicTitle = 'topicTitle';
  static const String topicDescription = 'topicDescription';
    //post
  static const String postId = 'postId';
  static const String parentTopicId = 'parentTopicId';
  static const String date = 'date';
  static const String postTitle = 'postTitle';
  static const String postDescription = 'postDescription';
    //images
  static const String parentPostId = 'parentPostId';
  static const String path = 'path';
  static const String url = 'url';
    //users
  static const String uid = 'uid';
  static const String email = 'email';
  static const String username = 'username';
  static const String likedPosts = 'likedPosts';
  static const String dislikedPosts = 'dislikedPosts';
  static const String likedComments = 'likedComments';
  static const String likedReplies = 'likedReplies';
    //comments
  static const String commentId = 'commentId';
  static const String comment = 'comment';
  static const String replies = 'replies';

  static const String likes = 'likes';
  static const String dislikes = 'dislikes';
}