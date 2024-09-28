String padiByString({required int paid, required String name}) {
  if (paid == 2) {
    return 'split';
  } else if (paid == 1) {
    return 'paid by $name';
  } else {
    return 'paid by you';
  }
}
