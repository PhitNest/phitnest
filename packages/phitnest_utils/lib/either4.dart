abstract class Either4<A, B, C, D> {
  const Either4();

  R fold<R>(
    R Function(A a) ifA,
    R Function(B b) ifB,
    R Function(C c) ifC,
    R Function(D d) ifD,
  );
}

class First<A, B, C, D> extends Either4<A, B, C, D> {
  final A _a;

  const First(this._a) : super();

  @override
  R fold<R>(
    R Function(A a) ifA,
    R Function(B b) ifB,
    R Function(C c) ifC,
    R Function(D d) ifD,
  ) =>
      ifA(_a);
}

class Second<A, B, C, D> extends Either4<A, B, C, D> {
  final B _b;

  const Second(this._b) : super();

  @override
  R fold<R>(
    R Function(A a) ifA,
    R Function(B b) ifB,
    R Function(C c) ifC,
    R Function(D d) ifD,
  ) =>
      ifB(_b);
}

class Third<A, B, C, D> extends Either4<A, B, C, D> {
  final C _c;

  const Third(this._c) : super();

  @override
  R fold<R>(
    R Function(A a) ifA,
    R Function(B b) ifB,
    R Function(C c) ifC,
    R Function(D d) ifD,
  ) =>
      ifC(_c);
}

class Fourth<A, B, C, D> extends Either4<A, B, C, D> {
  final D _d;

  const Fourth(this._d) : super();

  @override
  R fold<R>(
    R Function(A a) ifA,
    R Function(B b) ifB,
    R Function(C c) ifC,
    R Function(D d) ifD,
  ) =>
      ifD(_d);
}
