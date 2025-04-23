class ShortService implements ServiceInterface {
  final String name;
  final String serviceType;
  final String description;
  final String serviceImage;

  ShortService({
    required this.name,
    required this.serviceType,
    required this.description,
    required this.serviceImage,
  });

  @override
  String get descritpion => description;

  @override
  String get image => serviceImage;
}

abstract interface class ServiceInterface {
  String get image;
  String get descritpion;
}

class LongService implements ServiceInterface {
  final String name;
  final String type;
  final String description;
  @override
  final String image;
  final String params;
  final String date;

  LongService({
    required this.name,
    required this.type,
    required this.description,
    required this.image,
    required this.params,
    required this.date,
  });

  @override
  // TODO: implement descritpion
  String get descritpion => throw UnimplementedError();
}
