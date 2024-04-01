import 'package:chiasmodon/tool.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

int resultCount = 0;
int resultPages = 0;
int currectPage = 1;
bool err = false;
String msg = "";
String apiToken = '';
String processSID = '';
Uri apiUrl = Uri.parse("https://beta.chiasmodon.com/v2/api/beta");
Map<String, String> apiHaders = {'user-agent': 'app/python'};

/*List<String> viewTypes = [
  'cred',
  'subdomain',
  'url',
  'email',
  'app',
  'username',
  'pssword',
];*/

void apiRest() {
  resultCount = 0;
  resultPages = 0;
  currectPage = 1;
  processSID = '';
}

Future<List> fetchBeta(Map body) async {
  final response = await http.post(
    apiUrl,
    headers: apiHaders,
    body: body,
  );

  final responseBody = response.body;
  final String info = body['get-info'] ?? '';
  Map result = jsonDecode(responseBody);
  if (result['err'] != null) {
    err = true;
    msg = result['msg'];
    return [];
  } else {
    err = false;
  }

  if (info == 'yes') {
    processSID = result['sid'];
    resultPages = result['pages'];
    resultCount = result['count'];
    return [result['sid']];
  }
  if (result.containsKey('data')) {
    return result['data'];
  }

  return [];

  /* catch (e) {
    print("LOL:Error : $e");
    return [];
  }*/
}

Future<List> getResult(
  String query,
  String method, {
  String viewType = "cred",
  int page = 1,
  bool all = false,
  bool domainEmails = false,
  bool info = false,
}) async {
  Map body = {
    'token': apiToken,
    'type-view': viewType,
    'method': 'search-by-$method',
    'query': query,
  };
  if (info == true) {
    body['get-info'] = 'yes';
  }

  if (all == true) {
    body['all'] = 'yes';
  } else {
    body['all'] = 'no';
  }

  if (domainEmails) {
    body['domain-emails'] = 'yes';
  } else {
    body['domain-emails'] = 'no';
  }

  if (processSID != '') {
    body['page'] = page.toString();
    body['sid'] = processSID;
  }
  return await fetchBeta(body);
}

ResultTitleList setResult(data, viewType) {
  if (viewType == "cred") {
/*
    if (resultCredsListHistory.contains(data)) {
      return ResultTitleList(
          viewType: viewType,
          value: '-',
          url: '',
          username: '',
          appId: '',
          appName: '',
          password: '',
          country: '',
          date: '');
    } else {
      resultCredsListHistory.add(data);
    } */
    if (data.containsKey('app_id') && data['app_id'] != null) {
      return ResultTitleList(
          viewType: viewType,
          value: '',
          url: '',
          appIcon: data['app_icon'],
          username: data['email'] ?? data['username'],
          appId: data['app_id'] ?? '',
          appName: data['app_name'] ?? '',
          password: data['password'],
          country: data['country'],
          date: data['date']);
    } else {
      return ResultTitleList(
          viewType: viewType,
          value: '',
          appIcon: data['app_icon'],
          url: data['url'],
          username: data['email'] ?? data['username'],
          appId: '',
          appName: '',
          password: data['password'],
          country: data['country'],
          date: data['date']);
    }
  } else {
    /*
    if (resultOutherListHistory.contains(data)) {
      return ResultTitleList(
          viewType: viewType,
          value: '-',
          url: '',
          username: '',
          appId: '',
          appName: '',
          password: '',
          country: '',
          date: '');
    } else {
      resultOutherListHistory.add(data);
    }
    */

    return ResultTitleList(
        viewType: viewType,
        value: data,
        url: '',
        username: '',
        appId: '',
        appName: '',
        appIcon: 'no',
        password: '',
        country: '',
        date: '');
  }
}

class ResultTitleList extends StatelessWidget {
  final String viewType;
  final String value;
  final String url;
  final String username;
  final String appId;
  final String appIcon;
  final String appName;
  final String password;
  final String country;
  final String date;

  const ResultTitleList({
    super.key,
    required this.viewType,
    required this.value,
    required this.url,
    required this.username,
    required this.appId,
    required this.appName,
    required this.appIcon,
    required this.password,
    required this.country,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    String getTitle() {
      if (url != '') {
        return url;
      } else {
        return appName;
      }
    }

    String getSubtitle() {
      if (url != '') {
        return "Username: $username\nPassword: $password\nCountry: $country";
      } else {
        return "Username: $username\nPassword: $password\nCountry: $country";
      }
    }

    String getLineValue() {
      if (value != '') {
        return value;
      } else {
        return "-";
      }
    }

    if (viewType == "cred") {
      if (methodSearch == 'app' && appIcon != 'no') {
        return Card(
          borderOnForeground: false,
          color: const Color.fromARGB(230, 42, 39, 39),
          child: ListTile(
            title: SelectableText(
              getTitle(),
              style: const TextStyle(color: Colors.green),
            ),
            subtitle: SelectableText(
              getSubtitle(),
              style: const TextStyle(color: Colors.green, fontFamily: ''),
            ),
            leading: CircleAvatar(
              backgroundImage: Image.network(appIcon).image,
            ),
          ),
        );
      }
      return Card(
        borderOnForeground: false,
        color: const Color.fromARGB(230, 42, 39, 39),
        child: ListTile(
          title: SelectableText(
            getTitle(),
            style: const TextStyle(color: Colors.green),
          ),
          subtitle: SelectableText(
            getSubtitle(),
            style: const TextStyle(color: Colors.green, fontFamily: ''),
          ),
        ),
      );
    } else {
      return Card(
          borderOnForeground: false,
          color: const Color.fromARGB(230, 42, 39, 39),
          child: ListTile(
            title: SelectableText(
              getLineValue(),
              style: const TextStyle(color: Colors.green),
            ),
          ));
    }
  }
}
