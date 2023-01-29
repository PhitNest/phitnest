mixin FromJson<T> {
  T fromJson(Map<String, dynamic> json);

  List<T> fromList(List<dynamic> list) =>
      list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
}

mixin ToJson {
  Map<String, dynamic> toJson();
}
