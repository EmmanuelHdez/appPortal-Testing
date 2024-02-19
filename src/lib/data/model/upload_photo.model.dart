import 'package:meta/meta.dart';
import 'dart:convert';

UploadPhotoModel uploadPhotoModelFromJson(String str) => UploadPhotoModel.fromJson(json.decode(str));

String uploadPhotoModelToJson(UploadPhotoModel data) => json.encode(data.toJson());

class UploadPhotoModel {
    int id;
    String name;
    String url;
    String key;

    UploadPhotoModel({
        required this.id,
        required this.name,
        required this.url,
        required this.key,
    });

    factory UploadPhotoModel.fromJson(Map<String, dynamic> json) => UploadPhotoModel(
        id: json["id"],
        name: json["name"],
        url: json["url"],
        key: json["key"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
        "key": key,
    };
}
