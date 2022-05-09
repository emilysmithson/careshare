class CaregroupStatus {
  final String status;

  const CaregroupStatus(this.status);

  static const CaregroupStatus draft = CaregroupStatus('draft');
  static const CaregroupStatus active = CaregroupStatus('active');
  static const CaregroupStatus inactive = CaregroupStatus('inactive');
  static const CaregroupStatus archived = CaregroupStatus('archived');

  static List<CaregroupStatus> CaregroupStatusList = [
    draft,
    active,
    inactive,
    archived,
  ];
}
