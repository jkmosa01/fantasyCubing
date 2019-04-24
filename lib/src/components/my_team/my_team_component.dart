import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fantasyCubing/src/utils/person.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:http/browser_client.dart';
import 'dart:convert';
import 'package:angular_components/focus/focus_item.dart';
import 'package:angular_components/focus/focus_list.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_list/material_list.dart';
import 'package:angular_components/material_list/material_list_item.dart';
import 'package:angular_components/material_select/material_select_item.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:fantasyCubing/src/globals.dart' as globals;

@Component(
  selector: 'my-team',
  styleUrls: ['my_team_component.css'],
  templateUrl: 'my_team_component.html',
  directives: [
    MaterialButtonComponent,
    NgFor,
    NgIf,
    MaterialDropdownSelectComponent,
    materialInputDirectives,
    FocusItemDirective,
    FocusListDirective,
    MaterialIconComponent,
    MaterialListComponent,
    MaterialListItemComponent,
    MaterialSelectItemComponent,
  ],
  providers: [materialProviders],
)
class MyTeamComponent implements OnInit {
  List<PersonSelection> myTeam = List(10);
  bool picking;
  int currentlyPicking;
  String currentInput;
  BrowserClient client = new BrowserClient();
  final events = ["3x3","2x2","4x4","5x5","6x6","7x7","Pyraminx","Skewb","Megaminx","Clock","Square-1","OH","Feet","3BLD","4BLD","5BLD","MBLD","FMC"];
  var eventSelected = "3x3";
  final parseEvents = {
  "3x3": "333",
  "2x2": "222",
  "4x4": "444",
  "5x5": "555",
  "6x6": "666",
  "7x7": "777",
  "Pyraminx": "pyram",
  "Skewb": "skewb",
  "Megaminx": "minx",
  "Clock": "clock",
  "Square-1": "sq1",
  "OH": "333oh",
  "Feet": "333ft",
  "3BLD": "333bf",
  "4BLD": "444bf",
  "5BLD": "555bf",
  "MBLD": "333mbf",
  "FMC": "333fm"
  };

  final Map<String,String> getEvent = {
    "333": "3x3",
    "222": "2x2",
    "444": "4x4",
    "555": "5x5",
    "666": "6x6",
    "777": "7x7",
    "pyram": "Pyraminx",
    "skewb": "Skewb",
    "minx": "Megaminx",
    "clock": "Clock",
    "sq1": "Square-1",
    "333oh": "OH",
    "333ft": "Feet",
    "333bf": "3BLD",
    "444bf": "4BLD",
    "555bf": "5BLD",
    "333mbf": "MBLD",
    "333fm": "FMC"
  };
  List<PersonSearch> searchResults;
  @override
  Future<Null> ngOnInit() async {
    picking = false;
    for(var i=0; i<myTeam.length; i++){
      myTeam[i] = PersonSelection();
    }
  }
  void selectPerson(i){
    currentlyPicking = i;
    eventSelected = getEvent[myTeam[i].event ?? "333"];
    currentInput = myTeam[i].wcaId ?? "";
    getPeoples(myTeam[i].wcaId ?? "");
    picking = true;
  }

  void closeSelect(){
    currentlyPicking = null;
    picking = false;
  }

  void getPeoples(String text){
    currentInput = text;
    searchResults = [];
    if(text.length>1){
      client.get(
        'https://www.worldcubeassociation.org/api/v0/search/users?q='+text,
      ).then((response){
        searchResults = [];
        List<dynamic> result = json.decode(response.body)['result'];
        for(var i=0; i<result.length; i++){
          if(result[i]['wca_id']!=null && searchResults.length<6) {
            var person = PersonSearch();
            person.name = result[i]['name'];
            person.wcaId = result[i]['wca_id'];
            person.id = result[i]['id'];
            searchResults.add(person);
          }
        }
      });
    }
  }

  void choosePerson(int i){
    currentInput = searchResults[i].wcaId;
    searchResults = [];
  }

  void selectThisPerson(){
    client.get(
      'https://www.worldcubeassociation.org/api/v0/persons/'+currentInput,
    ).then((response){
      if(response.statusCode==200) {
        var data = json.decode(response.body)['person'];
        myTeam[currentlyPicking].name = data['name'];
        myTeam[currentlyPicking].wcaId = data['wca_id'];
        myTeam[currentlyPicking].event = parseEvents[eventSelected];
        closeSelect();
      }
      else{
        myTeam[currentlyPicking].wcaId = currentInput;
        myTeam[currentlyPicking].event = parseEvents[eventSelected];
        closeSelect();
      }
    }).catchError((error){
      myTeam[currentlyPicking].wcaId = currentInput;
      myTeam[currentlyPicking].event = parseEvents[eventSelected];
      closeSelect();
    });

  }

  void saveTeam(){
    print("saving team");
     if(globals.signedIn){
       firebase.User user = firebase.auth().currentUser;
       firebase.firestore().collection("week1").doc(user.uid).set({
         'team': myTeam.map((person) => person.toMap())
       });
     }
  }
}
