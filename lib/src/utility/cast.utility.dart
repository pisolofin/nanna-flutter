/// Casting utility, try to cast [targetValue] to [T]
/// If the cast fails, [defaultValue] is returned
T naCastIf<T>(dynamic targetValue, { T Function()? defaultValue, }) {
  if (targetValue is T) {
    return targetValue;
  }else {
    if (defaultValue != null) {
      return defaultValue();
    }else if (null is T) {
      return null as T;
    }

    throw ArgumentError(
      'naCastIf failed: defaultValue is required when T is non-nullable ($T) and value is invalid.',
    );
  }
}
