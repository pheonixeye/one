enum PkFieldType {
  textfield,
  dropdown,
  checkbox;

  const PkFieldType();

  static PkFieldType fromString(String value) {
    return switch (value) {
      'textfield' => textfield,
      'dropdown' => dropdown,
      'checkbox' => checkbox,
      _ => throw UnimplementedError(),
    };
  }
}
