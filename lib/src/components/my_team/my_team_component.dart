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
  final events = ["3x3","2x2","4x4","5x5","6x6","7x7","Pyraminx","Skewb","Megaminx","Clock","Square-1","OH","Feet","3BLD","4BLD","5BLD","MBLD","FMC"];
  var eventSelected = "3x3";
  List<PersonSearch> searchResults;
  @override
  Future<Null> ngOnInit() async {
    picking = false;
    for(var i=0; i<myTeam.length; i++){
      myTeam[i] = PersonSelection();
    }
  }
  void selectPerson(i){
    print(i);
    picking = true;
  }

  void closeSelect(){
    picking = false;
  }

  void getPeoples(String text){
    searchResults = [];
    if(text.length>1){
      var client = new BrowserClient();
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
    print(searchResults[i].wcaId);
  }

}
