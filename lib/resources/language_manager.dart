// ignore_for_file: constant_identifier_names

enum LanguageType {
  ENGLISH,
  GUJARATI,
  HINDI,
}

const String kENGLISH = 'en';
const String kHINDI = 'hi';
const String kGUJARATI = 'gj';

extension LanguageTypeExt on LanguageType {
  String getValue() {
    switch (this) {
      case LanguageType.ENGLISH:
        return kENGLISH;
      case LanguageType.GUJARATI:
        return kGUJARATI;
      case LanguageType.HINDI:
        return kHINDI;
    }
  }
}
