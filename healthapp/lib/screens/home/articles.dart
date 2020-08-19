import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Articles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _articleContainer('https://dramitendo.com/an-overview-of-diabetes/',
              'https://dramitendo.com/wp-content/uploads/2020/07/diabetes.jpg'),
          _articleContainer(
              'https://dramitendo.com/precautions-for-thyroid-patients-dos-donts/',
              'https://dramitendo.com/wp-content/uploads/2020/07/thyroid.jpg'),
          _articleContainer(
              'https://dramitendo.com/what-you-should-know-about-hormones/',
              'https://dramitendo.com/wp-content/uploads/2020/07/dna.jpg'),
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

Widget _articleContainer(String url, String imgUrl) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 30, 10),
    child: InkWell(
      onTap: () {
        _launchURL(url);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Image(
          image: NetworkImage(imgUrl),
        ),
      ),
    ),
  );
}
