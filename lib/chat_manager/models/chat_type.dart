class ChatType {
  final String type;
  final String definition;
  final int value;
  final String icon;

  const ChatType(this.type, this.value, this.definition, this.icon);

  static const ChatType text = ChatType('text', 1, 'has to be done locally', 'holiday_village_outlined ');
  static const ChatType audio = ChatType('audio', 2, 'can be done remotely','settings_phone_sharp ');
  static const ChatType image = ChatType('image', 3, 'can be done from anywhere','gps_fixed_sharp ');

  static List<ChatType> chatTypeList = [
    text,
    audio,
    image,

  ];
}
