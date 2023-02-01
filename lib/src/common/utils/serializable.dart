mixin Serializable {
  Map<String, dynamic> toJson();

  static const empty = _EmptyRequest();
}

class _EmptyRequest with Serializable {
  const _EmptyRequest();

  @override
  Map<String, dynamic> toJson() => const {};
}
