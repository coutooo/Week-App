class Clothing {
  final String user_id;
  String photoID;
  final String date;
  final String clothType;
  final String brand;
  final String season;
  final String store;
  final String color;

  Clothing({
    required this.user_id,
    required this.photoID,
    required this.date,
    required this.clothType,
    required this.brand,
    required this.season,
    required this.store,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'photoID': photoID,
      'date': date,
      'clothType': clothType,
      'brand': brand,
      'season': season,
      'store': store,
      'color': color,
    };
  }

  static Clothing fromJson(Map<String, Object?> json) => Clothing(
      user_id: json['user_id'] as String,
      photoID: json['photoID'] as String,
      date: json['date'] as String,
      clothType: json['clothType'] as String,
      brand: json['brand'] as String,
      season: json['season'] as String,
      store: json['store'] as String,
      color: json['color'] as String);

  static Clothing fromMap(Map<String, dynamic> map) {
    var user_id = map['user_id'];
    var photoId = map['photoID'];
    var date = map['date'];
    var clothType = map['clothType'];
    var brand = map['brand'];
    var season = map['season'];
    var store = map['store'];
    var color = map['color'];

    return Clothing(
        user_id: user_id,
        photoID: photoId.toString(),
        date: date,
        clothType: clothType,
        brand: brand,
        season: season,
        store: store,
        color: color);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Clothing &&
          runtimeType == other.runtimeType &&
          user_id == other.user_id &&
          photoID == other.photoID &&
          date == other.date &&
          clothType == other.clothType &&
          brand == other.brand &&
          season == other.season &&
          store == other.store &&
          color == other.color;

  @override
  int get hashCode =>
      user_id.hashCode ^
      photoID.hashCode ^
      date.hashCode ^
      clothType.hashCode ^
      brand.hashCode ^
      season.hashCode ^
      store.hashCode ^
      color.hashCode;

  // Implement toString to make it easier to see information about
  // each Photo when using the print statement.
  @override
  String toString() {
    return 'Clothing{user_id: $user_id, photoID: $photoID, date: $date, clothType: $clothType, brand: $brand, season: $season, store: $store, color: $color,}';
  }
}
