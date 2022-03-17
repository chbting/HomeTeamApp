class Client {
  String? lastName, firstName, title;
  String? idCardNumber;
  String? phoneNumber, email;
  String? addressLine1, addressLine2, district, region;
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
  client.addressLine1 = '1座2樓C室';
  client.addressLine2 = '雅佳花園';
  client.district = '上環';
  client.region = '香港';
  return client;
}
