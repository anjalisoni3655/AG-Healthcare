import 'package:flutter/material.dart';

List<String> images = [
  'adrenal',
  'thyroid',
  'diabetes',
  'menstrual',
  'children',
  'parathyroid'
];

// stores ExpansionPanel state information
class Item {
  Item({
    this.id,
    this.expandedValue,
    this.headerValue,
    this.imageUrl,
  });

  int id;
  String expandedValue;
  String headerValue;
  String imageUrl;
}

List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    String img = images[index];
    String header = img[0].toUpperCase() + img.substring(1);
    String desc =
        'Adrenal Insufficiency, Adrenal Tumors , Cushing Syndrome etc';
    return Item(
      id: index,
      headerValue: '$header Disorders',
      expandedValue: '$desc',
      imageUrl: 'assets/images/$img.png',
    );
  });
}

class MyAccordionWidget extends StatefulWidget {
  MyAccordionWidget({Key key}) : super(key: key);

  @override
  _MyAccordionWidgetState createState() => _MyAccordionWidgetState();
}

class _MyAccordionWidgetState extends State<MyAccordionWidget> {
  List<Item> _data = generateItems(6);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList.radio(
      dividerColor: Colors.white,
      animationDuration: Duration(milliseconds: 800),
      children: _data.map<ExpansionPanelRadio>((Item item) {
        return ExpansionPanelRadio(
            value: item.id,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  leading: Image(
                    image: AssetImage(item.imageUrl),
                    height: 35,
                    width: 35,
                  ),
                  title: Text(
                    item.headerValue,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF08134D)),
                  ),
                ),
              );
            },
            body: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                subtitle: Text(
                  item.expandedValue,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8F8F8F)),
                ),
              ),
            ));
      }).toList(),
    );
  }
}
