class CreateOrganizationDto {
  final String name;
  final String description;

  CreateOrganizationDto({
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
    };
  }
}
