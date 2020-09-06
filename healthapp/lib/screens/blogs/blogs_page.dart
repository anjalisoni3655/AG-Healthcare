import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:healthapp/authentication/user.dart' as globals;

class BlogsPage extends StatefulWidget {
  @override
  static const id = "blogs_page";

  _BlogsPageState createState() => _BlogsPageState();
}

class _BlogsPageState extends State<BlogsPage> {
  @override
  Widget build(BuildContext context) {
    print('pres222');
    globals.getPrescriptionByPatient();

    return SafeArea(
      child: Material(
        
        color: Color(0xFFF8F8F8),
        child: Container(
          color: Color(0xFFF8F8F8),
          height: double.infinity,
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _articleContainer(
                    'https://dramitendo.com/an-overview-of-diabetes/',
                    'https://dramitendo.com/wp-content/uploads/2020/07/diabetes.jpg',
                    'An overview of diabetes'),
                _articleContainer(
                    'https://dramitendo.com/precautions-for-thyroid-patients-dos-donts/',
                    'https://dramitendo.com/wp-content/uploads/2020/07/thyroid.jpg',
                    'Precautions for thyroid patients'),
                _articleContainer(
                    'https://dramitendo.com/what-you-should-know-about-hormones/',
                    'https://dramitendo.com/wp-content/uploads/2020/07/dna.jpg',
                    'What you should know about hormones'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _launchURL(url) async {
    await FlutterWebBrowser.openWebPage(
        url: url, androidToolbarColor: Colors.blue[700]);
  }

  Widget _articleContainer(String url, String imgUrl, String title) {
    return InkWell(
      onTap: () {
        _launchURL(url);
      },
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Image(
              image: NetworkImage(imgUrl),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Text(
              title,
            //  textAlign: TextAlign.right,
              style: TextStyle(
               
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Color(0xFF08134D),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
