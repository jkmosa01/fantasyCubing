import 'package:angular/angular.dart';
import 'package:fantasyCubing/src/pages/main/main_page.template.dart' as ng;
import 'package:firebase/firebase.dart' as firebase;

void main() {
  firebase.initializeApp(
      apiKey: "AIzaSyCmCYL8d5w1vpOezmV2l2OBFCxAaDSc3YI",
      authDomain: "fantasy-cubing.firebaseapp.com",
      databaseURL: "https://fantasy-cubing.firebaseio.com",
      projectId: "fantasy-cubing",
      storageBucket: "fantasy-cubing.appspot.com",
      messagingSenderId: "7563614714"
  );
  runApp(ng.AppComponentNgFactory);
}