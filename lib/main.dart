import 'package:firstproject/tool.dart';
import 'package:firstproject/token.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black, // Set the background color
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontFamily: 'oldComputerFont',
            color: Colors.green, // Set the default text color
          ),
          labelLarge: TextStyle(
            fontFamily: 'oldComputerFont',
            color: Colors.green, // Set the button text color
          ),
          titleMedium: TextStyle(
            fontFamily: 'oldComputerFont',
            color: Colors.green, // Set the input text color
          ),
        ),
      ),
      home: const MyAppHome(),
    );
  }
}

class MyAppHome extends StatefulWidget {
  const MyAppHome({Key? key}) : super(key: key);

  @override
  State<MyAppHome> createState() => MyAppHomeState();
}

class MyAppHomeState extends State<MyAppHome> {
  int? i;
  bool status = true;
  GlobalKey<FormState> ssss = GlobalKey();
  GlobalKey<ScaffoldState> scaffkey = GlobalKey();

  void launchTelegram() async {
    final url =
        'https://t.me/chiasmod0n'; // Replace with the desired Telegram URL or username

    if (await canLaunch('tg://resolve?domain=chiasmod0n')) {
      await launch('tg://resolve?domain=chiasmod0n');
    } else {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffkey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(230, 42, 39, 39),
        child: const Icon(
          Icons.add,
          color: Colors.green,
          shadows: [Shadow(color: Colors.green), Shadow(color: Colors.red)],
        ),
        onPressed: () => {scaffkey.currentState!.openDrawer()},
      ),
      drawer: Drawer(
        shadowColor: Colors.green,
        backgroundColor: const Color.fromARGB(230, 42, 39, 39),
        surfaceTintColor: Colors.green,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50),
            ),
            const Text(" Search by:"),
            Flexible(
                child: ListTile(
              textColor: Colors.green,
              iconColor: Colors.green,
              title: const Text(
                "App",
                style: TextStyle(fontFamily: 'oldComputerFont'),
              ),
              onTap: () {
                setState(() {
                  methodSearch = "app";
                });
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ToolPageClass()));
                // put action here
              },
              leading: const Icon(Icons.app_blocking),
            )),
            Flexible(
                child: ListTile(
              textColor: Colors.green,
              iconColor: Colors.green,
              title: const Text("Domain",
                  style: TextStyle(fontFamily: 'oldComputerFont')),
              onTap: () {
                setState(() {
                  methodSearch = "domain";
                });
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ToolPageClass()));
                // put action here
              },
              leading: const Icon(Icons.web),
            )),
            Flexible(
                child: ListTile(
              textColor: Colors.green,
              iconColor: Colors.green,
              title: const Text("IP Address or CIDR",
                  style: TextStyle(fontFamily: 'oldComputerFont')),
              onTap: () {
                setState(() {
                  methodSearch = "cidr";
                });
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ToolPageClass()));

                // put action here
              },
              leading: const Icon(Icons.padding),
            )),
            Flexible(
                child: ListTile(
              textColor: Colors.green,
              iconColor: Colors.green,
              title: const Text("ASN",
                  style: TextStyle(fontFamily: 'oldComputerFont')),
              onTap: () {
                setState(() {
                  methodSearch = "asn";
                });
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ToolPageClass()));

                // put action here
              },
              leading: const Icon(Icons.location_city),
            )),
            Flexible(
                child: ListTile(
              textColor: Colors.green,
              iconColor: Colors.green,
              title: const Text("Email",
                  style: TextStyle(fontFamily: 'oldComputerFont')),
              onTap: () {
                setState(() {
                  methodSearch = "email";
                });
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ToolPageClass()));

                // put action here
              },
              leading: const Icon(Icons.email),
            )),
            Flexible(
                child: ListTile(
              textColor: Colors.green,
              iconColor: Colors.green,
              title: const Text("Username",
                  style: TextStyle(fontFamily: 'oldComputerFont')),
              onTap: () {
                setState(() {
                  methodSearch = "username";
                });
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ToolPageClass()));

                // put action here
              },
              leading: const Icon(Icons.face),
            )),
            Flexible(
                child: ListTile(
              textColor: Colors.green,
              iconColor: Colors.green,
              title: const Text("Password",
                  style: TextStyle(fontFamily: 'oldComputerFont')),
              onTap: () {
                setState(() {
                  methodSearch = "password";
                });
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ToolPageClass()));

                // put action here
              },
              leading: const Icon(Icons.password),
            )),
            const Text(
              " Settings:",
              style: TextStyle(
                fontFamily: 'oldComputerFont',
              ),
            ),
            Flexible(
                child: ListTile(
              textColor: Colors.green,
              iconColor: Colors.green,
              title: const Text("API KEY",
                  style: TextStyle(fontFamily: 'oldComputerFont')),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TokenSaveWindow(context)),
                );
                // put action here
              },
              leading: const Icon(Icons.api_sharp),
            )),
            Flexible(
                child: ListTile(
              textColor: Colors.green,
              iconColor: Colors.green,
              title: const Text("Chat with Admin",
                  style: TextStyle(fontFamily: 'oldComputerFont')),
              onTap: () {
                launchTelegram();
                // put action here
              },
              leading: const Icon(Icons.support_agent),
            )),
            const Divider(
              color: Colors.green,
              height: 20,
            ),
            const Text(
              " Version 0.1",
              style: TextStyle(
                fontFamily: 'oldComputerFont',
              ),
            ),
          ],
        ),
      ),
      body: Container(
        //color: Colors.black,
        padding: const EdgeInsets.all(20),
        child: const Center(
          child: SelectableText(
            "\t       ⚓Chiasmodon⚓\nWebsite:  chiasmodon.club\nTwitter: @chiasmod0n\nTelegram: @chiasmod0n",
            style: TextStyle(fontSize: 20, fontFamily: ''),
          ),
        ),
      ),
    );
  }
}
