/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wego/entities/user_entity.dart';
import 'package:wego/features/messanger/stuff/messanger_services.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/widgets/background_widget.dart';

class MessagesScreen extends StatefulWidget {
  final UserEntity currentUser;
  final QueryDocumentSnapshot currentRoomItem;

  MessagesScreen({required this.currentUser, required this.currentRoomItem});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with TickerProviderStateMixin {
  TextEditingController messageController = TextEditingController();
  MessengerServices messengerServices = MessengerServices();
  late Stream chatMessageStream;
  final List<MessageTile> _messages = <MessageTile>[];

  @override
  void initState() {
    super.initState();
    print("----> widget.currentRoomItem.id = ${widget.currentRoomItem.id}");
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black.withOpacity(0.9),
            height: height,
            width: width,
          ),
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                  child: Row(
                    children: [
                      InkWell(
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: lightColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Center(
                              child: Image.asset(
                                "assets/images/icons/left-arrow.png",
                                width: 18,
                                height: 18,
                              ),
                            ),
                          ),
                        ),
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.currentRoomItem['users'][1],
                        style: TextStyle(fontSize: 22, color: lightColor),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Flexible(child: chatMessageListStreamBuilder()),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0.0, left: 0.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 50,
                            color: Colors.black,
                            width: MediaQuery.of(context).size.width,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    height: 50.0,
                                    color: Colors.black,
                                    child: Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, top: 2.5),
                                        child: new TextField(
                                          textAlign: TextAlign.left,
                                          controller: messageController,
                                          decoration: new InputDecoration(
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                            hintText: ' Enter message',
                                          ),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: primaryColor),
                                      child: GestureDetector(
                                        onTap: () {
                                          // sendMessageFunction();
                                        },
                                        child: Icon(
                                          Icons.share_location_outlined,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration:
                                        BoxDecoration(color: primaryColor),
                                    child: GestureDetector(
                                      onTap: () {
                                        sendMessageFunction();
                                      },
                                      child: Icon(
                                        Icons.send,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget chatMessageListStreamBuilder() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chat_rooms")
          .doc(widget.currentRoomItem.id)
          .collection("messages")
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        var items = snapshot.data == null ? [] : snapshot.data!.docs;
        if (!snapshot.hasData) {
          return const Center(
            child: SizedBox(
                width: 30, height: 30, child: CircularProgressIndicator()),
          );
        } else if (items.isEmpty) {
          return const Center(
            child: Text(
              "Let's start your first message!",
              style: TextStyle(color: Colors.grey),
            ),
          );
        } else {
          return ListView.builder(
              reverse: true,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                print(index);
                return Column(
                  children: <Widget>[
                    MessageTile(
                        message: items[index]["message"],
                        isSendByMe:
                            items[index]["sendBy"] == widget.currentUser.email
                                ? true
                                : false,
                        animationController: AnimationController(
                            vsync: this,
                            duration: (Duration(milliseconds: 700)))),
                    ((items.length - 1) == index)
                        ? Container(
                            height: 65,
                            width: MediaQuery.of(context).size.width,
                          )
                        : Container(),
                  ],
                );
              });
        }
      },
    );
  }

  sendMessageFunction() async {
    if (messageController.text.trim().isNotEmpty) {
      print(messageController.text);

      Map<String, dynamic> messageMap = {
        'message': messageController.text.trim(),
        'sendBy': widget.currentUser.email,
        'date': DateTime.now().millisecondsSinceEpoch,
        "budget": "",
        "period": "",
        "type": "text"
      };
      await FirebaseFirestore.instance
          .collection("chat_rooms")
          .doc(widget.currentRoomItem.id)
          .collection("messages")
          .add(messageMap).catchError((ex) {
        print("error in add conversation message : $ex");
      });

      //FocusScope.of(context).unfocus();

      MessageTile message = new MessageTile(
        message: messageController.text.trim(),
        isSendByMe: true,
        animationController: AnimationController(
            vsync: this, duration: (Duration(milliseconds: 700))),
      );
      setState(() {
        _messages.insert(0, message);
      });
      message.animationController.forward();
      messageController.clear();
    }
  }

}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  final AnimationController animationController;

  MessageTile(
      {required this.message,
      required this.isSendByMe,
      required this.animationController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.only(
          left: isSendByMe ? 0.0 : 8.0, right: isSendByMe ? 8.0 : 0.0),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16.0),
        decoration: BoxDecoration(
          color: isSendByMe? primaryColor : subLightColor,
            borderRadius: isSendByMe
                ? BorderRadius.only(
                    bottomRight: Radius.circular(0),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  )
                : BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  )),
        child: Text(
          message.toString(),
          style: TextStyle(
            color: isSendByMe ? Colors.white : Colors.black,
            fontFamily: "Abel",
          ),
        ),
      ),
    );
  }
}
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wego/entities/user_entity.dart';
import 'package:wego/features/messanger/stuff/messanger_services.dart';
import '../../../utils/constants/colors.dart';
import '../../pay_page.dart';
import 'create_offer_sheet_page.dart';

enum EntryPoint { messenger, externalPoint }

class MessagesScreen extends StatefulWidget {
  final UserEntity currentUser;
  final QueryDocumentSnapshot? currentRoomItem;
  final EntryPoint entryPoint;

  //

  final String? email;

  MessagesScreen(
      {required this.currentUser,
      this.currentRoomItem,
      this.email,
      required this.entryPoint});

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with TickerProviderStateMixin {
  final TextEditingController _txtControllerMessage =
      new TextEditingController();
  final List<ChatMessage> _listMessage = [];
  MessengerServices messengerServices = MessengerServices();

  dynamic externalEntryDocument;

  bool isLoadingChat = false;

  @override
  void initState() {
    super.initState();
    // getData();
    if (widget.entryPoint == EntryPoint.externalPoint) {
      setState(() {
        isLoadingChat = true;
      });
      checkRoomIsExists();
    }
  }

  checkRoomIsExists() async {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('chat_rooms');
    String roomName = getChatRoomID(widget.email!, widget.currentUser.email);
    QuerySnapshot querySnapshot = await _collectionRef.get();
    List allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print("----> allData[0] = ${allData[0].toString()}");
    bool isExists =
        allData.where((element) => element['chatroom'] == roomName).isNotEmpty;
    if (isExists) {
      final roomDocument =
          allData.where((element) => element['chatroom'] == roomName).first;
      if (roomDocument != null) {
        print("------> roomDocument = ${roomDocument['messages']}");
        setState(() {
          externalEntryDocument = roomDocument;
          isLoadingChat = false;
        });
      } else {
        setState(() {
          isLoadingChat = false;
        });
      }
    } else {
      setState(() {
        isLoadingChat = false;
      });
    }
  }

  /*Future<void> getData() async {
    CollectionReference _collectionRef = FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(widget.currentRoomItem.id)
        .collection("messages");
    QuerySnapshot querySnapshot = await _collectionRef.get();
    List allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(allData);
    for (var item in allData) {
      print("----> item = $item");
      setState(() {
        _listMessage.add(ChatMessage(
            message: item['message'],
            animationController: new AnimationController(
              duration: new Duration(milliseconds: 200),
              vsync: this,
            ),
            isSendByMe: item['sendBy'] == widget.currentUser.email));
      });
    }
    print(allData);
  }*/

  @override
  void dispose() {
    for (ChatMessage message in _listMessage)
      message.animationController.dispose();
    super.dispose();
  }

  getCorrectEmail(List users){
    if(users[0] == widget.currentUser.email){
      return users[1];
    } else {
      return users[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            color: subBlackLight,
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0, bottom: 16, top: 16),
              child: Row(
                children: [
                  InkWell(
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: lightColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Center(
                          child: Image.asset(
                            "assets/images/icons/left-arrow.png",
                            width: 18,
                            height: 18,
                          ),
                        ),
                      ),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.entryPoint == EntryPoint.messenger
                            ? getCorrectEmail(widget.currentRoomItem!['users']) // widget.currentRoomItem!['users'][1]
                            : widget.email!,
                        style: TextStyle(fontSize: 22, color: lightColor),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Current status:',
                          style: TextStyle(
                              fontSize: 12,
                              color: lightColor,
                              fontFamily: "PTSansNarrow"),
                          children: [
                            TextSpan(
                                text: ' online',
                                style: TextStyle(
                                    color: primaryColor,
                                    fontFamily: "PTSansNarrow")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: new Column(
              children: <Widget>[
                /*new Flexible(
                  child: new ListView.builder(
                    padding: new EdgeInsets.all(8.0),
                    reverse: true,
                    itemCount: _listMessage.length,
                    itemBuilder: (BuildContext context, int index) {
                      print("--> _listMessage = ${_listMessage.length}");
                      return Text("${_listMessage[index].message}");
                    },
                  ),
                ),*/
                Flexible(child: chatMessageListStreamBuilder()),
                new Divider(
                  height: 10.0,
                ),
                new Container(
                  decoration:
                      new BoxDecoration(color: Theme.of(context).cardColor),
                  child: _buildCompotionInput(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget chatMessageListStreamBuilder() {
    return isLoadingChat
        ? const Center(
            child: SizedBox(
                width: 30, height: 30, child: CircularProgressIndicator()),
          )
        : widget.currentRoomItem == null && externalEntryDocument == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/applause.png',
                    height: MediaQuery.of(context).size.width * 0.5,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Let's start your first message!",
                    style: TextStyle(color: Colors.grey, fontSize: 17),
                  ),
                ],
              )
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chat_rooms")
                    .doc(getTruthDocRoom())
                    .collection("messages")
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  var items = snapshot.data == null ? [] : snapshot.data!.docs;
                  print("----> itemssss = ${items.length}");
                  if (!snapshot.hasData) {
                    return const Center(
                      child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator()),
                    );
                  } else if (items.isEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/applause.png',
                          height: MediaQuery.of(context).size.width * 0.5,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Let's start your first message!",
                          style: TextStyle(color: Colors.grey, fontSize: 17),
                        ),
                      ],
                    );
                  } else {
                    return ListView.builder(
                        reverse: true,
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          print(index);
                          return Column(
                            children: <Widget>[
                              ChatMessage(
                                message: items[index]["message"],
                                isSendByMe: items[index]["sendBy"] ==
                                        widget.currentUser.email
                                    ? true
                                    : false,
                                animationController: AnimationController(
                                    vsync: this,
                                    duration: (Duration(milliseconds: 700))),
                                messageDate: items[index]['date'],
                                messageType: items[index]['type'],
                                period: items[index]['period'],
                                budget: items[index]['budget'],
                                service: items[index]['service'],
                                onCancel: () {
                                  if (widget.currentRoomItem == null) {
                                    if (externalEntryDocument == null) {
                                      String roomName = getChatRoomID(
                                          widget.email!,
                                          widget.currentUser.email);
                                      messengerServices.deleteOffer(
                                          roomName, items[index].id);
                                    } else {
                                      messengerServices.deleteOffer(
                                          externalEntryDocument!['chatroom'],
                                          items[index].id);
                                    }
                                  } else {
                                    messengerServices.deleteOffer(
                                        widget.currentRoomItem!.id,
                                        items[index].id);
                                  }
                                },
                                onPay: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => new PayPage()));
                                },
                              ),
                              // ((items.length - 1) == index)
                              //     ? Container(
                              //         height: 65,
                              //         width: MediaQuery.of(context).size.width,
                              //       )
                              //     : Container(),
                            ],
                          );
                        });
                  }
                },
              );
  }

  String getTruthDocRoom() {
    if (widget.currentRoomItem == null && externalEntryDocument == null) {
      print("Both null");
      return getChatRoomID(widget.currentUser.email, widget.email!);
    } else if (widget.currentRoomItem == null) {
      print("currentRoomItem null");
      return externalEntryDocument['chatroom'];
    } else {
      print("externalEntryDocument null");
      return widget.currentRoomItem!.id;
    }
  }

  Widget _buildCompotionInput() {
    return new Container(
      // margin: EdgeInsets.fromLTRB(15, 0, 5, 0),
      // color: Colors.black,
      color: subBlackLight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: widget.currentUser.type != 0
                ? MediaQuery.of(context).size.width - 100
                : MediaQuery.of(context).size.width - 60,
            height: 55,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 4.0),
              child: new TextField(
                controller: _txtControllerMessage,
                maxLines: 2,
                onSubmitted: _onSubmitMessage,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  hintText: ' Enter message',
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          widget.currentUser.type != 0
              ? InkWell(
                  onTap: _showCreateOfferSheetModalWidget,
                  child: new Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: primaryColor, shape: BoxShape.circle),
                      child: Icon(
                        Icons.local_offer,
                        color: Colors.white,
                        size: 20,
                      )),
                )
              : Container(),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: _sendMessage,
            child: new Container(
                width: 50,
                height: 55,
                color: primaryColor,
                child: new Icon(Icons.send, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    print(_txtControllerMessage.text);

    ChatMessage message = new ChatMessage(
      message: _txtControllerMessage.text,
      isSendByMe: true,
      messageType: 'text',
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 200),
        vsync: this,
      ),
      messageDate: DateTime.now().millisecondsSinceEpoch,
    );
    if (_txtControllerMessage.text.trim().isNotEmpty) {
      if (widget.currentRoomItem == null) {
        print("NULL");
        if (externalEntryDocument == null) {
          print("NULL && NULL");
          String roomName =
              getChatRoomID(widget.email!, widget.currentUser.email);
          await messengerServices.createChatRoom(roomName, {
            "chatroom": roomName,
            "last_date_messaging": DateTime.now().millisecondsSinceEpoch,
            "last_message": _txtControllerMessage.text,
            "users": [widget.currentUser.email, widget.email!],
          });
          await messengerServices.addConversationMessages(roomName, {
            'message': _txtControllerMessage.text.trim(),
            'sendBy': widget.currentUser.email,
            'type': 'text'
          });
          setState(() {
            if (_txtControllerMessage.text.length > 0) {
              _listMessage.insert(0, message);
            }
          });

          // Hide keyboard after send message
          // FocusScope.of(context).requestFocus(FocusNode());
          _txtControllerMessage.clear();
          message.animationController.forward();
          checkRoomIsExists();
        } else {
          print("externalEntryDocument NOT NULL");
          messengerServices
              .addConversationMessages(externalEntryDocument['chatroom'], {
            'message': _txtControllerMessage.text.trim(),
            'sendBy': widget.currentUser.email,
            'type': 'text'
          });
          setState(() {
            if (_txtControllerMessage.text.length > 0) {
              _listMessage.insert(0, message);
            }
          });

          // Hide keyboard after send message
          // FocusScope.of(context).requestFocus(FocusNode());
          _txtControllerMessage.clear();
          message.animationController.forward();
        }
      } else {
        print("currentRoomItem NOT NULL");
        messengerServices
            .addConversationMessages(widget.currentRoomItem!['chatroom'], {
          'message': _txtControllerMessage.text.trim(),
          'sendBy': widget.currentUser.email,
          'type': 'text'
        });
        setState(() {
          if (_txtControllerMessage.text.length > 0) {
            _listMessage.insert(0, message);
          }
        });

        // Hide keyboard after send message
        // FocusScope.of(context).requestFocus(FocusNode());
        _txtControllerMessage.clear();
        message.animationController.forward();
      }
    }
  }

  void _onSubmitMessage(String text) {
    print("message: $text");
  }

  _showCreateOfferSheetModalWidget() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        backgroundColor: primaryColor,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: CreateOfferSheetPage(
              currentUser: widget.currentUser,
              onSelect: (data) async {
                if (widget.currentRoomItem == null) {
                  if (externalEntryDocument == null) {
                    String roomName =
                        getChatRoomID(widget.email!, widget.currentUser.email);
                    await messengerServices.createChatRoom(roomName, {
                      "chatroom": roomName,
                      "last_date_messaging":
                          DateTime.now().millisecondsSinceEpoch,
                      "last_message": "New offer!",
                      "users": [widget.currentUser.email, widget.email!],
                    });
                    await messengerServices.addConversationMessages(roomName, {
                      'message': data['message'],
                      'sendBy': widget.currentUser.email,
                      'type': 'offer',
                      'period': data['period'],
                      'budget': data['budget'],
                      'service': data['service']
                    });
                  } else {
                    messengerServices.addConversationMessages(
                        externalEntryDocument['chatroom'], {
                      'message': data['message'],
                      'sendBy': widget.currentUser.email,
                      'type': 'offer',
                      'period': data['period'],
                      'budget': data['budget'],
                      'service': data['service']
                    });
                  }
                } else {
                  messengerServices.addConversationMessages(
                      widget.currentRoomItem!['chatroom'], {
                    'message': data['message'],
                    'sendBy': widget.currentUser.email,
                    'type': 'offer',
                    'period': data['period'],
                    'budget': data['budget'],
                    'service': data['service']
                  });
                }
              },
            ),
          );
        });
  }

  getChatRoomID(String firstEmail, String secondEmail) {
    print('$firstEmail $secondEmail');
    if (firstEmail.substring(0, 1).codeUnitAt(0) >
        secondEmail.substring(0, 1).codeUnitAt(0)) {
      return '$secondEmail\_$firstEmail';
    } else {
      return '$firstEmail\_$secondEmail';
    }
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {Key? key,
      required this.message,
      required this.animationController,
      required this.isSendByMe,
      required this.messageDate,
      this.budget,
      this.period,
      this.service,
      this.onPay,
      this.onCancel,
      required this.messageType})
      : super(key: key);

  final messageDate;
  final String message;
  final String messageType;
  final AnimationController animationController;
  final bool isSendByMe;

  final String? budget;
  final String? period;
  final String? service;

  final Function? onPay;
  final Function? onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.only(
          left: isSendByMe ? 0.0 : 8.0, right: isSendByMe ? 8.0 : 0.0),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          messageType == "text"
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                  decoration: BoxDecoration(
                      // color: isSendByMe ? primaryColor : subLightColor,
                      color: isSendByMe ? subLightColor : subBlackLight,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Column(
                    children: [
                      Text(
                        message.toString(),
                        style: TextStyle(
                            // color: isSendByMe ? Colors.white : Colors.black,
                            color: isSendByMe ? Colors.black : Colors.white,
                            fontSize: 18),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                    ],
                  ),
                )
              : getOfferWidget(context,
                  onCancel: () => onCancel!(), onPay: () => onPay!()),
          Text(
            readTimestamp(messageDate),
            style: TextStyle(
              // color: isSendByMe ? Colors.white : Colors.black,
              color: primaryColor,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget getOfferWidget(context,
      {required Function onCancel, required Function onPay}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      decoration: BoxDecoration(
          // color: isSendByMe ? primaryColor : subLightColor,
          color: subBlackLight,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      width: MediaQuery.of(context).size.width * 0.60,
      child: Column(
        children: [
          Text(
            "New offer!",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Image.asset(
                'assets/images/icons/dollar-symbol.png',
                height: 25,
                width: 25,
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Text(
                  '$budget \$',
                  style: const TextStyle(
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Image.asset(
                'assets/images/icons/deadline.png',
                height: 25,
                width: 25,
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Text(
                  '$period Days',
                  style: const TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          service == null
              ? Container()
              : Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Service: ${service!}",
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
          SizedBox(
            height: 10,
          ),
          (message == null || message.isEmpty)
              ? Container()
              : Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Description: " + message,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
          ((message == null || message.isEmpty) && service == null)
              ? Container()
              : SizedBox(
                  height: 10,
                ),
          InkWell(
            onTap: () {
              if (isSendByMe) {
                onCancel();
              } else {
                onPay();
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 35,
              decoration: BoxDecoration(
                  // color: isSendByMe ? primaryColor : subLightColor,
                  color: isSendByMe ? Colors.red : primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Center(
                  child: Text(
                isSendByMe ? "Cancel!" : "Pay!",
                style: TextStyle(color: Colors.white),
              )),
            ),
          )
        ],
      ),
    );
  }

  String readTimestamp(int timestamp) {
    return new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000)
        .toString()
        .substring(0, 16);
  }
}
