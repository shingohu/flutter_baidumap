import 'package:fluwx/fluwx.dart' as fluwx;

class Share {
  static Share _instance;

  factory Share() => _getInstance();

  static Share get instance => _getInstance();

  static Share _getInstance() {
    if (_instance == null) {
      _instance = Share._();
    }
    return _instance;
  }

  Share._();

  init() {
    fluwx.registerWxApi();
  }

  ///分享微信小程序
  share2MineProgram() {
    String _webPageUrl = "http://www.baidu.com";
    String _thumbnail =
        "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534614311230&di=b17a892b366b5d002f52abcce7c4eea0&imgtype=0&src=http%3A%2F%2Fimg.mp.sohu.com%2Fupload%2F20170516%2F51296b2673704ae2992d0a28c244274c_th.png";
    String _title = "商信人脉地图";
    String _userName = "gh_d43f693ca31f";
    String _path = "/";
    String _description = "商信人脉地图小程序";
    var model = new fluwx.WeChatShareMiniProgramModel(
        webPageUrl: _webPageUrl,
        miniProgramType: fluwx.WXMiniProgramType.PREVIEW,
        path: _path,
        userName: _userName,
        title: _title,
        description: _description,
        thumbnail: _thumbnail);
    fluwx.shareToWeChat(model);
  }
}
