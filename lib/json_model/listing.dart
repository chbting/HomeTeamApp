import 'package:hometeam_client/debug.dart';
import 'package:hometeam_client/json_model/terms.dart';
import 'package:hometeam_client/json_model/terms_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'listing.g.dart';

@JsonSerializable(explicitToJson: true)
class Listing {
  String id;
  String propertyId;
  String title;
  Terms terms;
  Map<TermsItem, TermsItemSettings> settings = {};

  Listing({required this.propertyId, required this.title, Terms? terms})
      : id = propertyId, //todo
        terms = terms ?? Terms(propertyId: propertyId) {
    for (var item in TermsItem.values) {
      settings[item] = TermsItemHelper.getDefaultSettings(item);
    }
  }

  factory Listing.fromJson(Map<String, dynamic> json) =>
      _$ListingFromJson(json);

  Map<String, dynamic> toJson() => _$ListingToJson(this);
}

class ListingHelper {
  static Listing getFromId(String id) {
    //todo temporary solution
    return Debug.getSampleListing().firstWhere((listing) => listing.id == id);
  }
}
