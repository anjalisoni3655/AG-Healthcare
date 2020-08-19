import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Videos extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _videoContainer('https://www.youtube.com/watch?v=Kf3Pz2aoIXE'),
          _videoContainer('https://www.youtube.com/watch?v=JfpECBWjMlo'),
          _videoContainer('https://www.youtube.com/watch?v=1vfrFSzFgo4'),
          _videoContainer('https://www.youtube.com/watch?v=AauNs2GIT7A'),
          _videoContainer('https://www.youtube.com/watch?v=03o1yjAq_2M'),
          _videoContainer('https://www.youtube.com/watch?v=YS_T3I1ps1w'),
        ],
      ),
    );
  }
}

_launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}


Widget _videoContainer(String url) {
  String video_id = url.split("=")[1];
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 30, 10),
    child: InkWell(
      onTap: () {
        _launchURL(url);
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(7)),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image(
                image: NetworkImage('https://img.youtube.com/vi/' +
                    video_id +
                    '/sddefault.jpg'),
              ),
            ),
            FaIcon(
              FontAwesomeIcons.youtube,
              color: Colors.red,
              size: 40,
            ),
          ],
        ),
      ),
    ),
  );
}