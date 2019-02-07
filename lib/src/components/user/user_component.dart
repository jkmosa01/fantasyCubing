import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'dart:html';
import 'user_service.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:firebase/firebase.dart' as firebase;
import 'package:http/browser_client.dart';

@Component(
  selector: 'user-component',
  styleUrls: ['user_component.css'],
  templateUrl: 'user_component.html',
  directives: [
//    MaterialCheckboxComponent,
//    MaterialFabComponent,
//    MaterialIconComponent,
//    materialInputDirectives,
    MaterialButtonComponent,
    NgFor,
    NgIf,
  ],
  providers: [ClassProvider(UserService)],
)
class UserComponent implements OnInit {
  final UserService userService;
  firebase.User user;

  List<String> items = [];
  String newTodo = '';

  UserComponent(this.userService);

  @override
  Future<Null> ngOnInit() async {
    items = await userService.getTodoList();
    firebase.initializeApp(
        apiKey: "AIzaSyCmCYL8d5w1vpOezmV2l2OBFCxAaDSc3YI",
        authDomain: "fantasy-cubing.firebaseapp.com",
        databaseURL: "https://fantasy-cubing.firebaseio.com",
        projectId: "fantasy-cubing",
        storageBucket: "fantasy-cubing.appspot.com",
        messagingSenderId: "7563614714"
    );
    firebase.auth().onAuthStateChanged.listen(onSignIn);
    grabWCAMe();
  }

  void onSignIn(firebase.User newUser){
    user = newUser;
  }

  void signOut(){
    firebase.auth().signOut();
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
      if (accessToken != null && user==null) {
        var client = new BrowserClient();
        client.get(
          'https://www.worldcubeassociation.org/api/v0/me',
          // Send authorization headers to your backend
          headers: {HttpHeaders.authorizationHeader: accessToken},
        ).then((resp) {
          var data = json.decode(resp.body);
          String password = data['me']['dob'].toString() +
              data['me']['id'].toString() + data['me']['created_at'].toString();
          String email = data['me']['email'];
          firebase.auth().signInWithEmailAndPassword(email, password).then((credential) {}).catchError((error) {
            firebase.auth().createUserWithEmailAndPassword(email, password).then((credential) {
              firebase.firestore().collection("users").doc(credential.user.uid).set({
                "id": data['me']['id'],
                "wca_id": data['me']['wca_id'],
                "name": data['me']['name'],
              });
            }).catchError((error) {
              print(error);
            });
          });
        });
      }
    }
  }
  //{
  //  me: {class: user, url: https://www.worldcubeassociation.org/persons/2014MOSA01, id: 28262, wca_id: 2014MOSA01, name: Jordan Mosakowski, gender: m, country_iso2: US, delegate_status: null, created_at: 2016-08-27T15:18:08.000Z, updated_at: 2019-02-06T18:23:45.000Z, teams: [], avatar: {url: https://www.worldcubeassociation.org/assets/missing_avatar_thumb-f0ea801c804765a22892b57636af829edbef25260a65d90aaffbd7873bde74fc.png, thumb_url: https://www.worldcubeassociation.org/assets/missing_avatar_thumb-f0ea801c804765a22892b57636af829edbef25260a65d90aaffbd7873bde74fc.png, is_default: true}, email: jordanmosakowski@gmail.com}}
  void add() {
    items.add(newTodo);
    newTodo = '';
  }

  String remove(int index) => items.removeAt(index);
}
