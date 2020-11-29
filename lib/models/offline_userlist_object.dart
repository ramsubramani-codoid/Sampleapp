class Offlineuser{
  int id;
  String email;
  String first_name;
  String last_name;
  String avatar;

  Offlineuser(
      {this.id,this.email, this.first_name,this.last_name, this.avatar });

  factory Offlineuser.fromJson(Map<String, dynamic> json) {
    return new Offlineuser(
        id: json['id'],
        email: json['email'].toString(),
        first_name: json['first_name'].toString(),
        last_name: json['last_name'].toString(),
        avatar: json['avatar'].toString(),
    );
  }
}