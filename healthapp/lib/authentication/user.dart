class User{
  String name;
  String email;
  int age;
  String gender;
  String address;
  int phone;
  User(this.name, this.email, this.age,
      this.gender, this.address, this.phone);

  @override
  String toString() {
    return '$name, $email, $age, $gender, $address, $phone';
  }
}
