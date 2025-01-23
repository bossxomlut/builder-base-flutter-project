class SplitListUtils {
  static const int seeMoreCount = 2;

  static List<T> splitList<T>(List<T> list, {int maxLength = seeMoreCount}) {
    //if list length is less than maxLength, return the list
    if (list.length <= maxLength) {
      return list.toList();
    }

    return list.sublist(0, maxLength);
  }
}
