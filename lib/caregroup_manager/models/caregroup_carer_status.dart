class CaregroupCarerStatus {
  final String status;

  const CaregroupCarerStatus(this.status);

  static const CaregroupCarerStatus draft = CaregroupCarerStatus('draft');
  static const CaregroupCarerStatus active = CaregroupCarerStatus('active');
  static const CaregroupCarerStatus inactive = CaregroupCarerStatus('inactive');
  static const CaregroupCarerStatus archived = CaregroupCarerStatus('archived');

  static List<CaregroupCarerStatus> CaregroupCarerStatusList = [
    draft,
    active,
    inactive,
    archived,
  ];
}
