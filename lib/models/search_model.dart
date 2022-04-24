class SearchModel {
  final String location;
  final String name;
  final String category;
  final String startPrice;
  final String endPrice;
  final List<int> rooms;
  final List<String> ammenities;
  final double startRating;
  final double endRating;

  SearchModel(
      this.location,
      this.name,
      this.category,
      this.startPrice,
      this.endPrice,
      this.rooms,
      this.ammenities,
      this.startRating,
      this.endRating);
}
