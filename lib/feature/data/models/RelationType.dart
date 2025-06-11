enum RelationType {
  ADAPTATION("Adaptation"),
  PREQUEL("Prequel"),
  SEQUEL("Sequel"),
  PARENT("Parent"),
  SIDE_STORY("Side Story"),
  CHARACTER("Character"),
  SUMMARY("Summary"),
  ALTERNATIVE("Alternative"),
  SPIN_OFF("Spin-Off"),
  OTHER("Other"),
  SOURCE("Source"),
  COMPILATION("Compilation"),
  CONTAINS("Contains");

  final String prettyName;
  const RelationType(this.prettyName);
}
