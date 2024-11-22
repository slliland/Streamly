import '../../model/home_mo.dart';
import '../core/hi_net.dart';
import '../request/home_request.dart';

class HomeDao {
  //https://api.devio.org/uapi/fa/home/推荐?pageIndex=1&pageSize=10
  static get(String categoryName, {int pageIndex = 1, int pageSize = 1}) async {
    HomeRequest request = HomeRequest();
    // path params and request params have different types
    request.pathParams = categoryName;
    request.add("pageIndex", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return HomeMo.fromJson(result['data']);
  }
}
