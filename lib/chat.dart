import 'dart:async';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool showFirstContainer = true;
  List<BubbleSpecialThree> messages = [];
  late DialogFlowtter fileInstance;
  List<String> houseProperties = [];
  List<double> propertyValues = [];

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0)).then((value) async {
      fileInstance =
          await DialogFlowtter.fromFile(path: 'assets/dialog_flow_auth.json');
    });
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        showFirstContainer = false;
      });
    });
    super.initState();
  }

  Future<String?> sendInput(String input) async {
    final QueryInput queryInput = QueryInput(
      text: TextInput(
        text: input,
        languageCode: "en",
      ),
    );
    DetectIntentResponse response = await fileInstance.detectIntent(
      queryInput: queryInput,
    );
    String? textResponse = response.text;
    /*
    if (response.queryResult!.allRequiredParamsPresent != null &&
        response.queryResult!.allRequiredParamsPresent!) {
      if (response.queryResult!.parameters!.isNotEmpty) {
        print(response.queryResult!.parameters!['house-properties']);
        if (!houseProperties
            .contains(response.queryResult!.parameters!['house-properties'])) {
          houseProperties
              .add(response.queryResult!.parameters!['house-properties']);
          propertyValues.add(response.queryResult!.parameters!['number']);
          print(houseProperties);
          print(propertyValues);
        }
      }
    }*/
    return textResponse;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(seconds: 1),
          color: Colors.purple,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 30),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the radius as needed
                  color: Colors.white, // Set the desired background color
                ),
                width: MediaQuery.of(context).size.width / 2,
                child: Column(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraint) {
                          return SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: constraint.maxHeight),
                              child: IntrinsicHeight(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: List.generate(messages.length,
                                      (index) => messages[index]),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    MessageBar(
                      onSend: (p0) async {
                        setState(() {
                          messages.add(
                            BubbleSpecialThree(
                              text: p0,
                              color: const Color(0xFF1B97F3),
                              tail: false,
                              textStyle: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          );
                        });
                        String? response = await sendInput(p0);
                        setState(() {
                          messages.add(
                            BubbleSpecialThree(
                              text: response ??
                                  'Something unexpected occured, please try again.',
                              color: const Color(0xFFE8E8EE),
                              tail: false,
                              isSender: false,
                              textStyle: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                          );
                        });
                      },
                      actions: [],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 50.0),
            child: Icon(
              Icons.house,
              size: 100,
              color: Colors.white,
            ),
          ),
        ),
        const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 50.0),
            child: Icon(
              Icons.house,
              size: 100,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
