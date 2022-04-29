import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';

class Photo {
  final String user_id;
  String? photoId;
  final String image;

  Photo({
    required this.user_id,
    this.photoId,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'image': image,
    };
  }

  static Photo fromJson(Map<String, Object?> json) =>
      Photo(user_id: json['user_id'] as String, image: json['image'] as String);

  static Photo? fromMap(Map<String, dynamic> map) {
    var user_id = map['user_id'];
    var photoId = map['photoID'];
    var image = map['image'];

    return Photo(user_id: user_id, photoId: photoId.toString(), image: image);
  }

  static Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  // Implement toString to make it easier to see information about
  // each Photo when using the print statement.
  @override
  String toString() {
    if (photoId != null) {
      return 'Photo{user_id: $user_id, photoID: $photoId , image: $image}';
    }
    return 'Photo{user_id: $user_id, image: $image}';
  }
}

class Publication {
  final String user_id;
  final String photoId;
  final String date;

  const Publication({
    required this.user_id,
    required this.photoId,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {'user_id': user_id, 'photoId': photoId, 'date': date};
  }

  static Publication fromJson(Map<String, Object?> json) => Publication(
      user_id: json['user_id'] as String,
      photoId: json['photoId'] as String,
      date: json['date'] as String);

  static Publication fromMap(Map<String, dynamic> map) {
    var user_id = map['user_id'];
    var photoId = map['photoID'];
    var date = map['date'];

    return Publication(
        user_id: user_id, photoId: photoId.toString(), date: date);
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  // Implement toString to make it easier to see information about
  // each Publication when using the print statement.
  @override
  String toString() {
    return 'Publication{user_id: $user_id, photoId: $photoId, date: $date}';
  }
}
