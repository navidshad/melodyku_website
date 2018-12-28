
class InjectorMember<T>
{
  T member;
  InjectorMember(this.member);
}

class Injector<T>
{
  static final List<InjectorMember> _injectory = [];

  static register(InjectorMember newMember)
  {
    _injectory.add(newMember);
  }

  static T get<T>()
  {
    T member;

    _injectory.forEach((m) 
    { 
      if(m.member is T) member = m.member;
    });

    return member;
  }
}