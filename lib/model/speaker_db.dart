class SpeakerDB{
  final String _speaker_id;
  final String _speaker_name;

  const SpeakerDB(this._speaker_id, this._speaker_name);

  String get speaker_id => _speaker_id;
  String get speaker_name => _speaker_name;

}