abstract class ValidatedObject<T> {
  final String jsonString = '';
  final bool validate = true;

  T value;
  ValidatedObject(this.value);

  @override
  String toString() => 'Value($value)';
}
