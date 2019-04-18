import 'package:flutter/material.dart';
import 'change_username_bloc.dart';
class UsernameProvider extends InheritedWidget{
  final ChangeUsernameBloc changeUsernameBloc;

  UsernameProvider({
    Key key, ChangeUsernameBloc changeUsernameBloc, Widget child
  }):changeUsernameBloc = changeUsernameBloc?? ChangeUsernameBloc(),
      super(key:key,child:child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static ChangeUsernameBloc of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(UsernameProvider) as UsernameProvider).changeUsernameBloc;
  }

}