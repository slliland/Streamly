import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamly/db/hi_cache.dart';

void main() {
  //HiCache Unit test
  test('Unit Test for HiCache', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await HiCache.preInit();
    var key = 'testHiCache', value = 'Hello.';
    HiCache.getInstance().setString(key, value);
    expect(HiCache.getInstance().get(key), value);
  });
}
