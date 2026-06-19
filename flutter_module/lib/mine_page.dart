import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module/mine_cell_item.dart';

class MinePage extends StatelessWidget {
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
  ValueChanged<String> tap;

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
                  tap('mineTouchIndex103');
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
                  tap('mineTouchIndex102');
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () {
                  tap('mineTouchIndex101');
                },
              ),
            ]),
            Row(children: [
              InkWell(
                onTap: () {
                  tap('mineTouchIndex104');
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
                  child: Image.network(
                    'https://gips1.baidu.com/it/u=3249564727,2553492563&fm=3074&app=3074&f=PNG?w=2048&h=2048',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('诸葛亮',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white)),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: '123456667677'));
                        tap('mineTouchIndex105');
                      },
                      child: Row(children: [
                        Text('123456667677',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white)),
                              Icon(Icons.copy, color: Colors.white,size: 16)
                      ])
                    )
                  ])),
              InkWell(
                onTap: () {
                  tap('mineTouchIndex100');
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

  Widget _listView(BuildContext context, String title, String content) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        MineCellItem(
          tag: "mineTouchIndex0",
          title: '我的团队',
          icon: 'tuandui',
          tap: (tag) {
            tap(tag);
          },
        ),
        _divider(),
        MineCellItem(
          tag: "mineTouchIndex1",
          title: '我的收藏',
          icon: 'shoucang',
          tap: (tag) {
            tap(tag);
          },
        ),
        MineCellItem(
          tag: "mineTouchIndex2",
          title: '黑名单',
          icon: 'heimingdan',
          tap: (tag) {
            tap(tag);
          },
        ),
        _divider(),
        MineCellItem(
          tag: "mineTouchIndex3",
          title: '应用语言',
          icon: 'yuyan',
          tap: (tag) {
            tap(tag);
          },
        ),
        MineCellItem(
          tag: "mineTouchIndex4",
          title: '安全设置',
          icon: 'anquanbaozhang',
          tap: (tag) {
            tap(tag);
          },
        ),
        MineCellItem(
          tag: "mineTouchIndex5",
          title: '隐私设置',
          icon: 'yinsi',
          tap: (tag) {
            tap(tag);
          },
        ),
        MineCellItem(
          tag: "mineTouchIndex6",
          title: '网络监测',
          icon: 'wangluo',
          tap: (tag) {
            tap(tag);
          },
        ),
        MineCellItem(
          tag: "mineTouchIndex7",
          title: '投诉与支持',
          icon: 'tousujianyi',
          tap: (tag) {
            tap(tag);
          },
        ),
        _divider(),
        MineCellItem(
          tag: "mineTouchIndex8",
          title: '关于',
          icon: 'guanyu',
          tap: (tag) {
            tap(tag);
          },
        ),
      ],
      // itemCount: _sections.length,
      // itemBuilder: (context, index) {
      //   final item = _sections[index];
      //   final title = item['title']!;
      //   final content = item['content']!;

      //   return InkWell(
      //     onTap: () {
      //       tap(item['id'] ?? 'flutter_mine_index0');
      //     },
      //     child: _cardItem(context, title, content, index),
      //   );
      // },
    );
  }

  // 分割线
  Widget _divider() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 10,
      color: const Color(0xFFE5E5E5),
    );
  }
}
