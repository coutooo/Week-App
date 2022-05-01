class FollowerModel {
  String user_id;
  String followerID;
  String date;

  FollowerModel(this.user_id, this.followerID, this.date);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'user_id': user_id,
      'followerID': followerID,
      'date': date,
    };
    return map;
  }

  static FollowerModel fromMap(Map<String, dynamic> map) {
    var user_id = map['user_id'];
    var followerID = map['followerID'];
    var date = map['date'];

    return FollowerModel(user_id, followerID, date);
  }

  @override
  String toString() {
    return 'FollowerModel{user_id: $user_id, followerID: $followerID, date: $date}';
  }
}





// https://youtu.be/8sC9paqJJjI?t=324    tou aqui