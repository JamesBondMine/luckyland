import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutDetailPage extends StatefulWidget {
  const AboutDetailPage({Key? key, required this.title, required this.url})
      : super(key: key);

  final String title;
  final String url;

  @override
  _AboutDetailPageState createState() => _AboutDetailPageState();
}

class _AboutDetailPageState extends State<AboutDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => SystemNavigator.pop(),
        ),
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SelectableText(
          widget.url,
          style: const TextStyle(fontSize: 16, height: 1.4),
        ),
      ),
    );
  }
}
