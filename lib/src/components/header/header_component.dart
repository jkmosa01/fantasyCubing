import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fantasyCubing/src/globals.dart' as globals;

@Component(
  selector: 'header-component',
  styleUrls: ['header_component.css'],
  templateUrl: 'header_component.html',
  directives: [
//    MaterialCheckboxComponent,
    MaterialFabComponent,
    MaterialIconComponent,
//    materialInputDirectives,
//    MaterialButtonComponent,
    NgFor,
    NgIf,
  ],
  providers: [],
)
class HeaderComponent implements OnInit {

  @override
  Future<Null> ngOnInit() async {
  }

  void setCurrentPage(int page){
    globals.currentPage = page;
  }

}
