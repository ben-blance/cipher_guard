import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import the clipboard package

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cipher Guard',
      theme: ThemeData(
        brightness: Brightness.dark, // Use dark theme
        primaryColor: Colors.blue, // Adjust primary color as needed
        scaffoldBackgroundColor: Colors.black.withOpacity(0.07),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final alphabet =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.,?!'_-&@#\$%*()/:<>|+= ";
  TextEditingController messageController = TextEditingController();
  TextEditingController keyController = TextEditingController();
  String result = '';

  void updateResult(bool isEncrypting) {
    final text = messageController.text;
    final key = keyController.text;
    String updatedResult = '';

    if (isEncrypting) {
      updatedResult = encryptText(text, key);
    } else {
      updatedResult = decryptText(text, key);
    }

    setState(() {
      result = updatedResult;
    });
  }

  String encryptText(String text, String key) {
    String encryptedText = '';

    for (var i = 0; i < text.length; i++) {
      final textChar = text[i];
      final keyChar = key[i % key.length];

      final textIndex = alphabet.indexOf(textChar);
      final keyIndex = alphabet.indexOf(keyChar);

      if (textIndex == -1) {
        encryptedText += textChar;
      } else {
        final newIndex = (textIndex + keyIndex) % alphabet.length;
        encryptedText += alphabet[newIndex];
      }
    }

    return encryptedText;
  }

  String decryptText(String encryptedText, String key) {
    String decryptedText = '';

    for (var i = 0; i < encryptedText.length; i++) {
      final encryptedChar = encryptedText[i];
      final keyChar = key[i % key.length];

      final encryptedIndex = alphabet.indexOf(encryptedChar);
      final keyIndex = alphabet.indexOf(keyChar);

      if (encryptedIndex == -1) {
        decryptedText += encryptedChar;
      } else {
        var newIndex = encryptedIndex - keyIndex;
        if (newIndex < 0) newIndex += alphabet.length;
        decryptedText += alphabet[newIndex];
      }
    }

    return decryptedText;
  }

  // Function to copy text to clipboard
  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: result));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Text copied to clipboard')),
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize the result with encrypted text when the page loads
    updateResult(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 500,
            padding: EdgeInsets.all(30),
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.07), // Adjust overlay transparency
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2), // Set elevation color
                  blurRadius: 2, // Adjust elevation level
                  offset: Offset(0, 2), // Adjust elevation offset
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
              children: <Widget>[
                Text(
                  'Cipher Guard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                Text('Message :', style: TextStyle(fontSize: 14)),
                TextField(
                  controller: messageController,
                  maxLines: 5,
                  style: TextStyle(color: Colors.white), // Set text color
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue), // Adjust focused border color
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('Key :', style: TextStyle(fontSize: 14)),
                TextField(
                  controller: keyController,
                  style: TextStyle(color: Colors.white), // Set text color
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue), // Adjust focused border color
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        updateResult(true);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF176B87), // Set button color
                      ),
                      child: Text('Encrypt'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        updateResult(false);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF176B87), // Set button color
                      ),
                      child: Text('Decrypt'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Result:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white, // Set text color
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    copyToClipboard();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Text(
                      result,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white, // Set text color
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
