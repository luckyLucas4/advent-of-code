import 'a01.dart' as a01;

String test() {
  return "test";
}

void runApp(int day) {
  final apps = [
    a01.run,
  ];

  return (day > 0 && day <= apps.length)
      ? apps[day - 1]()
      : "Day is not implemented";
}
