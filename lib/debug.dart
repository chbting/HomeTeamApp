import 'package:hometeam_client/data/address.dart';
import 'package:hometeam_client/data/tenant.dart';
import 'package:hometeam_client/utils/shared_preferences_helper.dart';

Tenant getSampleClientData() {
  var chinese = SharedPreferencesHelper.getLocale().languageCode == 'zh';
  Tenant tenant = Tenant();
  tenant.firstName = chinese ? '大明' : 'David';
  tenant.lastName = chinese ? '陳' : 'Johnson';
  tenant.title = chinese ? '先生' : 'Mr.';
  tenant.idCardNumber = 'A123456(7)';
  tenant.phoneNumber = '12345678';
  tenant.email = 'demo@email.com';
  tenant.address.addressLine1 = chinese ? '1座2樓C室' : 'Flat C, 2/F, Block 1';
  tenant.address.addressLine2 = chinese ? '雅佳花園' : 'Bayview Garden';
  tenant.address.district = chinese ? '上環' : 'Sheung Wan';
  tenant.address.region = Region.hongKong;
  return tenant;
}
