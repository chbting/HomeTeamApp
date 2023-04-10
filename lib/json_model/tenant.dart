class Tenant {
  String lastName;
  String firstName;
  String title;
  String idCardNumber; // TODO only for tenant/landlord, need to be encrypted
  String phoneNumber;
  String email;

  Tenant(
      {this.lastName = '',
      this.firstName = '',
      this.title = '',
      this.idCardNumber = '',
      this.phoneNumber = '',
      this.email = ''});
}
