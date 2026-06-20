import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SafeSettingPage extends StatefulWidget {
  SafeSettingPage({Key? key, required this.dataStr, required this.tap})
      : super(key: key);
  ValueChanged<String> tap;
  final String dataStr;

  @override
  createState() => _SafeSettingPageState();
}

class _SafeSettingPageState extends State<SafeSettingPage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(238, 240, 240, 1),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () async {
            widget.tap('back');
          },
        ),
      ),
      backgroundColor: const Color.fromRGBO(238, 240, 240, 1),
      body: _bodyView(context),
    );
  }

  Widget _bodyView(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        _cardItem(context, Icons.email_outlined, '修改密码', '通过邮箱和验证码注册', () {
          widget.tap('registerDetail0');
        }),
        _cardItem(context, Icons.phone_android, '手势图案解锁', '关闭', () {
          widget.tap('registerDetail1');
        }),
        _cardItem(context, Icons.account_circle_outlined, '设备安全码', '关闭',
            () {
          widget.tap('registerDetail2');
        })
      ],
    );
  }

  Widget _cardItem(BuildContext context, IconData? icon, String title,
      String content, VoidCallback onTap) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
          padding:
              const EdgeInsets.only(left: 12, right: 12, top: 20, bottom: 20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                  color: colorScheme.onSurface,
                ),
              ),
              Spacer(),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                  color: colorScheme.onSurface,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
            ],
          ),
        ));
  }
}
