class Pokemon {
  /*
  {
    "name" : String,
    "photo : String,
    "ps" : Integer,
    "atq": Integer,
    "df": Integer,
    "atq_spl": Integer,
    "df_spl": Integer,
    "spl": Integer,
    "vel": Integer,
    "acc": Integer,
    "evs": Integer,
  }
  * */

  String name, photo;
  int id, ps, atq, df, atqSql, dfSql, spl, vel, acc, evs;

  Pokemon({
    this.id,
    this.name,
    this.photo,
    this.ps,
    this.atq,
    this.df,
    this.atqSql,
    this.dfSql,
    this.spl,
    this.vel,
    this.acc,
    this.evs,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json["id"],
      name: json["name"],
      photo: json["photo"],
      ps: json["ps"],
      atq: json["atq"],
      df: json["df"],
      atqSql: json["atq_spl"],
      dfSql: json["df_spl"],
      spl: json["spl"],
      vel: json["vel"],
      acc: json["acc"],
      evs: json["evs"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["name"] = name;
    data["photo"] = photo;
    data["ps"] = ps;
    data["atq"] = atq;
    data["df"] = df;
    data["atq_sql"] = atqSql;
    data["df_sql"] = dfSql;
    data["spl"] = spl;
    data["vel"] = vel;
    data["acc"] = acc;
    data["evs"] = evs;
    return data;
  }
}
