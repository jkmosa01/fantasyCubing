import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'dart:html';
import 'todo_list_service.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:firebase/firebase.dart' as firebase;
import 'package:http/browser_client.dart';

@Component(
  selector: 'todo-list',
  styleUrls: ['todo_list_component.css'],
  templateUrl: 'todo_list_component.html',
  directives: [
    MaterialCheckboxComponent,
    MaterialFabComponent,
    MaterialIconComponent,
    materialInputDirectives,
    NgFor,
    NgIf,
  ],
  providers: [ClassProvider(TodoListService)],
)
class TodoListComponent implements OnInit {
  final TodoListService todoListService;

  List<String> items = [];
  String newTodo = '';

  TodoListComponent(this.todoListService);

  @override
  Future<Null> ngOnInit() async {
    items = await todoListService.getTodoList();
    firebase.initializeApp(
        apiKey: "AIzaSyCmCYL8d5w1vpOezmV2l2OBFCxAaDSc3YI",
        authDomain: "fantasy-cubing.firebaseapp.com",
        databaseURL: "https://fantasy-cubing.firebaseio.com",
        projectId: "fantasy-cubing",
        storageBucket: "fantasy-cubing.appspot.com",
        messagingSenderId: "7563614714"
    );
    grabWCAMe();
  }

  void grabWCAMe() {
    if (window.location.hash.isNotEmpty) {
      String hash = window.location.hash.substring(1);
      var resultP1 = hash.split('&');
      String accessToken;
      for (var i = 0; i < resultP1.length; i++) {
        List temp = resultP1[i].split("=");
        if (temp[0] == 'access_token') {
          accessToken = "Bearer " + temp[1];
        }
      }
      print(accessToken);
      String uid;
      if (accessToken != null) {
        var client = new BrowserClient();
        client.get(
          'https://www.worldcubeassociation.org/api/v0/me',
          // Send authorization headers to your backend
          headers: {HttpHeaders.authorizationHeader: accessToken},
        )
            .then((resp) {
          var data = json.decode(resp.body);
          print(data);
          String password = data['me']['dob'].toString() +
              data['me']['id'].toString() + data['me']['created_at'].toString();
          String email = data['me']['email'];
          print(password);
          print(email);
          firebase.auth().signInWithEmailAndPassword(email, password).then((
              credential) {
            print(credential);
            print(credential.user.uid);
            uid = credential.user.uid;
          }).catchError((error) {
            firebase.auth()
                .createUserWithEmailAndPassword(email, password)
                .then((credential) {
              print(credential);
              print(credential.user.uid);
              uid = credential.user.uid;
            }).catchError((error) {
              print(error);
            });
          });
        });
        print(uid);
      }
    }
  }

  void add() {
    items.add(newTodo);
    newTodo = '';
  }

  String remove(int index) => items.removeAt(index);
}
