/// Client data to be sent to the server
class Client {
  String? lastName, firstName, title;
  String? idCardNumber; // TODO only for tenant/landlord, need to be encrypted
  String? phoneNumber, email;
  String? addressLine1, addressLine2, district, region;
}
