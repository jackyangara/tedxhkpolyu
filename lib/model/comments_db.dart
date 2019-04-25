class CommentsDB{

  final String _comment_id;
  final String _comment_details;
  final String _comment_writer;
  final String _comment_time;

  const CommentsDB(this._comment_id, this._comment_details, this._comment_writer, this._comment_time);

  ///Example of named VideoModel constructor to parse JSON data
//  VideoModel.fromJSON(Map map):
//      _title = map['title'],
//      _author = map['author'],
//      _videoUrl = map['videoUrl'],
//      _videoThumbUrl = map['videoThumbUrl'],
//      _duration = map['duration'];

  String get comment_id => _comment_id;
  String get comment_details => _comment_details;
  String get comment_writer => _comment_writer;
  String get comment_time => _comment_time;
  


}