class UserModel {
  String user_id;
  String user_name;
  String email;
  String password;
  String? imagePath;
  String? about;

  UserModel(this.user_id, this.user_name, this.email, this.password,
      this.imagePath, this.about);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'user_id': user_id,
      'user_name': user_name,
      'email': email,
      'password': password,
      'imagePath': imagePath,
      'about': about
    };
    return map;
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    var user_id = map['user_id'];
    var user_name = map['user_name'];
    var email = map['email'];
    var password = map['password'];
    var imagePath = map['imagePath'];
    var about = map['about'];

    return UserModel(user_id, user_name, email, password, imagePath, about);
  }

  @override
  String toString() {
    return 'UserModel{user_id: $user_id, user_name: $user_name, email: $email, password: $password, imagePath: $imagePath, about: $about, }';
  }
}





// https://youtu.be/8sC9paqJJjI?t=324    tou aqui