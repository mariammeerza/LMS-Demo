import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/function.dart';
import 'package:flutter_application_1/sidebar/sidebar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/function.dart';

void main() {
  runApp(ChatGPTApp());
}

class ChatGPTApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Tutor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isSidebarOpen = true;
  String url = '';
  var data;
  String output = 'Initial Output';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Tutor'),
        leading: IconButton(
          icon: Icon(_isSidebarOpen ? Icons.menu_open : Icons.menu),
          onPressed: () {
            setState(() {
              _isSidebarOpen = !_isSidebarOpen;
            });
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          if (_isSidebarOpen)
            const Expanded(
              flex: 1,
              child: SideBar(),
            ),
          if (_messages.isEmpty)
            Positioned(
              top: 150,
              right: 800,
              child: Container(
                width: 250,
                height: 250,
                child: Image.asset(
                  'assets/aitutor.png',
                  height: 100,
                ),
              ),
            ),
          Expanded(
            flex: _isSidebarOpen ? 3 : 4,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return ChatBubble(
                        text: message.text,
                        isCurrentUser: message.isSentByUser,
                        borderColor: Colors.black,
                        isAITutorMessage: !message.isSentByUser,
                        tutorIcon: 'assets/Owl (2).png',
                        objectIcon: 'assets/Object.png',
                      );
                    },
                  ),
                ),
                _buildTextComposer(),
              ],
            ),
          ),
          if (_messages.isEmpty)
            Positioned(
              top: 150,
              left: 850,
              child: ChatBubble(
                text: "Could you clarify the correct usage of it's and its?",
                isCurrentUser: false,
                borderColor: Colors.black,
                isAITutorMessage: true,
                tutorIcon: 'assets/Owl (2).png',
                objectIcon: 'assets/Object.png',
                onPressed: () {
                  sendMessage(
                      "Could you clarify the correct usage of it's and its?");
                },
              ),
            ),
          if (_messages.isEmpty)
            Positioned(
              top: 210,
              left: 850,
              child: ChatBubble(
                text:
                    "What is the area of rectangle with length 8cm and width 5cm?",
                isCurrentUser: false,
                borderColor: Colors.black,
                isAITutorMessage: true,
                tutorIcon: 'assets/Owl (2).png',
                objectIcon: 'assets/Object.png',
                onPressed: () {
                  sendMessage(
                      "What is the area of rectangle with length 8cm and width 5cm?");
                },
              ),
            ),
          if (_messages.isEmpty)
            Positioned(
              top: 270,
              left: 850,
              child: ChatBubble(
                text: "What are real numbers?",
                isCurrentUser: false,
                borderColor: Colors.black,
                isAITutorMessage: true,
                tutorIcon: 'assets/Owl (2).png',
                objectIcon: 'assets/Object.png',
                onPressed: () {
                  sendMessage("What are real numbers?");
                },
              ),
            ),
          if (_messages.isEmpty)
            Positioned(
              top: 330,
              left: 850,
              child: ChatBubble(
                text: "What are adjectives?",
                isCurrentUser: false,
                borderColor: Colors.black,
                isAITutorMessage: true,
                tutorIcon: 'assets/Owl (2).png',
                objectIcon: 'assets/Object.png',
                onPressed: () {
                  sendMessage("What are adjectives?");
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          sendMessage(_textController.text);
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 3, 10, 0), // Adjusted padding
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Stack(
          children: <Widget>[
            TextField(
              onChanged: (value) {
                url = 'http://127.0.0.1:5000/query?query=' + value.toString();
              },
              controller: _textController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Send a message',
              ),
            ),
            Positioned(
              bottom: 5,
              left: 1380,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.mic),
                    onPressed: () {
                      // Your microphone functionality
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      data = await fetchdata(url);
                      var decoded = jsonDecode(data);

                      setState(() {
                        output = data['response'];
                      });
                      sendMessage(_textController.text);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage(String message) async {
    if (message.isNotEmpty) {
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            text: message,
            isSentByUser: true,
          ),
        );
      });
      _textController.clear();

      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/query?query='),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'query': message}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData.containsKey('response')) {
          _addEchoMessage(responseData['response']);
        } else {
          print("The API response does not contain the key 'response'.");
        }
      } else {
        print("Error: ${response.body}");
      }
    }
  }

  // void sendMessage(String message) async {
  //   if (message.isNotEmpty) {
  //     setState(() {
  //       _messages.insert(
  //         0,
  //         ChatMessage(
  //           text: message,
  //           isSentByUser: true,
  //         ),
  //       );
  //     });
  //     _textController.clear();
  //     // http.Client() getClient{
  //     //   return http.Client();
  //     // }

  //     // Send the message to the Python API
  //     final response = await http.post(
  //       Uri.parse('http://127.0.0.1:5000/query'), // Adjust the URL if necessary
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode({'query': message}),
  //     );

  //     // Decode the response and add it to the chat
  //     final responseData = json.decode(response.body);
  //     if (responseData.containsKey('response')) {
  //       // Use 'response' as the key
  //       _addEchoMessage(
  //           responseData['response']); // Use the response from the API
  //     } else {
  //       print("The API response does not contain the key 'response'.");
  //     }
  //   }
  // }

  void _addEchoMessage(String message) {
    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          text: message,
          isSentByUser: false,
        ),
      );
    });
  }
}

// void sendMessage(String message) async {
//   if (message.isNotEmpty) {
//     setState(() {
//       _messages.insert(
//         0,
//         ChatMessage(
//           text: message,
//           isSentByUser: true,
//         ),
//       );
//     });
//     _textController.clear();

//     // Send the message to the Python API
//     final response = await http.post(
//       Uri.parse('http://localhost:5000/chat'), // Adjust the URL if necessary
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'message': message}),
//     );
//     _textController.clear();
//     _addEchoMessage('response');
//   }
// }
// void sendMessage(String message) async {
//   if (message.isNotEmpty) {
//     setState(() {
//       _messages.insert(
//         0,
//         ChatMessage(
//           text: message,
//           isSentByUser: true,
//         ),
//       );
//     });
//     _textController.clear();

//     // Send the message to the Python API
//     final response = await http.post(
//       Uri.parse('http://localhost:5000/chat'),  // Adjust the URL if necessary
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'message': message}),
//     );

//     // Decode the response and add it to the chat
//     final responseData = json.decode(response.body);
//     _addEchoMessage(responseData['response']);
//   }
// }

//   void _addEchoMessage(String text) {
//     Future.delayed(const Duration(seconds: 1), () {
//       setState(() {
//         _messages.insert(
//           0,
//           ChatMessage(
//             text: text,
//             isSentByUser: false,
//           ),
//         );
//       });
//     });
//   }
// }

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isCurrentUser;
  final Color borderColor;
  final bool isAITutorMessage;
  final String tutorIcon;
  final String objectIcon;
  final VoidCallback? onPressed;

  const ChatBubble({
    Key? key,
    required this.text,
    required this.isCurrentUser,
    required this.borderColor,
    required this.isAITutorMessage,
    required this.tutorIcon,
    required this.objectIcon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCurrentUser && isAITutorMessage) ...[
            Image.asset(
              tutorIcon,
              width: 36,
              height: 36,
            ),
            const SizedBox(width: 7),
          ],
          GestureDetector(
            onTap: onPressed,
            child: CustomPaint(
              painter: _BubblePainter(
                color: isCurrentUser ? Colors.white : const Color(0xFFCDE9C8),
                borderColor: borderColor,
                isCurrentUser: isCurrentUser,
              ),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: Text.rich(
                  TextSpan(
                    text: isCurrentUser ? 'You: ' : 'AI Tutor: ',
                    style: TextStyle(
                      color: isCurrentUser ? Colors.black : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: text,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (!isCurrentUser && isAITutorMessage) ...[
            const SizedBox(width: 7),
            Image.asset(
              objectIcon,
              width: 30,
              height: 30,
            ),
          ],
        ],
      ),
    );
  }
}

class _BubblePainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final bool isCurrentUser;

  _BubblePainter({
    required this.color,
    required this.borderColor,
    required this.isCurrentUser,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    final radius = 14.0;
    final offset = 6.0;

    if (isCurrentUser) {
      path.lineTo(size.width - offset, 0);
      path.quadraticBezierTo(
        size.width,
        0,
        size.width,
        radius,
      );
      path.lineTo(size.width, size.height - radius);
      path.quadraticBezierTo(
        size.width,
        size.height,
        size.width - offset,
        size.height,
      );
      path.lineTo(0, size.height);
      path.lineTo(0, radius);
      path.quadraticBezierTo(
        0,
        0,
        offset,
        0,
      );
    } else {
      path.lineTo(offset, 0);
      path.quadraticBezierTo(
        0,
        0,
        0,
        radius,
      );
      path.lineTo(0, size.height - radius);
      path.quadraticBezierTo(
        0,
        size.height,
        offset,
        size.height,
      );
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, radius);
      path.quadraticBezierTo(
        size.width,
        0,
        size.width - offset,
        0,
      );
    }

    path.close();
    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ChatMessage {
  final String text;
  final bool isSentByUser;

  ChatMessage({required this.text, required this.isSentByUser});
}
