import 'package:angular/angular.dart';

import 'package:fantasyCubing/src/components/user/user_component.dart';
import 'package:fantasyCubing/src/components/header/header_component.dart';
import 'package:fantasyCubing/src/components/my_team/my_team_component.dart';
import 'package:fantasyCubing/src/components/main/main_component.dart';
import 'package:fantasyCubing/src/globals.dart' as globals;
// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'my-app',
  styleUrls: ['main_page.css'],
  templateUrl: 'main_page.html',
  directives: [UserComponent,HeaderComponent,MainComponent,NgIf,MainComponent],
)
class AppComponent {

  int getCurrentPage(){
    return globals.currentPage;
  }
}
