import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fantasyCubing/src/utils/person_selection.dart';

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
  ],
  providers: [],
)
class MyTeamComponent implements OnInit {
  List<PersonSelection> myTeam = List(10);
  bool picking;
  int currentlyPicking;
  List events = ["3x3","2x2","4x4","5x5","6x6","7x7","Pyraminx","Skewb","Megaminx","Clock","Square-1","OH","Feet","3BLD","4BLD","5BLD","MBLD","FMC"];
  int eventSelected = 0;
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

}
