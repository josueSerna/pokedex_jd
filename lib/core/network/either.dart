sealed class Either<L, R> {
  const Either();
  T fold<T>(T Function(L l) leftFn, T Function(R r) rigthFn);

  bool get isLeft => this is Left<L, R>;
  bool get isRigth => this is Rigth<L, R>;

  L? get left => isLeft ? (this as Left<L, R>).value : null;
  R? get rigth => isRigth ? (this as Rigth<L, R>).value : null;
}

class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);

  @override
  fold<T>(Function(L l) leftFn, Function(R r) rigthFn) {
    return leftFn(value);
  }
}

class Rigth<L, R> extends Either<L, R> {
  final R value;
  const Rigth(this.value);

  @override
  T fold<T>(T Function(L l) leftFn, T Function(R r) rigthFn) {
    return rigthFn(value);
  }
}
