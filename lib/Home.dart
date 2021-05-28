import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Post.dart';
import 'http_connection.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Post>>(
        future: recuperarPostagens(http.Client()),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return Text('Erro ao carregar os dados.');
              else
                return PostList(post: snapshot.data!);
          }
        },
      ),
    );
  }
}

class PostList extends StatelessWidget {
  final List<Post> post;

  PostList({Key? key, required this.post}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviço avançado"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                ElevatedButton(
                  child: Text("Salvar"),
                  onPressed: createPost,
                ),
                ElevatedButton(
                  child: Text("Atualizar"),
                  onPressed: updatePut,
                ),
                ElevatedButton(
                  child: Text("Remover"),
                  onPressed: delete,
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: post.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    title: Text(post[index].title),
                    subtitle: Text(post[index].body),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
