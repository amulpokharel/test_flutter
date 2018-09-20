
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController textEditingController = TextEditingController();
  final List<ChatMessage> messages = <ChatMessage>[];
  bool isComposing = false;

  Widget buildTextComposer() {
    return IconTheme(
        data: IconThemeData(color: Theme.of(context).accentColor),
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Flexible(
                    child: TextField(
                  controller: textEditingController,
                  onChanged: (String text) {
                    setState(() {
                      isComposing = text.length > 0;
                    });
                  },
                  onSubmitted: handleSubmitted,
                  decoration:
                      InputDecoration.collapsed(hintText: "Send Message"),
                )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Theme.of(context).platform == TargetPlatform.iOS
                        ? CupertinoButton(
                            child: new Text("Sendo"),
                            onPressed: isComposing
                                ? () =>
                                    handleSubmitted(textEditingController.text)
                                : null)
                        : IconButton(
                            icon: Icon(Icons.send),
                            onPressed: isComposing
                                ? () =>
                                    handleSubmitted(textEditingController.text)
                                : null,
                          ))
              ],
            )));
  }

  void handleSubmitted(String text) {
    textEditingController.clear();
    setState(() {
      isComposing = false;
    });
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
          duration: new Duration(milliseconds: 200), vsync: this),
    );

    setState(() {
      messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Friendly Chat"),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              new Flexible(
                child: new ListView.builder(
                  padding: new EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) => messages[index],
                  itemCount: messages.length,
                ),
              ),
              new Divider(
                height: 1.0,
              ),
              new Container(
                decoration:
                    new BoxDecoration(color: Theme.of(context).cardColor),
                child: buildTextComposer(),
              )
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
                  border:
                      new Border(top: new BorderSide(color: Colors.grey[200])))
              : null,
        ));
  }

  @override
  void dispose() {
    for (ChatMessage message in messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}