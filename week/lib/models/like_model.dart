class LikeModel {
  String user_id;
  String publicationID;
  String liked;

  LikeModel(this.user_id, this.publicationID, this.liked);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'user_id': user_id,
      'publicationID': publicationID,
      'liked': liked
    };
    return map;
  }

  static LikeModel fromMap(Map<String, dynamic> map) {
    var user_id = map['user_id'];
    var publicationID = map['publicationID'];
    var liked = map['liked'];

    return LikeModel(user_id, publicationID.toString(), liked.toString());
  }

  @override
  String toString() {
    return 'LikeModel{user_id: $user_id, publicationID: $publicationID, liked: $liked}';
  }
}
