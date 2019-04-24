

class BlogDB{

  final String _blog_id;
  final String _title;
  final String _content;
  final String _speaker_id; //speaker table
  final String _category_id; //category table
  final int _numberOfLikes;
  final List<String> _comment_id;
  final String _created_at;

  const BlogDB(this._blog_id, this._title, this._content, this._speaker_id, this._category_id, this._numberOfLikes, this._comment_id, this._created_at);
  ///Example of named VideoModel constructor to parse JSON data
//  VideoModel.fromJSON(Map map):
//      _title = map['title'],
//      _author = map['author'],
//      _videoUrl = map['videoUrl'],
//      _videoThumbUrl = map['videoThumbUrl'],
//      _duration = map['duration'];

  String get blog_id => _blog_id;
  String get title => _title;
  String get content => _content;
  String get speaker_id => _speaker_id;
  String get category_id => _category_id;
  int get numberOfLikes => _numberOfLikes;
  List<String> get comment_id => _comment_id;
  String get created_at => _created_at;


}