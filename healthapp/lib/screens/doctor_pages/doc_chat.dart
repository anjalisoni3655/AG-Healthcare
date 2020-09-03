import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/screens/doctor_pages/user_desc.dart';
import 'package:healthapp/screens/home_screen.dart';
import 'package:healthapp/widgets/full_photo.dart';
import 'package:healthapp/widgets/loading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:healthapp/components/const.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthapp/screens/call.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

int mobile;
final themeColor = Color(0xfff5a623);
TextStyle textStyle1 = TextStyle(
    color: Color(0xFFFFFFFF), fontSize: 15, fontWeight: FontWeight.w600);
TextStyle textStyle2 = TextStyle(
    color: Color(0xFF08134D), fontSize: 15, fontWeight: FontWeight.w600);

Future<void> onJoin(BuildContext context) async {
  // await for camera and mic permissions before pushing video page
  await _handleCameraAndMic();
  // push video page with given channel name

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CallPage(
        // if(globals.user.email=='dramitgoelhyd@gmail.com'){
        channelName: 'abcd',
        //TODO:  make channel name unique for two doctor and patient
        //channelName:

        role: ClientRole.Broadcaster,
      ),
    ),
  );
}

Future<void> _handleCameraAndMic() async {
  await Permission.camera.request();
  await Permission.microphone.request();
}

class DocChat extends StatefulWidget {
  static const id = "doc_chat";
  final String peerId;
  final String peerAvatar;
  final String peerName;
  final DocumentSnapshot bookingInfo;

  DocChat(
      {Key key,
      @required this.peerId,
      @required this.peerAvatar,
      @required this.peerName,
      @required this.bookingInfo})
      : super(key: key);

  @override
  _DocChatState createState() => _DocChatState();
}

class _DocChatState extends State<DocChat> {
  Widget _ongoingOrCompletedSubtitle(String type) {
    var _colorForSubtitle = Color(0xFFF3AB65);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Container(
                decoration: BoxDecoration(
                    color: _colorForSubtitle, shape: BoxShape.circle),
                height: 9,
                width: 9,
              ),
            ),
            Text(
              type,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: _colorForSubtitle,
                  fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot bookingInfo = widget.bookingInfo;

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: AppBar(
              backgroundColor: Color(0xFFF8F8F8),
              elevation: 0,
              title: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserDesc(
                                bookingInfo: widget.bookingInfo,
                              )));
                },
                splashColor: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Color(0xFFF8F8F8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image(
                          image: NetworkImage(widget.peerAvatar),
                          width: 40,
                        )),
                    title: Text(
                      widget.peerName.split(' ')[0],
                      style: textStyle2,
                    ),
                    subtitle: _ongoingOrCompletedSubtitle('Ongoing'),
                  ),
                ),
              ),
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.blue[700],
                  )),
              actions: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      color: Color(0xFFDFE9F7),
                      borderRadius: BorderRadius.circular(7)),
                  child: GestureDetector(
                    onTap: () {
                      print('nio');
                      print(widget.bookingInfo.data);
                      FlutterPhoneDirectCaller.callNumber(
                          widget.bookingInfo.data['phone'].toString());
                    },
                    child: Icon(
                      Icons.call,
                      size: 24,
                      color: Color(0xFF007CC2),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10, right: 20),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      color: Color(0xFFDFE9F7),
                      borderRadius: BorderRadius.circular(7)),
                  child: GestureDetector(
                    onTap: () {
                      onJoin(context);
                    },
                    child: Icon(
                      Icons.videocam,
                      size: 24,
                      color: Color(0xFF007CC2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: DocChatScreen(
          peerId: widget.peerId,
          peerAvatar: widget.peerAvatar,
        ),
      ),
    );
  }
}

class DocChatScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;

  DocChatScreen({Key key, @required this.peerId, @required this.peerAvatar})
      : super(key: key);

  @override
  State createState() =>
      DocChatScreenState(peerId: peerId, peerAvatar: peerAvatar);
}

class DocChatScreenState extends State<DocChatScreen> {
  DocChatScreenState(
      {Key key, @required this.peerId, @required this.peerAvatar});

  String peerId;
  String peerAvatar;
  String id;

  var listMessage;
  String groupDocChatId;
  SharedPreferences prefs;

  File imageFile;
  bool isLoading;

  String imageUrl;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);

    groupDocChatId = '';

    isLoading = false;

    imageUrl = '';

    readLocal();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {});
    }
  }

  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    if (id.hashCode <= peerId.hashCode) {
      groupDocChatId = '$id-$peerId';
    } else {
      groupDocChatId = '$peerId-$id';
    }

    Firestore.instance
        .collection('user')
        .document(id)
        .updateData({'chattingWith': peerId});

    setState(() {});
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupDocChatId)
          .collection(groupDocChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == id) {
      // Right (my message)
      return Row(
        children: <Widget>[
          document['type'] == 0
              // Text
              ? Container(
                  constraints: BoxConstraints(maxWidth: 250),
                  child: Text(
                    document['content'],
                    style: textStyle1,
                  ),
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      color: Color(0xFF408AEB),
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                      right: 10.0),
                )
              : document['type'] == 1
                  // Image
                  ? Container(
                      child: FlatButton(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(themeColor),
                              ),
                              width: 200.0,
                              height: 200.0,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: greyColor2,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Material(
                              child: Image.asset(
                                'assets/images/img_not_available.jpeg',
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: document['content'],
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FullPhoto(url: document['content'])));
                        },
                        padding: EdgeInsets.all(0),
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                          right: 10.0),
                    )
                  // Sticker
                  : Container(
                      child: Image.asset(
                        'assets/images/${document['content']}.gif',
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                          right: 10.0),
                    ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft(index)
                    ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(themeColor),
                            ),
                            width: 35.0,
                            height: 35.0,
                            padding: EdgeInsets.all(10.0),
                          ),
                          imageUrl: peerAvatar,
                          width: 35.0,
                          height: 35.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(width: 35.0),
                document['type'] == 0
                    ? Container(
                        constraints: BoxConstraints(maxWidth: 250),
                        child: Text(
                          document['content'],
                          style: textStyle2,
                        ),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Color(0xFFF8F8F8),
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    : document['type'] == 1
                        ? Container(
                            child: FlatButton(
                              child: Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          themeColor),
                                    ),
                                    width: 200.0,
                                    height: 200.0,
                                    padding: EdgeInsets.all(70.0),
                                    decoration: BoxDecoration(
                                      color: greyColor2,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Material(
                                    child: Image.asset(
                                      'assets/images/img_not_available.jpeg',
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  imageUrl: document['content'],
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FullPhoto(
                                            url: document['content'])));
                              },
                              padding: EdgeInsets.all(0),
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          )
                        : Container(
                            child: Image.asset(
                              'assets/images/${document['content']}.gif',
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                            margin: EdgeInsets.only(
                                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                                right: 10.0),
                          ),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document['timestamp']))),
                      style: TextStyle(
                          color: greyColor,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    Firestore.instance
        .collection('users')
        .document(id)
        .updateData({'chattingWith': null});
    Navigator.pop(context);

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: WillPopScope(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                // List of messages
                buildListMessage(),
                // Input content
                buildInput(),
              ],
            ),

            // Loading
            buildLoading()
          ],
        ),
        onWillPop: onBackPress,
      ),
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? const Loading() : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          // Button send image
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color(0xFFF8F8F8),
            ),
            child: IconButton(
              icon: FaIcon(FontAwesomeIcons.link),
              onPressed: getImage,
              color: Color(0xFF8F8F8F),
              iconSize: 25,
            ),
          ),

          // Edit text
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xFFF8F8F8),
              ),
              child: TextField(
                style: textStyle2,
                controller: textEditingController,
                cursorColor: Colors.grey[400],
                cursorWidth: 0.8,
                cursorRadius: Radius.circular(10),
                decoration: InputDecoration.collapsed(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: Color(0xFF8F8F8F),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          InkWell(
            onTap: () => onSendMessage(textEditingController.text, 0),
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xFF408AEB),
                  borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.only(right: 15),
              child: Row(
                children: [
                  Transform.rotate(
                    angle: -45 * math.pi / 180,
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        Icons.send,
                        size: 20,
                      ),
                      onPressed: () =>
                          onSendMessage(textEditingController.text, 0),
                      color: Colors.white,
                    ),
                  ),
                  Text('Send', style: textStyle1),
                ],
              ),
            ),
          ),
        ],
      ),
      width: double.infinity,
      color: Colors.white,
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupDocChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('messages')
                  .document(groupDocChatId)
                  .collection(groupDocChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(themeColor)));
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }
}
