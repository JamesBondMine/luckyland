import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserEditInfoPage extends StatefulWidget {
  UserEditInfoPage(
      {Key? key,
      required this.dataStr,
      required this.tap})
      : super(key: key);

  final String dataStr;
  ValueChanged<String> tap;


  @override
  createState() => _UserEditInfoPageState();

}
class _UserEditInfoPageState extends State<UserEditInfoPage> {

  @override
  initState() {
    super.initState();
  }

  static const List<Map<String, String>> _sections = [
    {
      'title': '为什么需要进行网络设置？',
      'id': 'flutter_mine_index0',
      'content':
          '可以通过客户端随时随地享受数据服务的存储和管理。服务器归属于私有化部署的经营主体，只有经过经营主体许可的人员才能使用，安全性更高、私密性更强，提供非常好的信息安全服务。',
    },
    {
      'title': '一、加入服务器',
      'id': 'flutter_mine_index1',
      'content':
          '登录账户时需要加入服务器，以便您能精准找到所属企业或服务主体，支持邀请码、域名加入服务器。邀请码、域名需要您与平台客服人员进行联系或者由公司内部人员告知。服务器登录后，需填写账号密码完成登录，第二次登录不需要再次进行邀请码设置。',
    },
    {
      'title': '二、输入规范',
      'id': 'flutter_mine_index2',
      'content': '邀请码方式：100000\n域名方式：xxx.com（系统自动匹配http://或https://）',
    },
  ];

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
          height: 300,
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: Column(children: [

                Image.asset(
                  'images/logo.jpg',
                  fit: BoxFit.fill,
                  height: 100,
                )
                ,
                Text('编辑用户信息')
              ]))),
      Positioned(
          left: 0,
          right: 0,
          top: 300,
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
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

  Widget _listView(BuildContext context, String title, String content) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      itemCount: _sections.length,
      itemBuilder: (context, index) {
        final item = _sections[index];
        final title = item['title']!;
        final content = item['content']!;

        return InkWell(
          onTap: () {
            widget.tap(item['id'] ?? 'flutter_mine_index0');
          },
          child: _cardItem(context, title, content, index),
        );
      },
    );
  }

  Widget _cardItem(
      BuildContext context, String title, String content, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: EdgeInsets.only(top: index == 0 ? 0 : 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: index == 0 ? 8 : 20),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.35,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.45,
              color: colorScheme.onSurface.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}
