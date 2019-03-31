/// Data class for videos in TrendingTab and NewestTab.
/// Add or remove fields as needed.

class VideoModel{
  final String _title;
  final String _author;
  final String _videoUrl;
  final String _videoThumbUrl;
  final int _duration; ///in seconds

  const VideoModel(this._title, this._author, this._videoUrl, this._videoThumbUrl,this._duration);

  ///Example of named VideoModel constructor to parse JSON data
//  VideoModel.fromJSON(Map map):
//      _title = map['title'],
//      _author = map['author'],
//      _videoUrl = map['videoUrl'],
//      _videoThumbUrl = map['videoThumbUrl'],
//      _duration = map['duration'];

  String get title => _title;
  String get author => _author;
  String get videoUrl => _videoUrl;
  String get videoThumbUrl => _videoThumbUrl;
  int get duration => _duration;


}