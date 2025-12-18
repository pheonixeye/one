enum PcFormFieldType {
  textfield,
  dropdown,
  checkbox;

  const PcFormFieldType();

  static PcFormFieldType fromString(String value) {
    return switch (value) {
      'textfield' => textfield,
      'dropdown' => dropdown,
      'checkbox' => checkbox,
      _ => throw UnimplementedError(),
    };
  }
}
