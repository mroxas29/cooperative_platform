class ServicesOffered {
  String name;
  String description;
  double price;
  List<String> availableDays;

  ServicesOffered({
    required this.name,
    required this.description,
    required this.price,
    required this.availableDays,
  });

   Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'availableDays': availableDays,
    };
  }
}
List<ServicesOffered> allServices = [];

