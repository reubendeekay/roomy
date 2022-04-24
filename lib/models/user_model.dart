class UserModel {
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;
  final String imageUrl;
  final DateTime dateOfBirth;
  final String address;
  final String nationalId;
  final String userId;
  final bool isHost;
  final List<dynamic> wishlist;
  bool isAdmin;
  final bool isOnline;
  final int lastSeen;

  UserModel(
      {this.userId,
      this.fullName,
      this.email,
      this.password,
      this.phoneNumber,
      this.isHost = false,
      this.imageUrl,
      this.wishlist,
      this.address,
      this.nationalId,
      this.dateOfBirth,
      this.isAdmin,
      this.isOnline,
      this.lastSeen});
}
