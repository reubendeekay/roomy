class FilterModel {
  double price;
  double rating;
  String category;
  String location;
  String name;
  int rooms;
  String searchTerm;
  List<String> ammenities;

  FilterModel(
      {this.price,
      this.rating,
      this.category,
      this.location,
      this.name = '',
      this.rooms,
      this.searchTerm,
      this.ammenities});
}
