enum HttpMethod { GET, POST, DELETE }
// Basic Request (Rest full style)

abstract class HiBaseRequest {
  var pathParams;
  var useHttps = true;
  String authority() {
    return "api.devio.org";
  }

  HttpMethod httpMethod();
  String path();
  String url() {
    Uri uri;
    var pathstr = path();
    if (pathParams != null) {
      if (path().endsWith("/")) {
        pathstr = "${path()}$pathParams";
      } else {
        pathstr = "${path()}/$pathParams";
      }
    }
    // Switch from http to https
    if (useHttps) {
      uri = Uri.https(authority(), pathstr, params);
    } else {
      uri = Uri.http(authority(), pathstr, params);
    }
    print('uri:${uri.toString()}');
    return uri.toString();
  }

  bool needLogin();
  Map<String, String> params = Map();
  // Add params
  HiBaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  // Add header
  Map<String, dynamic> header = {};
  HiBaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }
}
