import 'package:flutter/material.dart';

/// This Widget is the main application widget.
class AppointmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MyStatefulWidget(),
      ),
    );
  }
}

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
    String header=img[0].toUpperCase()+img.substring(1);
    String desc='Adrenal Insufficiency, Adrenal Tumors , Cushing Syndrome etc';
    return Item(
      id: index,
      headerValue: '$header Disorders',
      expandedValue: '$desc',
      imageUrl: 'assets/images/$img.png',
    );
  });
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
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
      children: _data.map<ExpansionPanelRadio>((Item item) {
        return ExpansionPanelRadio(
            value: item.id,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage(item.imageUrl),
                    height: 50,
                    width: 50,
                  ),
                ),
                title: Text(item.headerValue),
              );
            },
            body: ListTile(
                subtitle: Text(item.expandedValue),
                onTap: () {}));
      }).toList(),
    );
  }
}
