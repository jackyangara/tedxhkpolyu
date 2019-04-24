

class VideoDB{

  final String _video_id;
  final String _speaker_id;
  final String _category_id;
  final int _numberOfLikes;
  final List<String> _comment_id;
  final String _created_at;
  final String _video_url; 

  const VideoDB(this._video_id, this._speaker_id, this._category_id, this._numberOfLikes, this._comment_id, this._created_at, this._video_url);

  ///Example of named VideoModel constructor to parse JSON data
//  VideoModel.fromJSON(Map map):
//      _title = map['title'],
//      _author = map['author'],
//      _videoUrl = map['videoUrl'],
//      _videoThumbUrl = map['videoThumbUrl'],
//      _duration = map['duration'];

  String get video_id => _video_id;
  String get speaker_id => _speaker_id;
  String get category_id => _category_id;
  int get numberOfLikes => _numberOfLikes;
  List<String> get comment_id => _comment_id;
  String get created_at => _created_at;
  String get video_url => _video_url;


}