import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () async {
            widget.tap('back');
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: _bodyView(context),
    );
  }

  Widget _bodyView(BuildContext context) {
    return Column(
      children: [
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
          padding: EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 20,
                color: colorScheme.primary,
              ),
              SizedBox(height: 30),
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
