flutter pub run pigeon \
  --input brands/zodiac/lib/pigeons/recaptcha_api_description.dart \
  --dart_out brands/zodiac/lib/pigeons/recaptcha_api.dart \
  --kotlin_out ./android/app/src/main/kotlin/com/adviqo/pigeon/Pigeon.kt \
  --kotlin_package "com.adviqo.pigeon" \
  --experimental_swift_out ios/Runner/Pigeon.swift