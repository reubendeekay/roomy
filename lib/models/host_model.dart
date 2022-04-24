class HostModel {
  final String pin;
  double balance = 0;
  final String mpesaNumber;
  final String area;
  final String city;
  final String country;
  final int likes;
  final int views;
  final String userId;
  final int totalBookings;
  final double totalEarnings;

  HostModel({
    this.pin,
    this.balance,
    this.mpesaNumber,
    this.area,
    this.city,
    this.country,
    this.userId,
    this.likes,
    this.views,
    this.totalEarnings,
    this.totalBookings,
  });
}
