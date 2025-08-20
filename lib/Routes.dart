enum Routes {
  LOGIN("/"),
  FEED("/feed"),
  HOME("/home"),
  SEARCH("/search"),
  PROFILE("/profile");

  final String name;
  const Routes(this.name);
}
