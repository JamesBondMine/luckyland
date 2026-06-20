import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module/mine_cell_item.dart';

class MinePage extends StatefulWidget {
  MinePage(
      {Key? key,
      required this.name,
      required this.url,
      required this.idStr,
      required this.tap})
      : super(key: key);

  final String name;
  final String url;
  final String idStr;
  final ValueChanged<String> tap;

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  static const MethodChannel _bridgeChannel =
      MethodChannel('com.noa.flutter/bridge');

  late String _name;
  late String _avatarPath;
  late String _idStr;

  @override
  void initState() {
    super.initState();
    _name = widget.name;
    _avatarPath = widget.url;
    _idStr = widget.idStr;
    _bridgeChannel.setMethodCallHandler(_handleNativeCall);
    _bridgeChannel.invokeMethod('mineReady');
  }

  @override
  void dispose() {
    _bridgeChannel.setMethodCallHandler(null);
    super.dispose();
  }

  Future<dynamic> _handleNativeCall(MethodCall call) async {
    if (call.method != 'initMineUserInfo') {
      return null;
    }
    final dynamic args = call.arguments;
    if (args is! String || args.isEmpty) {
      return null;
    }
    final Map<String, dynamic> userInfo =
        Map<String, dynamic>.from(jsonDecode(args) as Map);
    if (!mounted) {
      return null;
    }
    setState(() {
      _name = userInfo['userName']?.toString() ?? '';
      _idStr = userInfo['id']?.toString() ?? '';
      _avatarPath = userInfo['userAvatar']?.toString() ?? '';
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _bodyView(context),
    );
  }

  Widget _bodyView(BuildContext context) {
    return Stack(children: [
      Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: 230 + MediaQuery.of(context).padding.top,
          child: _headerView(context)),
      Positioned(
          left: 0,
          right: 0,
          top: 160 + MediaQuery.of(context).padding.top,
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(top: 16),
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: _listView(context, 'title', 'content'),
          )),
    ]);
  }

  Widget _headerView(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        color: Color(0xffEB5C5C),
        child: SafeArea(
            child: Column(
          children: [
            Row(children: [
              IconButton(
                icon: Image.asset('images/qiandao-2.png',width:20,height:20,),
                onPressed: () {
                  widget.tap('mineTouchIndex103');
                },
              ),
              SizedBox(width: 48),
              const Expanded(
                child: Text(
                  '我的',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.qr_code_scanner_sharp,
                    color: Colors.white),
                onPressed: () {
                  widget.tap('mineTouchIndex102');
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () {
                  widget.tap('mineTouchIndex101');
                },
              ),
            ]),
            Row(children: [
              InkWell(
                onTap: () {
                  widget.tap('mineTouchIndex104');
                },
                child: Container(
                  width: 80,
                  height: 80,
                  clipBehavior: Clip.hardEdge,
                  margin: const EdgeInsets.only(left: 16, right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: _buildAvatarImage(),
                ),
              ),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(_name.isNotEmpty ? _name : '--',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white)),
                    InkWell(
                      onTap: () {
                        if (_idStr.isNotEmpty) {
                          Clipboard.setData(ClipboardData(text: _idStr));
                        }
                        widget.tap('mineTouchIndex105');
                      },
                      child: Row(children: [
                        Text(_idStr.isNotEmpty ? _idStr : '--',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white)),
                              Icon(Icons.copy, color: Colors.white,size: 16)
                      ])
                    )
                  ])),
              InkWell(
                onTap: () {
                  widget.tap('mineTouchIndex100');
                },
                child: Container(
                  width: 120,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Text('编辑资料'),
                ),
              )
            ])
          ],
        )));
  }

  Widget _buildAvatarImage() {
    if (_avatarPath.isEmpty) {
      return _defaultAvatar();
    }
    return Image.file(
      File(_avatarPath),
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _defaultAvatar(),
    );
  }

  Widget _defaultAvatar() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey[200],
      child: const Icon(Icons.person, size: 40, color: Colors.grey),
    );
  }

  Widget _listView(BuildContext context, String title, String content) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        MineCellItem(
          tag: "mineTouchIndex0",
          title: '我的团队',
          icon: 'tuandui',
          tap: (tag) {
            widget.tap(tag);
          },
        ),
        _divider(),
        MineCellItem(
          tag: "mineTouchIndex1",
          title: '我的收藏',
          icon: 'shoucang',
          tap: (tag) {
            widget.tap(tag);
          },
        ),
        MineCellItem(
          tag: "mineTouchIndex2",
          title: '黑名单',
          icon: 'heimingdan',
          tap: (tag) {
            widget.tap(tag);
          },
        ),
        _divider(),
        MineCellItem(
          tag: "mineTouchIndex3",
          title: '应用语言',
          icon: 'yuyan',
          tap: (tag) {
            widget.tap(tag);
          },
        ),
        MineCellItem(
          tag: "mineTouchIndex4",
          title: '安全设置',
          icon: 'anquanbaozhang',
          tap: (tag) {
            widget.tap(tag);
          },
        ),
        MineCellItem(
          tag: "mineTouchIndex5",
          title: '隐私设置',
          icon: 'yinsi',
          tap: (tag) {
            widget.tap(tag);
          },
        ),
        MineCellItem(
          tag: "mineTouchIndex6",
          title: '网络监测',
          icon: 'wangluo',
          tap: (tag) {
            widget.tap(tag);
          },
        ),
        MineCellItem(
          tag: "mineTouchIndex7",
          title: '投诉与支持',
          icon: 'tousujianyi',
          tap: (tag) {
            widget.tap(tag);
          },
        ),
        _divider(),
        MineCellItem(
          tag: "mineTouchIndex8",
          title: '关于',
          icon: 'guanyu',
          tap: (tag) {
            widget.tap(tag);
          },
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 10,
      color: const Color(0xFFE5E5E5),
    );
  }
}
