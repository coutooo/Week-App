import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';

class Photo {
  final int id;
  final int albumId;
  final int photoId;
  final String caption;
  final String image;
  final DateTime date;

  const Photo(
      {required this.id,
      required this.albumId,
      required this.photoId,
      required this.caption,
      required this.image,
      required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'albumId': albumId,
      'photoId': photoId,
      'caption': caption,
      'image': image,
      'date': date
    };
  }

  static Photo fromJson(Map<String, Object?> json) => Photo(
      id: json['id'] as int,
      albumId: json['albumId'] as int,
      photoId: json['photoId'] as int,
      caption: json['caption'] as String,
      image: json['image'] as String,
      date: json['date'] as DateTime);

  static Photo? fromMap(Map<String, dynamic> map) {
    var id = map['id'];
    var albumId = map['albumId'];
    var photoId = map['photoId'];
    var caption = map['caption'];
    var image = map['image'];
    var date = map['date'];

    return Photo(
        id: id,
        albumId: albumId,
        photoId: photoId,
        caption: caption,
        image: image,
        date: date);
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
  // each Photo when using the print statement.
  @override
  String toString() {
    return 'Photo{id: $id, albumId: $albumId, photoId: $photoId, caption: $caption, image: $image, date: $date}';
  }
}
