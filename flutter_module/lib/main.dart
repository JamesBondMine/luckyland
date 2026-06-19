import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module/about_detail_page.dart';
import 'package:flutter_module/help_page.dart';
import 'package:flutter_module/home_page.dart';
import 'package:flutter_module/message_star_page.dart';
import 'package:flutter_module/mine_page.dart';
import 'package:flutter_module/register_select_page.dart';
import 'package:flutter_module/safe_setting_page.dart';
import 'package:flutter_module/sign_log_page.dart';
import 'package:flutter_module/user_info_edit_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const MethodChannel _bridgeChannel =
      MethodChannel('com.noa.flutter/bridge');

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    final String name = settings.name ?? '/';
    final Uri uri = Uri.parse(name);
    if (uri.path == '/aboutDetail') {
      final String title = uri.queryParameters['title'] ?? '详情';
      final String url = uri.queryParameters['url'] ?? '';
      return MaterialPageRoute(
        builder: (_) => AboutDetailPage(title: title, url: url),
        settings: settings,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/help': (context) => const HelpPage(),
        '/registerSelect': (context) => RegisterSelectPage(
              tap: (String value) {
                _bridgeChannel.invokeMethod('registerSelectTap', value);
              },
            ),
        '/home': (context) => HomePage(
              dataStr: '',
              tap: (String value) {},
            ),
        '/userEditInfo': (context) => UserEditInfoPage(
              dataStr: '',
              tap: (String value) {},
            ),
        '/safeSetting': (context) => SafeSettingPage(
              dataStr: '',
              tap: (String value) {},
            ),
        '/signLog': (context) => SignLogPage(
              dataStr: '',
              tap: (String value) {},
            ),
        '/messageStar': (context) => MessageStarPage(
              dataStr: '',
              tap: (String value) {},
            ),
        '/mine': (context) => MinePage(
              name: '',
              url: '',
              idStr: '',
              tap: (String value) {
                _bridgeChannel.invokeMethod('mineSelectTap', value);
              },
            ),
      },
      onGenerateRoute: _onGenerateRoute,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const MethodChannel _bridgeChannel =
      MethodChannel('com.noa.flutter/bridge');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _cardItem('服务协议', '服务协议内容'),
          Container(
            margin: const EdgeInsets.only(left: 16),
            height: 0.8,
            color: Colors.grey[300],
            width: double.infinity,
          ),
          _cardItem('隐私政策', '隐私政策内容'),
        ],
      ),
    ));
  }

  Widget _cardItem(String title, String content) {
    return InkWell(
      onTap: () async {
        final String url = title == '服务协议'
            ? 'https://niumowangai.top/lucky/#/lucky'
            : 'https://niumowangai.top/lucky/#/round';
        await _bridgeChannel.invokeMethod('openPolicyDetail', {
          'title': title,
          'url': url,
        });
      },
      child: Container(
          // color: Colors.green,
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
            )
          ])),
    );
  }
}
