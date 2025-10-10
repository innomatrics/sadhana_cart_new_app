class EmailAndPassModel {
  final String email;
  final String password;
  EmailAndPassModel({required this.email, required this.password});

  factory EmailAndPassModel.inital() =>
      EmailAndPassModel(email: '', password: '');
}
