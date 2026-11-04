extension DeepListEquality<T> on List<T> {
  bool isDeeplyEqualTo(List<T> original) {
    if (length != original.length) {
      return false;
    }
    bool isEqual = true;
    for (var i = 0; i < original.length; i++) {
      isEqual = this[i] == original[i];
    }
    return isEqual;
  }
}
