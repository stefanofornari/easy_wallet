bool isWalletAddressValid(String address) {
  final RegExp regexp = RegExp("([0-9a-fA-F]){40}");

  return regexp.hasMatch(address);
}