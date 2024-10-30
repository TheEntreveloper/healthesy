class HealthPractitionerData {
  int? id = -1;
  String hp;
  String? pn, email, tel;
  int? ptype;

  HealthPractitionerData(this.id, this.hp, {this.pn, this.email, this.tel, this.ptype});

  HealthPractitionerData.fromMap(Map<String, dynamic> map): this(
      map['id'],
      map['hp'],
      pn: map['pn'],
      email: map['email'],
      tel: map['tel'],
      ptype: map['ptype'],
  );
}