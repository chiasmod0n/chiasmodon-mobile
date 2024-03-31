import 'package:flutter/material.dart';
import 'package:chiasmodon/apiBeta.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? methodSearch;

class ToolPageClass extends StatefulWidget {
  @override
  ToolPage createState() => ToolPage();
}

class ToolPage extends State<ToolPageClass> {
  TextEditingController query = TextEditingController();
  GlobalKey<ScaffoldState> scaffkey = GlobalKey();
  bool showButtonF = false;
  bool showButtonB = false;
  String viewType = 'cred';
  Map<String, List<String>> textMethod = {
    "domain": ["Domain Search", "example.com"],
    "cidr": ['cidr search', 'x.x.x.x/24'],
    'asn': ['asn search', 'AS123'],
    'app': ['app search', 'Application ID'],
    'email': ['email Search', 'someone@gmail.com'],
    'username': ['username search', 'someone'],
    'password': ['password search', 'asd@123'],
  };
  Text? resultTextAfterSearch;

  FutureBuilder<List>? pageWindow;
  Future<List> procResult({
    String query = '',
    String method = 'domain',
    String viewType = "cred",
    int page = 1,
    String token = "",
    bool all = false,
    bool domainEmails = false,
  }) async {
    if (processSID == '') {
      print(await getResult(query, method,
          viewType: viewType,
          page: page,
          all: all,
          domainEmails: domainEmails,
          info: true));
    }

    setState(() {
      if (resultCount != 0) {
        if (resultPages > 1) {
          if (currectPage > 1) {
            showButtonB = true;
          } else {
            showButtonB = false;
          }
          if (currectPage < resultPages) {
            showButtonF = true;
          } else {
            showButtonF = false;
          }
        }
      }
      resultTextAfterSearch =
          Text('Result: $resultCount | Pages $currectPage/$resultPages');
    });
    return await getResult(query, method,
        viewType: viewType,
        page: page,
        all: all,
        domainEmails: domainEmails,
        info: false);
  }

  void updatePageWindow() {
    setState(() {
      // Update the pageWindow variable as needed
      pageWindow = FutureBuilder<List>(
        future: procResult(
            query: query.text,
            method: methodSearch ?? "domain",
            viewType: viewType,
            page: currectPage),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error occurred: ${snapshot.error}'),
            );
          } else if (err && msg != '') {
            SelectableText? x;
            x = SelectableText(msg,
                style: const TextStyle(color: Colors.red, fontFamily: ''));
            apiRest();
            return x;
          } else {
            final data = snapshot.data;
            if (data!.isEmpty) {
              return const SelectableText('Not found result',
                  style: TextStyle(color: Colors.red, fontFamily: ''));
            }
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return setResult(data[index], viewType);
                });
          }
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  static const String _tokenKey = 'api_token';

  static getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    apiToken = prefs.getString(_tokenKey) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    String getTextMethodText() {
      return textMethod[methodSearch ?? "domain"]![0];
    }

    return Scaffold(
      key: scaffkey,
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
      body: Container(
        margin: const EdgeInsets.only(top: 40),
        //color: Colors.black,
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: TextField(
                controller: query,
                textAlign: TextAlign.left,
                maxLines: 2,
                minLines: 1,
                cursorColor: Colors.green,
                style: const TextStyle(color: Colors.green),
                decoration: InputDecoration(
                    fillColor: const Color.fromARGB(230, 42, 39, 39),
                    counterStyle: const TextStyle(
                      color: Colors.green,
                      fontFamily: 'oldComputerFont',
                    ),
                    labelText: getTextMethodText(),
                    labelStyle: const TextStyle(
                      color: Colors.green,
                      fontFamily: 'oldComputerFont',
                    ),
                    hoverColor: Colors.green,
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(230, 42, 39, 39))),
                    hintStyle: const TextStyle(
                      color: Colors.green,
                      fontFamily: 'oldComputerFont',
                    ),
                    hintText: textMethod[methodSearch ?? "Example.com"]![1]),
              )),
            ],
          ),
          MaterialButton(
            color: const Color.fromARGB(230, 42, 39, 39),
            onPressed: () {
              setState(() {
                apiRest();
              });

              updatePageWindow();
            },
            child: const Text(
              style: TextStyle(color: Colors.green),
              'search',
            ),
          ),
          Center(
            child: resultTextAfterSearch,
          ),
          const Divider(
            color: Colors.green,
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: showButtonB,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(230, 42, 39, 39)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      if (currectPage > 0) {
                        currectPage -= 1;
                      }
                    });
                    updatePageWindow();
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.green,
                  ),
                ),
              ),
              Visibility(
                visible: showButtonF,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(230, 20, 4, 4)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      currectPage += 1;
                    });

                    updatePageWindow();
                  },
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          Flexible(
              child: Container(
            child: pageWindow,
          )),
        ]),
      ),
    );
  }
}
