
import 'package:flutter_bloc/flutter_bloc.dart';

class spaceListStateObserver extends BlocObserver{
  const spaceListStateObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change){
    super.onChange(bloc, change);
    print('spaceListState changed to $change');
  }
}

class updateSpaceListState extends Cubit<dynamic>{
  updateSpaceListState(): super(0);
  void reloadOn() {
    emit(state+1);
    print(state.toString());
  }
  void reloadOff(){
    emit(state-1);
  }
}
