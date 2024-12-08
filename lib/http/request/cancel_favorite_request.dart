import 'basic_request.dart';
import 'favorite_request.dart';

class CancelFavoriteRequest extends FavoriteRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.DELETE;
  }
}
