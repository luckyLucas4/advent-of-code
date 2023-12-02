import 'a01.dart' as a01;
import 'a02.dart' as a02;

String test() {
  return "test";
}

void runApp(int day) {
  final apps = [
    a01.run,
    a02.run,
  ];
  if (day > 0 && day <= apps.length) {
    apps[day - 1]();
  } else {
    print("Day is not implemented");
  }
}
