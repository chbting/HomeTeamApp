import 'package:hometeam_client/data/address.dart';

class Tenant {
  String? lastName, firstName, title;
  String? idCardNumber; // TODO only for tenant/landlord, need to be encrypted
  String? phoneNumber, email;
  Address address = Address();
}
