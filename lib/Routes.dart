enum Routes {
  LOGIN("/"),
  FEED("/feed"),
  HOME("/home");

  final String name;
  const Routes(this.name);
}
