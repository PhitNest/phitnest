abstract class Either3<First, Second, Third> {
  const Either3();

  B fold<B>(B Function(First l) ifFirst, B Function(Second m) ifSecond,
      B Function(Third r) ifThird);
}

class First<F, S, T> extends Either3<F, S, T> {
  final F _f;

  const First(this._f) : super();

  @override
  B fold<B>(B Function(F l) ifFirst, B Function(S m) ifSecond,
          B Function(T r) ifThird) =>
      ifFirst(_f);
}

class Second<F, S, T> extends Either3<F, S, T> {
  final S _s;

  const Second(this._s) : super();

  @override
  B fold<B>(B Function(F l) ifFirst, B Function(S m) ifSecond,
          B Function(T r) ifThird) =>
      ifSecond(_s);
}

class Third<F, S, T> extends Either3<F, S, T> {
  final T _t;

  const Third(this._t) : super();

  @override
  B fold<B>(B Function(F l) ifFirst, B Function(S m) ifSecond,
          B Function(T r) ifThird) =>
      ifThird(_t);
}
