import 'package:tner_client/utils/shared_preferences_helper.dart';

class Client {
  String? lastName, firstName, title;
  String? idCardNumber;
  String? phoneNumber, email;
  String? addressLine1, addressLine2, district, region;
}

// todo debug sample
Client getSampleClientData() {
  var chinese = SharedPreferencesHelper().getLocale().languageCode == 'zh';
  Client client = Client();
  client.firstName = chinese ? '大明' : 'David';
  client.lastName = chinese ? '陳' : 'Johnson';
  client.title = chinese ? '先生' : 'Mr.';
  client.idCardNumber = 'A0123456(7)';
  client.phoneNumber = '1234-5678';
  client.email = 'demo@email.com';
  client.addressLine1 = chinese ? '1座2樓C室' : 'Flat C, 2/F, Block 1';
  client.addressLine2 = chinese ? '雅佳花園' : 'Bayview Garden';
  client.district = chinese ? '上環' : 'Sheng Wan';
  client.region = chinese ? '香港' : 'Hong Kong';
  return client;
}