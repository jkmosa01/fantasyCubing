import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:fantasyCubing/src/globals.dart' as globals;
@Component(
  selector: 'main-component',
  styleUrls: ['main_component.css'],
  templateUrl: 'main_component.html',
  directives: [
    NgFor,
    NgIf,
  ],
  providers: [],
)
class MainComponent implements OnInit {
  firebase.User user;
  var testList;
  @override
  Future<Null> ngOnInit() async {
    firebase.auth().currentUser;
    testList = [
      {
        "name":"Feliks Zemdegs",
        "score": "100",
        "event": "3x3"
      },
      {
        "name":"Jordan Mosakowski",
        "score": "50",
        "event": "3x3"
      },
      {
        "name":"Max Park",
        "score": "150",
        "event": "5x5"
      },
      {
        "name":"Kevin Hays",
        "score": "76",
        "event": "7x7"
      },
    ];
  }

  bool isSignedIn(){
    return globals.signedIn;
  }

}
