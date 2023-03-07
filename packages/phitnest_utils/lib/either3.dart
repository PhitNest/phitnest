abstract class Either3<Alpha, Beta, Gamma> {
  const Either3();

  B fold<B>(B Function(Alpha l) ifAlpha, B Function(Beta m) ifBeta,
      B Function(Gamma r) ifGamma);
}

class Alpha<F, S, T> extends Either3<F, S, T> {
  final F _f;

  const Alpha(this._f) : super();

  @override
  B fold<B>(B Function(F l) ifAlpha, B Function(S m) ifBeta,
          B Function(T r) ifGamma) =>
      ifAlpha(_f);
}

class Beta<F, S, T> extends Either3<F, S, T> {
  final S _s;

  const Beta(this._s) : super();

  @override
  B fold<B>(B Function(F l) ifAlpha, B Function(S m) ifBeta,
          B Function(T r) ifGamma) =>
      ifBeta(_s);
}

class Gamma<F, S, T> extends Either3<F, S, T> {
  final T _t;

  const Gamma(this._t) : super();

  @override
  B fold<B>(B Function(F l) ifAlpha, B Function(S m) ifBeta,
          B Function(T r) ifGamma) =>
      ifGamma(_t);
}
