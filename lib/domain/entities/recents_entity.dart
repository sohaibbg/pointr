part of 'searchable_place.dart';

@MappableClass()
class RecentEntity extends AddressEntity with RecentEntityMappable {
  @override
  // ignore: overridden_fields
  final String name;

  const RecentEntity({
    required super.coordinates,
    required this.name,
  }) : super(address: name);

  @override
  bool operator ==(covariant RecentEntity other) {
    if (identical(this, other)) return true;

    return other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
