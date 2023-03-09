import 'package:hometeam_client/json_model/address.dart';

class Tenant {
  String lastName;
  String firstName;
  String title;
  String idCardNumber; // TODO only for tenant/landlord, need to be encrypted
  String phoneNumber;
  String email;
  final Address address;

  Tenant(
      {this.lastName = '',
      this.firstName = '',
      this.title = '',
      this.idCardNumber = '',
      this.phoneNumber = '',
      this.email = '',
      required this.address});
}

enum ClientType { tenant, landLord }
