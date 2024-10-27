class City {
  bool isSelected;
  String city;
  String country;
  bool isDefault;

  City(
      {required this.isSelected,
      required this.city,
      required this.country,
      required this.isDefault});

  static List<City> citieList = [
    City(isSelected: false, city: 'Chennai', country: 'India', isDefault: true),
    City(isSelected: false, city: 'Mumbai', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Delhi', country: 'India', isDefault: false),
    City(
        isSelected: false,
        city: 'Bangalore',
        country: 'India',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Hyderabad',
        country: 'India',
        isDefault: false),
    City(
        isSelected: false, city: 'Kolkata', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Pune', country: 'India', isDefault: false),
    City(
        isSelected: false,
        city: 'Ahmedabad',
        country: 'India',
        isDefault: false),
    City(isSelected: false, city: 'Jaipur', country: 'India', isDefault: false),
    City(
        isSelected: false, city: 'Lucknow', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Surat', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Nagpur', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Indore', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Bhopal', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Kochi', country: 'India', isDefault: false),
  ];

  // get cities
  static List<City> getListOfCities() {
    List<City> selectedCities = City.citieList;

    return selectedCities.where((city) => city.isSelected == true).toList();
  }
}
