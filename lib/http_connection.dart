import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'Post.dart';
import 'package:http/http.dart' as http;

String _urlBase = "https://jsonplaceholder.typicode.com";

Future<List<Post>> recuperarPostagens(http.Client client) async {
  final response = await client.get(Uri.parse(_urlBase + "/posts"));
  return compute(parsePostagens, response.body);
}

List<Post> parsePostagens(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Post>((json) => Post.fromJson(json)).toList();
}

Future<Post> createPost() async {
  var corpo = json.encode({
    "userId": 120,
    "id": null,
    "title": "Titulo",
    "body": "Corpo da postagem"
  });

  final response = await http.post(
    Uri.parse(_urlBase + "/posts"),
    headers: {
      "Content-type": "application/json; charset=UTF-8",
    },
    body: corpo,
  );

  if (response.statusCode == 201) {
    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

Future<Post> updatePut() async {
  //Obrigatorio enviar todos os dados
  final response = await http.put(
    Uri.parse(_urlBase + "/posts/5"),
    headers: {
      "Content-type": "application/json; charset=UTF-8",
    },
    body: json.encode({
      "userId": 120,
      "id": null,
      "title": "Titulo alterado",
      "body": "Corpo da postagem alterado2"
    }),
  );

  if (response.statusCode == 200) {
    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to update album.');
  }
}

updatePatch() async {
  // Patch Pode altera somente um registro
  http.Response response = await http.patch(
    Uri.parse(_urlBase + "/posts/3"),
    headers: {
      "Content-type": "application/json; charset=UTF-8",
    },
    body: json.encode(
        {"title": "Titulo alterado", "body": "Corpo da postagem alterado8"}),
  );

  if (response.statusCode == 200) {
    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");
  } else {
    throw Exception('Failed to update album.');
  }
}

delete() async {
  http.Response response = await http.delete(Uri.parse(_urlBase + "/posts/5"));
  print("resposta: ${response.statusCode}");
  print("resposta: ${response.body}");
}
