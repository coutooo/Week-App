class Comment {
  String? commentID;
  final String user_id;
  final String publicationID;
  final String commentText;

  Comment(
      {this.commentID,
      required this.user_id,
      required this.publicationID,
      required this.commentText});

  Map<String, dynamic> toMap() {
    return {
      'commentID': commentID,
      'user_id': user_id,
      'publicationID': publicationID,
      'commentText': commentText,
    };
  }

  static Comment fromJson(Map<String, Object?> json) => Comment(
      user_id: json['user_id'] as String,
      commentID: json['commentID'] as String,
      publicationID: json['publicationID'] as String,
      commentText: json['commentText'] as String);

  static Comment fromMap(Map<String, dynamic> map) {
    var user_id = map['user_id'];
    var commentID = map['commentID'];
    var publicationID = map['publicationID'];
    var commentText = map['commentText'];

    return Comment(
        user_id: user_id,
        commentID: commentID.toString(),
        publicationID: publicationID.toString(),
        commentText: commentText);
  }

  // Implement toString to make it easier to see information about
  // each Photo when using the print statement.
  @override
  String toString() {
    return 'Comment{user_id: $user_id, commentID: $commentID, publicationID: $publicationID, commentText: $commentText}';
  }
}
