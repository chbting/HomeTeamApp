import 'package:hometeam_client/json_model/address.dart';

class Client {
  Address address;
  String? lastName, firstName, title;
  String? idCardNumber;
  String? phoneNumber, email;

  Client() : address = Address();
}

// todo debug sample
// todo english sample
Client getSampleClientData() {
  Client client = Client();
  client.firstName = '大明';
  client.lastName = '陳';
  client.title = '先生';
  client.idCardNumber = 'A0123456(7)';
  client.phoneNumber = '1234-5678';
  client.email = 'demo@email.com';
  client.address.addressLine1 = '1座2樓C室';
  client.address.addressLine2 = '雅佳花園';
  client.address.district = '上環';
  client.address.region = '香港';
  return client;
}
