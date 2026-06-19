

import 'package:flutter/material.dart';

class MineCellItem extends StatelessWidget {
  MineCellItem(
      {Key? key,
      required this.icon,
      required this.tag,
      required this.title,
      required this.tap
      }
  ):super(key: key);

  final String icon;
  final String tag;
  final String title;
  final ValueChanged<String> tap;



  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        tap(tag);
      },
      child: Container( 
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        child: Row(
          children: [
            Image.asset('images/$icon.png',width: 20, height: 20),
            SizedBox(width: 8),
            Text(title, style: TextStyle(fontSize: 15, color: Color(0xff333333), fontWeight: FontWeight.w500)),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 12),
          ],
        ),
      ),
    );
  }
  
}