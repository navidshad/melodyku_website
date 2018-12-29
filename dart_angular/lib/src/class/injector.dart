
class InjectorMember<T>
{
  String name;
  T member;
  InjectorMember(this.name, this.member);
}

class Injector<T>
{
  static final List<InjectorMember> _injectory = [];

  static register(InjectorMember newMember)
  {
    bool isAdded = false;

    _injectory.forEach((m) {
      if(m.name == newMember.name) isAdded = true;
    });

    //print('${newMember.member} | isAdded $isAdded');
    
    if(!isAdded) _injectory.add(newMember);
  }

  static T get<T>()
  {
    T member;

    _injectory.forEach((m) 
    { 
      if(m.member is T) member = m.member;
    });

    //print('get injector ${member} | _injectory: ${_injectory.length}');
    return member;
  }
}