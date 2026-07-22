class AddressFromLatLngGMap {
  final List<AddressResult> results;

  AddressFromLatLngGMap({required this.results});

  factory AddressFromLatLngGMap.fromJson(Map<String, dynamic> json) {
    return AddressFromLatLngGMap(
      results: (json['results'] as List).map((result) => AddressResult.fromJson(result)).toList(),
    );
  }
}

class AddressResult {
  final String formattedAddress;
  final String houseNumber;
  final String street;
  final String building;
  final String neighborhood;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final List<AddressComponent> addressComponents;

  AddressResult({
    required this.formattedAddress,
    required this.houseNumber,
    required this.street,
    required this.building,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.addressComponents,
  });

  factory AddressResult.fromJson(Map<String, dynamic> json) {
    List<AddressComponent> components = (json['address_components'] as List).map((component) => AddressComponent.fromJson(component)).toList();

    return AddressResult(
      formattedAddress: json['formatted_address'] ?? '',
      houseNumber: _getComponent(components, 'street_number'),
      street: _getComponent(components, 'route'),
      building: _getComponent(components, 'premise').isNotEmpty ? _getComponent(components, 'premise') : _getComponent(components, 'subpremise'),
      neighborhood: _getComponent(components, 'neighborhood'),
      city: _getComponent(components, 'locality').isNotEmpty ? _getComponent(components, 'locality') : _getComponent(components, 'sublocality_level_1'),
      state: _getComponent(components, 'administrative_area_level_1'),
      zipCode: _getComponent(components, 'postal_code'),
      country: _getComponent(components, 'country'),
      addressComponents: components,
    );
  }

  static String _getComponent(List<AddressComponent> components, String type) {
    return components.firstWhere((component) => component.types.contains(type), orElse: () => AddressComponent.empty()).longName;
  }
}

class AddressComponent {
  final String longName;
  final String shortName;
  final List<String> types;

  AddressComponent({required this.longName, required this.shortName, required this.types});

  factory AddressComponent.fromJson(Map<String, dynamic> json) {
    return AddressComponent(
      longName: json['long_name'] ?? '',
      shortName: json['short_name'] ?? '',
      types: List<String>.from(json['types'] ?? []),
    );
  }

  factory AddressComponent.empty() {
    return AddressComponent(longName: '', shortName: '', types: []);
  }
}
