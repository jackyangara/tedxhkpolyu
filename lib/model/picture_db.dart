

class PictureDB{

  final String _picture_id;
  final String _title;
  final String _picture;
  final String _speaker_id;
  final String _category_id;
  final int _numberOfLikes;
  final List<String> _comment_id;
  final String _created_at;

  const PictureDB(this._picture_id, this._title, this._picture, this._speaker_id, this._category_id, this._numberOfLikes, this._comment_id, this._created_at);

  ///Example of named VideoModel constructor to parse JSON data
//  VideoModel.fromJSON(Map map):
//      _title = map['title'],
//      _author = map['author'],
//      _videoUrl = map['videoUrl'],
//      _videoThumbUrl = map['videoThumbUrl'],
//      _duration = map['duration'];

  String get picture_id => _picture_id;
  String get title => _title;
  String get picture => _picture;
  String get speaker_id => _speaker_id;
  String get category_id => _category_id;
  int get numberOfLikes => _numberOfLikes;
  List<String> get comment_id => _comment_id;
  String get created_at => _created_at;


}