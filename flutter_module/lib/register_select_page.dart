import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module/global_color.dart';

class RegisterSelectPage extends StatefulWidget {
  RegisterSelectPage({Key? key, required this.tap}) : super(key: key);
  ValueChanged<String> tap;

  @override
  createState() => _RegisterSelectPageState();
}

class _RegisterSelectPageState extends State<RegisterSelectPage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:  const Color.fromRGBO(238, 240, 240, 1),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () async {
            widget.tap('back');
          },
        ),
      ),
      backgroundColor:  const Color.fromRGBO(238, 240, 240, 1),
      body: _bodyView(context),
    );
  }

  Widget _bodyView(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        _cardItem(context, Icons.email_outlined, '邮箱注册', '通过邮箱和验证码注册', () {
          widget.tap('registerDetail0');
        }),
        _cardItem(context, Icons.phone_android, '手机号注册', '通过手机号和验证码注册', () {
          widget.tap('registerDetail1');
        }),
        _cardItem(context, Icons.account_circle_outlined, '账号注册', '通过账号和密码注册',
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
          padding: const EdgeInsets.only(left: 12, right: 12, top: 20, bottom: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 20,
                color: Global.primaryColor,
                
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
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
                    const SizedBox(height: 12),
                    Text(
                      content,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.45,
                        color: colorScheme.onSurface.withOpacity(0.85),
                      ),
                    ),
                  ])),
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
