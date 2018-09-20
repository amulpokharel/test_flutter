import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

final ThemeData iOSTheme = new ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light);

final ThemeData defaultTheme = new ThemeData(
    primarySwatch: Colors.purple, accentColor: Colors.orangeAccent[400]);

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Test App",
      theme:
          defaultTargetPlatform == TargetPlatform.iOS ? iOSTheme : defaultTheme,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

const String name = "Name-o";

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
                            child: new Text("Send"),
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

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
        sizeFactor: new CurvedAnimation(
            parent: animationController, curve: Curves.easeOut),
        axisAlignment: 0.0,
        child: new Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: new CircleAvatar(child: new Text(name[0])),
              ),
              Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(name, style: Theme.of(context).textTheme.subhead),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: new Text(text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
