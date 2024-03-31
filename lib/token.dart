import 'package:flutter/material.dart';
import 'package:chiasmodon/apiBeta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenSaveWindow extends StatefulWidget {
  final BuildContext context;

  TokenSaveWindow(this.context);

  @override
  _TokenSaveWindowState createState() => _TokenSaveWindowState();
}

class _TokenSaveWindowState extends State<TokenSaveWindow> {
  final TextEditingController _tokenController = TextEditingController();
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    _prefs = await SharedPreferences.getInstance();
    final savedToken = _prefs!.getString('api_token');
    if (savedToken != null) {
      setState(() {
        _tokenController.text = savedToken;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(230, 42, 39, 39),
        child: const Icon(
          Icons.arrow_back,
          color: Colors.green,
          shadows: [Shadow(color: Colors.green), Shadow(color: Colors.red)],
        ),
        onPressed: () {
          setState(() {
            apiRest();
          });
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            (route) => false,
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40),
            ),
            TextField(
                controller: _tokenController,
                textAlign: TextAlign.left,
                maxLines: 2,
                minLines: 1,
                cursorColor: Colors.green,
                style: const TextStyle(color: Colors.green),
                decoration: const InputDecoration(
                  fillColor: Color.fromARGB(230, 42, 39, 39),
                  counterStyle: TextStyle(
                    color: Colors.green,
                    fontFamily: 'oldComputerFont',
                  ),
                  labelText: 'API Token',
                  labelStyle: TextStyle(
                    color: Colors.green,
                    fontFamily: 'oldComputerFont',
                  ),
                  hoverColor: Colors.green,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(230, 42, 39, 39))),
                  hintStyle: TextStyle(
                    color: Colors.green,
                    fontFamily: 'oldComputerFont',
                  ),
                  hintText: "Your token",
                )),
            const SizedBox(height: 16.0),
            MaterialButton(
              color: const Color.fromARGB(230, 42, 39, 39),
              onPressed: _saveToken,
              child: const Text('Save',
                  style: TextStyle(
                      fontFamily: 'oldComputerFont', color: Colors.green)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveToken() async {
    final token = _tokenController.text.trim();

    await _prefs!.setString('api_token', token);

    ScaffoldMessenger.of(widget.context).showSnackBar(
      const SnackBar(
          content: Text(
        'API token saved successfully!',
        style: TextStyle(color: Colors.green),
      )),
    );
    setState(() {
      apiToken = token;
    });
  }
}
