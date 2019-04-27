import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class BlogDB{

  final String _blog_id;
  final String _title;
  final String _subtitle;
  final String _content;
  final DocumentReference _speaker_id; //speaker table
  final DocumentReference _category_id; //category table
  final int _numberOfLikes;
  final List<dynamic> _comment_id;
  final Timestamp _created_at;

  const BlogDB(this._blog_id, this._title, this._subtitle, this._content, this._speaker_id, this._category_id, this._numberOfLikes, this._comment_id, this._created_at);
  ///Example of named VideoModel constructor to parse JSON data
//  VideoModel.fromJSON(Map map):
//      _title = map['title'],
//      _author = map['author'],
//      _videoUrl = map['videoUrl'],
//      _videoThumbUrl = map['videoThumbUrl'],
//      _duration = map['duration'];

  String get blog_id => _blog_id;
  String get title => _title;
  String get subtitle => _subtitle;
  String get content => _content;
  DocumentReference get speaker_id => _speaker_id;
  DocumentReference get category_id => _category_id;
  int get numberOfLikes => _numberOfLikes;
  List<dynamic> get comment_id => _comment_id;
  Timestamp get created_at => _created_at;

}