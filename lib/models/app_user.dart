class AppUser {
  String name, pass, phone, email;
  int pts = 0;
  bool photo = false, admin;
  AppUser(this.name, this.pass, {this.phone = '', this.email = '', this.admin = false});
}
