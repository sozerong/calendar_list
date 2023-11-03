import 'dart:convert';

import 'package:http/http.dart' as http;

class Network {
  final String url;
  Network(this.url);
  Future<dynamic> getJson() async {
    http.Response response =
        await http.get(Uri.parse(url));

    return response;
  }

//  var response = await network.getJson();
//  var pasingdata = jsonDecode(response.body);

}

