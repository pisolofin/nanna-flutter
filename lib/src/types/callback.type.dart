typedef NaTCallback<T, R> = R Function(T value);
typedef NaAsyncTCallback<T, F> = Future<F> Function(T value);

typedef NaIntCallback<R> = NaTCallback<int, R>;
typedef NaAsyncIntCallback<F> = NaAsyncTCallback<int, F>;
