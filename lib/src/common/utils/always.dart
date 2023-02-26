part of utils;

extension AlwaysCallback on bool {
  bool Function<T>(T, T) get always => <T>(T l, T r) => this;
}
