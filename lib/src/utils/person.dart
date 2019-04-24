class PersonSelection{
  String name;
  String wcaId;
  String event;
  Map<String,dynamic> toMap(){
    return {
      "name":name,
      "wcaId":wcaId,
      "event": event,
    };
  }
  PersonSelection fromMap(Map<String,String> data){
    return PersonSelection(data['name'],data['wcaId'],data['event']);
  }
  PersonSelection(this.name,this.wcaId,this.event);
}

class PersonSearch{
  String name;
  String wcaId;
  int id;
}