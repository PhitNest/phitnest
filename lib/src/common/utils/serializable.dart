abstract class Parser<R> {
  const Parser();

  R fromJson(Map<String, dynamic> json);

  List<R> fromList(List<dynamic> list) =>
      list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
}

mixin Writeable {
  Map<String, dynamic> toJson();
}
