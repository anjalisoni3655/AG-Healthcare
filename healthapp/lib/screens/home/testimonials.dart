import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<String> testimonials = [
  'I am thankful to Dr. Amit Goel as before visiting him my blood sugar levels always above 500 now I happy and proud to tell that with the doctors advice now my sugar values in the fasting are less than 130. I am glad that I found such a nice, cooperative, friendly doctor for my sugar control.',
  'My heartfelt thanks to Dr.AmitGoel for saving my life as I was unable to walk and had continuous vomiting . Met the doctor he had suggested me only a few tests and I was diagnosed with primary adrenal insufficiency and I am now happy with his treatment and support and meet him regularly. I strongly recommend him to others.',
  'Its indeed a pleasure and my sincere thanks to the doctor for controlling my sugar while I had visited almost all doctors. But in my first visit to the doctor I saw a dedicated approach and  I was explained that my technique of taking insulin was not correct and a few modifications of the dose. I am now following his technique & the dose with this my sugars are well under control.',
  'I had first met the doctor in Bangalore and now meeting him in Hyderabad . I have got the most satisified treatment for my prolactin tumor from  him due to which I travel from Bengal to seek his advice. I strongly recommend to visit this doctor for his professional advice and patience to listen to a patient.',
];
List<String> signatures = [
  'Mr. Nagi Reddy',
  'Mrs. Geetha Sujatha',
  'Mr. Mahender Aggarwal',
  'Mrs. Nabnita Das',
];

class Testimonials extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          for (var i = 0; i < 4; i++)
            _testimonialContainer(testimonials[i], signatures[i], context),
        ],
      ),
    );
  }
}

Widget _testimonialContainer(String t, String s, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            spreadRadius: 0.5,
            blurRadius: 10, //extend the shadow
          )
        ],
      ),
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 0.89,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FaIcon(
            FontAwesomeIcons.quoteLeft,
            color: Colors.blue[700],
          ),
          Container(
              padding: EdgeInsets.all(3),
              child: Text(
                t,
                style: TextStyle(color: Color(0xFF8F8F8F)),
              )),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                '- ' + s,
                style: TextStyle(color: Color(0xFF08134D)),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
