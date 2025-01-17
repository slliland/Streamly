import 'package:hi_net/hi_net.dart';

import '../../model/profile_mo.dart';
import '../request/profile_request.dart';

class ProfileDao {
  //https://api.devio.org/uapi/fa/profile
  static get() async {
    ProfileRequest request = ProfileRequest();
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return ProfileMo.fromJson(result['data']);
  }
}
