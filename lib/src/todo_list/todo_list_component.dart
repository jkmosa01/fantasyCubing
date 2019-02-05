import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'dart:html';
import 'todo_list_service.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

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
    grabWCAMe();
  }

  void grabWCAMe(){
    String hash = window.location.hash.substring(1);

    var resultP1 = hash.split('&');
    String accessToken;
    for(var i=0; i<resultP1.length; i++){
      List temp = resultP1[i].split("=");
      if(temp[0]=='access_token'){
        accessToken = "Bearer "+temp[1];
      }
    }
    print(accessToken);
    if(accessToken!=null) {
      http.get(
        'https://www.worldcubeassociation.org/api/v0/me',
        // Send authorization headers to your backend
        headers: {HttpHeaders.authorizationHeader: accessToken},
      ).then((resp){
        var data = json.decode(resp.body);
        print(data);
      });
    }
  }

  void add() {
    items.add(newTodo);
    newTodo = '';
  }

  String remove(int index) => items.removeAt(index);
}
