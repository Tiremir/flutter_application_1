call flutter clean && flutter pub get
call dart analyze
call flutter test test/unit_test.dart || exit 1
call flutter test test/widget_test.dart || exit 1
call flutter test integration_test/app_test.dart || exit 1