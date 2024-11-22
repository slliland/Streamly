import 'package:flutter/material.dart';
import 'package:streamly/model/home_mo.dart';
import 'package:streamly/widget/hi_banner.dart';

class HomeTabPage extends StatefulWidget {
  final String name;
  final List<BannerMo>? bannerList;

  const HomeTabPage({Key? key, required this.name, this.bannerList})
      : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  @override
  Widget build(BuildContext context) {
    print('HomeTabPage bannerList: ${widget.bannerList}');
    return Container(
      child: ListView(
        children: [
          if (widget.bannerList != null && widget.bannerList!.isNotEmpty)
            _banner()
          else
            Center(
              child: Text("No banners available"),
            )
        ],
      ),
    );
  }

  _banner() {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: HiBanner(widget.bannerList!),
    );
  }
}
