class CaregroupType {
  final String type;

  const CaregroupType(this.type);

  static const CaregroupType open = CaregroupType('open');
  static const CaregroupType closed = CaregroupType('closed');

  static List<CaregroupType> caregroupTypeList = [
    open,
    closed,
  ];
}
