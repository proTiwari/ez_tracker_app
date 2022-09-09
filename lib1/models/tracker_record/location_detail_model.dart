class LocationDetailsModel {
  String? time;
  String? address;

  LocationDetailsModel({
    this.time,
    this.address,
  });

  LocationDetailsModel copyWith({
    String? time,
    String? address,
  }) {
    return LocationDetailsModel(
      time: time ?? this.time,
      address: address ?? this.address,
    );
  }
}
