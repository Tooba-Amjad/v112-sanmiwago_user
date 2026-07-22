class LocationState {
  String id;
  String name;
  String status;

  LocationState({
    this.id = "",
    this.name = "",
    this.status = "",
  });

  LocationState copyWith({
    String? id,
    String? name,
    String? status,
  }) =>
      LocationState(
        id: id ?? this.id,
        name: name ?? this.name,
        status: status ?? this.status,
      );

  factory LocationState.fromJson(Map<String, dynamic> json) => LocationState(
    id: json["id"] ?? "",
    name: json["name"] ?? "",
    status: json["status"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "status": status,
  };
}
