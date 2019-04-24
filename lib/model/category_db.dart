class CategoryDB{
  final String _category_id;
  final String _category_name;

  const CategoryDB(this._category_id, this._category_name);

  String get category_id => _category_id;
  String get category_name => _category_name;
}