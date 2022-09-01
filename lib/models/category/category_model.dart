class CategoryModel {
  List<String>? personal;
  List<String>? business;

  CategoryModel({
    this.personal,
    this.business,
  });

  CategoryModel.fromMap(Map<String, dynamic>? data) {
    if (data?['personal'] != null) {
      personal = [];
      data?['personal'].forEach((v) {
        personal?.add(v);
      });
    }
    if (data?['business'] != null) {
      business = [];
      data?['business'].forEach((v) {
        business?.add(v);
      });
    }
  }

  Map<String, dynamic> getMap() => {
        'personal': personal,
        'business': business,
      };
}

final categoryData = CategoryModel(
  personal: [
    "Dinner",
    "Kids Games",
    "Date Night",
    "Friends",
  ],
  business: [
    "Between Offices",
    "Customer Visit",
    "Meeting",
    "Supplies",
    "Meal/Entertain",
    "Temporary Site",
    "Airport/Travel",
  ],
);
