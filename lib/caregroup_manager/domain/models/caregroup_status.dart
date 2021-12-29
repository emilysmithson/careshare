class CaregroupStatus {
  final String status;

  CaregroupStatus(this.status);

  static CaregroupStatus active = CaregroupStatus('Active');
  static CaregroupStatus inactive = CaregroupStatus('Inactive');
  static CaregroupStatus archived = CaregroupStatus('Archived');

  static List<CaregroupStatus> CaregroupStatusList = [
    active,
    inactive,
    archived,
  ];
}
