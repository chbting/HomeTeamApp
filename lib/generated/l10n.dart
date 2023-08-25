// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `General Settings`
  String get general_settings {
    return Intl.message(
      'General Settings',
      name: 'general_settings',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message(
      'Dark Mode',
      name: 'darkMode',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Choose Language`
  String get choose_language {
    return Intl.message(
      'Choose Language',
      name: 'choose_language',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Schedule Remodeling`
  String get schedule_remodeling {
    return Intl.message(
      'Schedule Remodeling',
      name: 'schedule_remodeling',
      desc: '',
      args: [],
    );
  }

  /// `Owner`
  String get owner {
    return Intl.message(
      'Owner',
      name: 'owner',
      desc: '',
      args: [],
    );
  }

  /// `Suspended Ceiling`
  String get suspended_ceiling {
    return Intl.message(
      'Suspended Ceiling',
      name: 'suspended_ceiling',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Schedule`
  String get schedule {
    return Intl.message(
      'Schedule',
      name: 'schedule',
      desc: '',
      args: [],
    );
  }

  /// `Dismiss`
  String get dismiss {
    return Intl.message(
      'Dismiss',
      name: 'dismiss',
      desc: '',
      args: [],
    );
  }

  /// `Scrape old paint`
  String get scrape_old_paint {
    return Intl.message(
      'Scrape old paint',
      name: 'scrape_old_paint',
      desc: '',
      args: [],
    );
  }

  /// `Area (Sq. ft)`
  String get area_sq_ft {
    return Intl.message(
      'Area (Sq. ft)',
      name: 'area_sq_ft',
      desc: '',
      args: [],
    );
  }

  /// `No. of rooms`
  String get number_of_rooms {
    return Intl.message(
      'No. of rooms',
      name: 'number_of_rooms',
      desc: '',
      args: [],
    );
  }

  /// `Leave/No old paints`
  String get scrape_old_paint_no {
    return Intl.message(
      'Leave/No old paints',
      name: 'scrape_old_paint_no',
      desc: '',
      args: [],
    );
  }

  /// `Scrape old paints`
  String get scrape_old_paint_yes {
    return Intl.message(
      'Scrape old paints',
      name: 'scrape_old_paint_yes',
      desc: '',
      args: [],
    );
  }

  /// `Estimate:`
  String get estimate {
    return Intl.message(
      'Estimate:',
      name: 'estimate',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Count`
  String get count {
    return Intl.message(
      'Count',
      name: 'count',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next_option {
    return Intl.message(
      'Next',
      name: 'next_option',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Pick a day`
  String get pick_a_day {
    return Intl.message(
      'Pick a day',
      name: 'pick_a_day',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Scheduling`
  String get confirm_remodeling {
    return Intl.message(
      'Confirm Scheduling',
      name: 'confirm_remodeling',
      desc: '',
      args: [],
    );
  }

  /// `Contact Number`
  String get contact_number {
    return Intl.message(
      'Contact Number',
      name: 'contact_number',
      desc: '',
      args: [],
    );
  }

  /// `Hong Kong number only`
  String get hong_kong_number_only {
    return Intl.message(
      'Hong Kong number only',
      name: 'hong_kong_number_only',
      desc: '',
      args: [],
    );
  }

  /// `Name of the building`
  String get address_line1_label {
    return Intl.message(
      'Name of the building',
      name: 'address_line1_label',
      desc: '',
      args: [],
    );
  }

  /// `Housing estate or street number`
  String get address_line2_label {
    return Intl.message(
      'Housing estate or street number',
      name: 'address_line2_label',
      desc: '',
      args: [],
    );
  }

  /// `e.g. Acacia Garden or Acacia Building`
  String get address_line1_helper {
    return Intl.message(
      'e.g. Acacia Garden or Acacia Building',
      name: 'address_line1_helper',
      desc: '',
      args: [],
    );
  }

  /// `e.g. Acacia Garden or 105 Kennedy Road`
  String get address_line2_helper {
    return Intl.message(
      'e.g. Acacia Garden or 105 Kennedy Road',
      name: 'address_line2_helper',
      desc: '',
      args: [],
    );
  }

  /// `District`
  String get district {
    return Intl.message(
      'District',
      name: 'district',
      desc: '',
      args: [],
    );
  }

  /// `Hong Kong`
  String get hong_kong {
    return Intl.message(
      'Hong Kong',
      name: 'hong_kong',
      desc: '',
      args: [],
    );
  }

  /// `Kowloon`
  String get kowloon {
    return Intl.message(
      'Kowloon',
      name: 'kowloon',
      desc: '',
      args: [],
    );
  }

  /// `New Territories`
  String get new_territories {
    return Intl.message(
      'New Territories',
      name: 'new_territories',
      desc: '',
      args: [],
    );
  }

  /// `Region`
  String get region {
    return Intl.message(
      'Region',
      name: 'region',
      desc: '',
      args: [],
    );
  }

  /// `Miss`
  String get miss {
    return Intl.message(
      'Miss',
      name: 'miss',
      desc: '',
      args: [],
    );
  }

  /// `Mr.`
  String get mr {
    return Intl.message(
      'Mr.',
      name: 'mr',
      desc: '',
      args: [],
    );
  }

  /// `Mrs.`
  String get mrs {
    return Intl.message(
      'Mrs.',
      name: 'mrs',
      desc: '',
      args: [],
    );
  }

  /// `Ms.`
  String get ms {
    return Intl.message(
      'Ms.',
      name: 'ms',
      desc: '',
      args: [],
    );
  }

  /// `sq. ft`
  String get sq_ft {
    return Intl.message(
      'sq. ft',
      name: 'sq_ft',
      desc: '',
      args: [],
    );
  }

  /// `Rent`
  String get rent_properties {
    return Intl.message(
      'Rent',
      name: 'rent_properties',
      desc: '',
      args: [],
    );
  }

  /// `Find`
  String get find_properties {
    return Intl.message(
      'Find',
      name: 'find_properties',
      desc: '',
      args: [],
    );
  }

  /// `Latest Additions`
  String get latest_additions {
    return Intl.message(
      'Latest Additions',
      name: 'latest_additions',
      desc: '',
      args: [],
    );
  }

  /// `District/Name of the estate`
  String get search_properties_hint {
    return Intl.message(
      'District/Name of the estate',
      name: 'search_properties_hint',
      desc: '',
      args: [],
    );
  }

  /// `Cannot recognize speech`
  String get msg_cannot_recognize_speech {
    return Intl.message(
      'Cannot recognize speech',
      name: 'msg_cannot_recognize_speech',
      desc: '',
      args: [],
    );
  }

  /// `Voice search is unavailable`
  String get msg_voice_search_unavailable {
    return Intl.message(
      'Voice search is unavailable',
      name: 'msg_voice_search_unavailable',
      desc: '',
      args: [],
    );
  }

  /// `Voice Search`
  String get voice_search {
    return Intl.message(
      'Voice Search',
      name: 'voice_search',
      desc: '',
      args: [],
    );
  }

  /// `Chinese (Cantonese)`
  String get cantonese {
    return Intl.message(
      'Chinese (Cantonese)',
      name: 'cantonese',
      desc: '',
      args: [],
    );
  }

  /// `Chinese (Mandarin)`
  String get mandarin {
    return Intl.message(
      'Chinese (Mandarin)',
      name: 'mandarin',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english_voice_input {
    return Intl.message(
      'English',
      name: 'english_voice_input',
      desc: '',
      args: [],
    );
  }

  /// `Gross area`
  String get area_gross {
    return Intl.message(
      'Gross area',
      name: 'area_gross',
      desc: '',
      args: [],
    );
  }

  /// `Net area`
  String get area_net {
    return Intl.message(
      'Net area',
      name: 'area_net',
      desc: '',
      args: [],
    );
  }

  /// `Pick the date and time`
  String get pick_datetime {
    return Intl.message(
      'Pick the date and time',
      name: 'pick_datetime',
      desc: '',
      args: [],
    );
  }

  /// `Gross`
  String get area_gross_abr {
    return Intl.message(
      'Gross',
      name: 'area_gross_abr',
      desc: '',
      args: [],
    );
  }

  /// `Net`
  String get area_net_abr {
    return Intl.message(
      'Net',
      name: 'area_net_abr',
      desc: '',
      args: [],
    );
  }

  /// `sq. ft`
  String get sq_ft_abr {
    return Intl.message(
      'sq. ft',
      name: 'sq_ft_abr',
      desc: '',
      args: [],
    );
  }

  /// `Preferred date and time`
  String get date_time_selected {
    return Intl.message(
      'Preferred date and time',
      name: 'date_time_selected',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `AM`
  String get am {
    return Intl.message(
      'AM',
      name: 'am',
      desc: '',
      args: [],
    );
  }

  /// `PM`
  String get pm {
    return Intl.message(
      'PM',
      name: 'pm',
      desc: '',
      args: [],
    );
  }

  /// `Afternoon`
  String get afternoon {
    return Intl.message(
      'Afternoon',
      name: 'afternoon',
      desc: '',
      args: [],
    );
  }

  /// `Morning`
  String get morning {
    return Intl.message(
      'Morning',
      name: 'morning',
      desc: '',
      args: [],
    );
  }

  /// `Biometric authentication failed`
  String get biometric_authentication_failed {
    return Intl.message(
      'Biometric authentication failed',
      name: 'biometric_authentication_failed',
      desc: '',
      args: [],
    );
  }

  /// `Sign the property visit agreement with biometric authentication`
  String get reason_sign_property_visit_agreement {
    return Intl.message(
      'Sign the property visit agreement with biometric authentication',
      name: 'reason_sign_property_visit_agreement',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Signed`
  String get signed {
    return Intl.message(
      'Signed',
      name: 'signed',
      desc: '',
      args: [],
    );
  }

  /// `Contract Status`
  String get contract_status {
    return Intl.message(
      'Contract Status',
      name: 'contract_status',
      desc: '',
      args: [],
    );
  }

  /// `Visited Properties`
  String get visited_properties {
    return Intl.message(
      'Visited Properties',
      name: 'visited_properties',
      desc: '',
      args: [],
    );
  }

  /// `Properties visited in the last 30 days`
  String get properties_visited_last_thirty_days {
    return Intl.message(
      'Properties visited in the last 30 days',
      name: 'properties_visited_last_thirty_days',
      desc: '',
      args: [],
    );
  }

  /// `Make an Offer`
  String get negotiate_contract {
    return Intl.message(
      'Make an Offer',
      name: 'negotiate_contract',
      desc: '',
      args: [],
    );
  }

  /// `Tenant signs the contract`
  String get tenant_sign_contract {
    return Intl.message(
      'Tenant signs the contract',
      name: 'tenant_sign_contract',
      desc: '',
      args: [],
    );
  }

  /// `Landlord accepts / counteroffer`
  String get landlord_accept_offer {
    return Intl.message(
      'Landlord accepts / counteroffer',
      name: 'landlord_accept_offer',
      desc: '',
      args: [],
    );
  }

  /// `Landlord signs the contract`
  String get landlord_sign_contract {
    return Intl.message(
      'Landlord signs the contract',
      name: 'landlord_sign_contract',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get confirm_contract {
    return Intl.message(
      '',
      name: 'confirm_contract',
      desc: '',
      args: [],
    );
  }

  /// `Property Address`
  String get property_address {
    return Intl.message(
      'Property Address',
      name: 'property_address',
      desc: '',
      args: [],
    );
  }

  /// `Property has been removed`
  String get property_has_been_removed {
    return Intl.message(
      'Property has been removed',
      name: 'property_has_been_removed',
      desc: '',
      args: [],
    );
  }

  /// `Undo`
  String get undo {
    return Intl.message(
      'Undo',
      name: 'undo',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Rent`
  String get monthly_rent {
    return Intl.message(
      'Monthly Rent',
      name: 'monthly_rent',
      desc: '',
      args: [],
    );
  }

  /// `Deposit`
  String get deposit {
    return Intl.message(
      'Deposit',
      name: 'deposit',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Sign Contract`
  String get sign_contract {
    return Intl.message(
      'Sign Contract',
      name: 'sign_contract',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `End Date`
  String get end_date {
    return Intl.message(
      'End Date',
      name: 'end_date',
      desc: '',
      args: [],
    );
  }

  /// `Start Date`
  String get start_date {
    return Intl.message(
      'Start Date',
      name: 'start_date',
      desc: '',
      args: [],
    );
  }

  /// `Invalid date`
  String get invalid_date {
    return Intl.message(
      'Invalid date',
      name: 'invalid_date',
      desc: '',
      args: [],
    );
  }

  /// `Tenant pays the following:`
  String get tenant_pays_the_following {
    return Intl.message(
      'Tenant pays the following:',
      name: 'tenant_pays_the_following',
      desc: '',
      args: [],
    );
  }

  /// `Electricity`
  String get bill_electricity {
    return Intl.message(
      'Electricity',
      name: 'bill_electricity',
      desc: '',
      args: [],
    );
  }

  /// `Water`
  String get bill_water {
    return Intl.message(
      'Water',
      name: 'bill_water',
      desc: '',
      args: [],
    );
  }

  /// `Gas`
  String get bill_gas {
    return Intl.message(
      'Gas',
      name: 'bill_gas',
      desc: '',
      args: [],
    );
  }

  /// `Rates`
  String get bill_rates {
    return Intl.message(
      'Rates',
      name: 'bill_rates',
      desc: '',
      args: [],
    );
  }

  /// `Management`
  String get bill_management {
    return Intl.message(
      'Management',
      name: 'bill_management',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get notes {
    return Intl.message(
      'Notes',
      name: 'notes',
      desc: '',
      args: [],
    );
  }

  /// `This device cannot use biometric authentication, please choose "Sign on Visit"`
  String get biometric_authentication_unavailable_agreement {
    return Intl.message(
      'This device cannot use biometric authentication, please choose "Sign on Visit"',
      name: 'biometric_authentication_unavailable_agreement',
      desc: '',
      args: [],
    );
  }

  /// `This device cannot use biometric authentication`
  String get biometric_authentication_unavailable {
    return Intl.message(
      'This device cannot use biometric authentication',
      name: 'biometric_authentication_unavailable',
      desc: '',
      args: [],
    );
  }

  /// `Sign the rental contract with biometric authentication`
  String get reason_sign_rental_contract {
    return Intl.message(
      'Sign the rental contract with biometric authentication',
      name: 'reason_sign_rental_contract',
      desc: '',
      args: [],
    );
  }

  /// `First name`
  String get first_name {
    return Intl.message(
      'First name',
      name: 'first_name',
      desc: '',
      args: [],
    );
  }

  /// `Last name`
  String get last_name {
    return Intl.message(
      'Last name',
      name: 'last_name',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `ID card no.`
  String get id_card_number {
    return Intl.message(
      'ID card no.',
      name: 'id_card_number',
      desc: '',
      args: [],
    );
  }

  /// `Mailing address`
  String get mailing_address {
    return Intl.message(
      'Mailing address',
      name: 'mailing_address',
      desc: '',
      args: [],
    );
  }

  /// `residential lease\n\nThis contract was signed on (day/month/year) 05/06/2021 by the landlord and the tenant. The details of the two parties are listed in Schedule 1.\n\nThe Landlord and the Tenant both rent out and lease the properties detailed in Table 1 for the lease terms and rents detailed in Table 1, and agree to abide by and perform the following terms:\n\n1. The tenant must pay the specified rent to the landlord on or before the 1st of each month of the lease term. If the tenant does not pay the rent within seven days of the date when the rent is due, the landlord has the right to take appropriate action to recover the rent at the tenant's expense, and all costs and Expenses will constitute a debt of the tenant's landlord, and the landlord will be entitled to recover the full amount of all monies together with the tenant.\n\n2. The Tenant shall not make any alterations and/or additions to the property without the written consent of the Landlord.\n\n3. The tenant shall not assign, sublet or sublet the property or any other part or transfer the right to occupy the property or any other part to any other person\nWait. This leasehold interest is owned by the tenant personally.\n\n4. Tenants are required to abide by a number of Hong Kong laws and regulations and the terms of the mutual covenant in relation to the building to which the property belongs. The tenant shall also not violate the\nany restrictive clauses in the official title deed within the lot.\n\n5. The tenant is required to settle the water, electricity, gas, telephone and other similar miscellaneous charges for the property within the lease term.\n\n6. The tenant must keep the property in good repair during the lease term (except for natural wear and tear and damage caused by inherent defects) and must hand over the property in the same state of repair at the expiration or termination of the lease. Ji back to the owner.`
  String get lease_contract {
    return Intl.message(
      'residential lease\n\nThis contract was signed on (day/month/year) 05/06/2021 by the landlord and the tenant. The details of the two parties are listed in Schedule 1.\n\nThe Landlord and the Tenant both rent out and lease the properties detailed in Table 1 for the lease terms and rents detailed in Table 1, and agree to abide by and perform the following terms:\n\n1. The tenant must pay the specified rent to the landlord on or before the 1st of each month of the lease term. If the tenant does not pay the rent within seven days of the date when the rent is due, the landlord has the right to take appropriate action to recover the rent at the tenant\'s expense, and all costs and Expenses will constitute a debt of the tenant\'s landlord, and the landlord will be entitled to recover the full amount of all monies together with the tenant.\n\n2. The Tenant shall not make any alterations and/or additions to the property without the written consent of the Landlord.\n\n3. The tenant shall not assign, sublet or sublet the property or any other part or transfer the right to occupy the property or any other part to any other person\nWait. This leasehold interest is owned by the tenant personally.\n\n4. Tenants are required to abide by a number of Hong Kong laws and regulations and the terms of the mutual covenant in relation to the building to which the property belongs. The tenant shall also not violate the\nany restrictive clauses in the official title deed within the lot.\n\n5. The tenant is required to settle the water, electricity, gas, telephone and other similar miscellaneous charges for the property within the lease term.\n\n6. The tenant must keep the property in good repair during the lease term (except for natural wear and tear and damage caused by inherent defects) and must hand over the property in the same state of repair at the expiration or termination of the lease. Ji back to the owner.',
      name: 'lease_contract',
      desc: '',
      args: [],
    );
  }

  /// `After signing the contract, you can review the offer before submission`
  String get review_before_submission {
    return Intl.message(
      'After signing the contract, you can review the offer before submission',
      name: 'review_before_submission',
      desc: '',
      args: [],
    );
  }

  /// `Tenant Info`
  String get tenant_info {
    return Intl.message(
      'Tenant Info',
      name: 'tenant_info',
      desc: '',
      args: [],
    );
  }

  /// `Original`
  String get original {
    return Intl.message(
      'Original',
      name: 'original',
      desc: '',
      args: [],
    );
  }

  /// `Offered`
  String get offered {
    return Intl.message(
      'Offered',
      name: 'offered',
      desc: '',
      args: [],
    );
  }

  /// `Tenant Paid Fees:`
  String get tenant_paid_fees_colon {
    return Intl.message(
      'Tenant Paid Fees:',
      name: 'tenant_paid_fees_colon',
      desc: '',
      args: [],
    );
  }

  /// `Lease Terms`
  String get lease_terms {
    return Intl.message(
      'Lease Terms',
      name: 'lease_terms',
      desc: '',
      args: [],
    );
  }

  /// `month`
  String get month {
    return Intl.message(
      'month',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `Save for later`
  String get save_for_later {
    return Intl.message(
      'Save for later',
      name: 'save_for_later',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove_property_from_cart {
    return Intl.message(
      'Remove',
      name: 'remove_property_from_cart',
      desc: '',
      args: [],
    );
  }

  /// `Visit`
  String get property_visit {
    return Intl.message(
      'Visit',
      name: 'property_visit',
      desc: '',
      args: [],
    );
  }

  /// `Agreement`
  String get property_visit_agreement {
    return Intl.message(
      'Agreement',
      name: 'property_visit_agreement',
      desc: '',
      args: [],
    );
  }

  /// `1. "Agent": I, David, ("Tenant"), hereby appoint hometeam Property Management And Agency Limited as myself in connection with the proposed tenancy of the property set forth in Schedule 1 to this Agreement (the "Property") subject to the terms of this Agreement 's agent.\n\n2. "Validity period": This agreement will take effect from January 1, 2021 to March 31 of the same year (both days inclusive).\n\n3. The agency relationship between the Agent and the Tenant in relation to the Property is a bilateral agency as specified in Column 4 of Schedule 1 to this Agreement.\n\n4. In the case of a bilateral agency relationship, the agency must disclose to the tenant in writing as soon as practicable the amount or rate of commission that the agency will charge the relevant landlord.\n\n5. In addition to the obligations imposed on the Agent by this Agreement or any statute, the Agent shall also perform the obligations set forth in Schedule 2 to this Agreement.\n\n6. "Commission": The provisions of this Agreement governing the commission payable by the Tenant to the Agent are set forth in Schedules 1, 3 and 5 to this Agreement (4).\n\n7. "Property Information": The agent shall provide the tenant with all relevant rental information forms prescribed in the Estate Agents Practice (General Duties and Hong Kong Residential Properties) Regulation in respect of the property.\n\n8. In the case of a bilateral agency relationship, or where the owner is not represented by a licensed estate agent, these forms must be completed and signed by the agent.\n\n9. "Commission": The provisions of this Agreement governing the commission payable by the Tenant to the Agent are set forth in Schedules 1, 3 and 5 to this Agreement (4).`
  String get property_visit_agreement_content {
    return Intl.message(
      '1. "Agent": I, David, ("Tenant"), hereby appoint hometeam Property Management And Agency Limited as myself in connection with the proposed tenancy of the property set forth in Schedule 1 to this Agreement (the "Property") subject to the terms of this Agreement \'s agent.\n\n2. "Validity period": This agreement will take effect from January 1, 2021 to March 31 of the same year (both days inclusive).\n\n3. The agency relationship between the Agent and the Tenant in relation to the Property is a bilateral agency as specified in Column 4 of Schedule 1 to this Agreement.\n\n4. In the case of a bilateral agency relationship, the agency must disclose to the tenant in writing as soon as practicable the amount or rate of commission that the agency will charge the relevant landlord.\n\n5. In addition to the obligations imposed on the Agent by this Agreement or any statute, the Agent shall also perform the obligations set forth in Schedule 2 to this Agreement.\n\n6. "Commission": The provisions of this Agreement governing the commission payable by the Tenant to the Agent are set forth in Schedules 1, 3 and 5 to this Agreement (4).\n\n7. "Property Information": The agent shall provide the tenant with all relevant rental information forms prescribed in the Estate Agents Practice (General Duties and Hong Kong Residential Properties) Regulation in respect of the property.\n\n8. In the case of a bilateral agency relationship, or where the owner is not represented by a licensed estate agent, these forms must be completed and signed by the agent.\n\n9. "Commission": The provisions of this Agreement governing the commission payable by the Tenant to the Agent are set forth in Schedules 1, 3 and 5 to this Agreement (4).',
      name: 'property_visit_agreement_content',
      desc: '',
      args: [],
    );
  }

  /// `Visiting Date`
  String get property_visit_date {
    return Intl.message(
      'Visiting Date',
      name: 'property_visit_date',
      desc: '',
      args: [],
    );
  }

  /// `Choose the route`
  String get choose_the_route {
    return Intl.message(
      'Choose the route',
      name: 'choose_the_route',
      desc: '',
      args: [],
    );
  }

  /// `Est.`
  String get estimated_duration {
    return Intl.message(
      'Est.',
      name: 'estimated_duration',
      desc: '',
      args: [],
    );
  }

  /// `hr`
  String get hour {
    return Intl.message(
      'hr',
      name: 'hour',
      desc: '',
      args: [],
    );
  }

  /// `hrs`
  String get hours {
    return Intl.message(
      'hrs',
      name: 'hours',
      desc: '',
      args: [],
    );
  }

  /// `minute`
  String get minute {
    return Intl.message(
      'minute',
      name: 'minute',
      desc: '',
      args: [],
    );
  }

  /// `minutes`
  String get minutes {
    return Intl.message(
      'minutes',
      name: 'minutes',
      desc: '',
      args: [],
    );
  }

  /// `Cameras are not available`
  String get cameras_not_available {
    return Intl.message(
      'Cameras are not available',
      name: 'cameras_not_available',
      desc: '',
      args: [],
    );
  }

  /// `Processing`
  String get processing {
    return Intl.message(
      'Processing',
      name: 'processing',
      desc: '',
      args: [],
    );
  }

  /// `Select from Gallery`
  String get select_from_gallery {
    return Intl.message(
      'Select from Gallery',
      name: 'select_from_gallery',
      desc: '',
      args: [],
    );
  }

  /// `No photo is required`
  String get photo_not_required {
    return Intl.message(
      'No photo is required',
      name: 'photo_not_required',
      desc: '',
      args: [],
    );
  }

  /// `Photos are required`
  String get photo_required {
    return Intl.message(
      'Photos are required',
      name: 'photo_required',
      desc: '',
      args: [],
    );
  }

  /// `Photos have been added`
  String get photo_added {
    return Intl.message(
      'Photos have been added',
      name: 'photo_added',
      desc: '',
      args: [],
    );
  }

  /// `Add photos`
  String get add_photos {
    return Intl.message(
      'Add photos',
      name: 'add_photos',
      desc: '',
      args: [],
    );
  }

  /// `Take photo`
  String get take_photo {
    return Intl.message(
      'Take photo',
      name: 'take_photo',
      desc: '',
      args: [],
    );
  }

  /// `Change photo`
  String get change_photo {
    return Intl.message(
      'Change photo',
      name: 'change_photo',
      desc: '',
      args: [],
    );
  }

  /// `Contact Person`
  String get contact_person {
    return Intl.message(
      'Contact Person',
      name: 'contact_person',
      desc: '',
      args: [],
    );
  }

  /// `Tenant`
  String get tenant {
    return Intl.message(
      'Tenant',
      name: 'tenant',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get sign_in {
    return Intl.message(
      'Sign in',
      name: 'sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Cannot sign in`
  String get msg_cannot_sign_in {
    return Intl.message(
      'Cannot sign in',
      name: 'msg_cannot_sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Sign out`
  String get sign_out {
    return Intl.message(
      'Sign out',
      name: 'sign_out',
      desc: '',
      args: [],
    );
  }

  /// `(Not signed in)`
  String get not_signed_in {
    return Intl.message(
      '(Not signed in)',
      name: 'not_signed_in',
      desc: '',
      args: [],
    );
  }

  /// `Send SMS code`
  String get send_sms_code {
    return Intl.message(
      'Send SMS code',
      name: 'send_sms_code',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phone_number {
    return Intl.message(
      'Phone Number',
      name: 'phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Please input a valid Hong Kong phone number`
  String get msg_please_input_valid_phone_number {
    return Intl.message(
      'Please input a valid Hong Kong phone number',
      name: 'msg_please_input_valid_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for SMS code autofill`
  String get waiting_for_sms_code_autofill {
    return Intl.message(
      'Waiting for SMS code autofill',
      name: 'waiting_for_sms_code_autofill',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Facebook`
  String get continue_with_facebook {
    return Intl.message(
      'Continue with Facebook',
      name: 'continue_with_facebook',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Google`
  String get continue_with_google {
    return Intl.message(
      'Continue with Google',
      name: 'continue_with_google',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get or {
    return Intl.message(
      'or',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `Create a free account`
  String get create_a_free_account {
    return Intl.message(
      'Create a free account',
      name: 'create_a_free_account',
      desc: '',
      args: [],
    );
  }

  /// `Account found`
  String get account_found {
    return Intl.message(
      'Account found',
      name: 'account_found',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with the following method`
  String get sign_in_with_the_following_method {
    return Intl.message(
      'Sign in with the following method',
      name: 'sign_in_with_the_following_method',
      desc: '',
      args: [],
    );
  }

  /// `Continue with email`
  String get continue_with_email {
    return Intl.message(
      'Continue with email',
      name: 'continue_with_email',
      desc: '',
      args: [],
    );
  }

  /// `Continue with SMS`
  String get continue_with_sms {
    return Intl.message(
      'Continue with SMS',
      name: 'continue_with_sms',
      desc: '',
      args: [],
    );
  }

  /// `or create a free account`
  String get or_create_a_free_account {
    return Intl.message(
      'or create a free account',
      name: 'or_create_a_free_account',
      desc: '',
      args: [],
    );
  }

  /// `What's your phone number?`
  String get what_is_your_phone_number {
    return Intl.message(
      'What\'s your phone number?',
      name: 'what_is_your_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message(
      'Verify',
      name: 'verify',
      desc: '',
      args: [],
    );
  }

  /// `SMS Verification failed`
  String get msg_sms_verification_failed {
    return Intl.message(
      'SMS Verification failed',
      name: 'msg_sms_verification_failed',
      desc: '',
      args: [],
    );
  }

  /// `Invalid phone number`
  String get msg_invalid_phone_number {
    return Intl.message(
      'Invalid phone number',
      name: 'msg_invalid_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `App Settings`
  String get app_settings {
    return Intl.message(
      'App Settings',
      name: 'app_settings',
      desc: '',
      args: [],
    );
  }

  /// `Off`
  String get setting_off {
    return Intl.message(
      'Off',
      name: 'setting_off',
      desc: '',
      args: [],
    );
  }

  /// `On`
  String get setting_on {
    return Intl.message(
      'On',
      name: 'setting_on',
      desc: '',
      args: [],
    );
  }

  /// `Use system settings`
  String get use_system_settings {
    return Intl.message(
      'Use system settings',
      name: 'use_system_settings',
      desc: '',
      args: [],
    );
  }

  /// `Landlord mode`
  String get landlord_mode {
    return Intl.message(
      'Landlord mode',
      name: 'landlord_mode',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get dashboard {
    return Intl.message(
      'Dashboard',
      name: 'dashboard',
      desc: '',
      args: [],
    );
  }

  /// `Properties`
  String get properties {
    return Intl.message(
      'Properties',
      name: 'properties',
      desc: '',
      args: [],
    );
  }

  /// `Rentals`
  String get rentals {
    return Intl.message(
      'Rentals',
      name: 'rentals',
      desc: '',
      args: [],
    );
  }

  /// `Add Property`
  String get add_property {
    return Intl.message(
      'Add Property',
      name: 'add_property',
      desc: '',
      args: [],
    );
  }

  /// `Schedule Visit`
  String get schedule_visit {
    return Intl.message(
      'Schedule Visit',
      name: 'schedule_visit',
      desc: '',
      args: [],
    );
  }

  /// `Property Info`
  String get property_info {
    return Intl.message(
      'Property Info',
      name: 'property_info',
      desc: '',
      args: [],
    );
  }

  /// `Create Listing`
  String get create_listing {
    return Intl.message(
      'Create Listing',
      name: 'create_listing',
      desc: '',
      args: [],
    );
  }

  /// `Sign on site`
  String get sign_on_site {
    return Intl.message(
      'Sign on site',
      name: 'sign_on_site',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Sign`
  String get sign {
    return Intl.message(
      'Sign',
      name: 'sign',
      desc: '',
      args: [],
    );
  }

  /// `Info required`
  String get msg_info_required {
    return Intl.message(
      'Info required',
      name: 'msg_info_required',
      desc: '',
      args: [],
    );
  }

  /// `Contract`
  String get contracts {
    return Intl.message(
      'Contract',
      name: 'contracts',
      desc: '',
      args: [],
    );
  }

  /// `Contract`
  String get contract {
    return Intl.message(
      'Contract',
      name: 'contract',
      desc: '',
      args: [],
    );
  }

  /// `Failed to generate the path of visit`
  String get msg_failed_to_generate_visit_path {
    return Intl.message(
      'Failed to generate the path of visit',
      name: 'msg_failed_to_generate_visit_path',
      desc: '',
      args: [],
    );
  }

  /// `Floor`
  String get address_floor {
    return Intl.message(
      'Floor',
      name: 'address_floor',
      desc: '',
      args: [],
    );
  }

  /// `Flat`
  String get address_flat {
    return Intl.message(
      'Flat',
      name: 'address_flat',
      desc: '',
      args: [],
    );
  }

  /// `Block`
  String get address_block {
    return Intl.message(
      'Block',
      name: 'address_block',
      desc: '',
      args: [],
    );
  }

  /// `Living/Dining room`
  String get living_dining_room {
    return Intl.message(
      'Living/Dining room',
      name: 'living_dining_room',
      desc: '',
      args: [],
    );
  }

  /// `Bedroom`
  String get bedroom {
    return Intl.message(
      'Bedroom',
      name: 'bedroom',
      desc: '',
      args: [],
    );
  }

  /// `Bathroom`
  String get bathroom {
    return Intl.message(
      'Bathroom',
      name: 'bathroom',
      desc: '',
      args: [],
    );
  }

  /// `Covered parking`
  String get covered_parking {
    return Intl.message(
      'Covered parking',
      name: 'covered_parking',
      desc: '',
      args: [],
    );
  }

  /// `Open parking`
  String get open_parking {
    return Intl.message(
      'Open parking',
      name: 'open_parking',
      desc: '',
      args: [],
    );
  }

  /// `Others`
  String get others {
    return Intl.message(
      'Others',
      name: 'others',
      desc: '',
      args: [],
    );
  }

  /// `Accept/Offer`
  String get accept_or_offer {
    return Intl.message(
      'Accept/Offer',
      name: 'accept_or_offer',
      desc: '',
      args: [],
    );
  }

  /// `Structure`
  String get structure {
    return Intl.message(
      'Structure',
      name: 'structure',
      desc: '',
      args: [],
    );
  }

  /// `Fixture`
  String get fixture {
    return Intl.message(
      'Fixture',
      name: 'fixture',
      desc: '',
      args: [],
    );
  }

  /// `Furniture`
  String get furniture {
    return Intl.message(
      'Furniture',
      name: 'furniture',
      desc: '',
      args: [],
    );
  }

  /// `Negotiable`
  String get negotiable {
    return Intl.message(
      'Negotiable',
      name: 'negotiable',
      desc: '',
      args: [],
    );
  }

  /// `Earliest start date`
  String get lease_earliest_start_date {
    return Intl.message(
      'Earliest start date',
      name: 'lease_earliest_start_date',
      desc: '',
      args: [],
    );
  }

  /// `Latest start date`
  String get lease_latest_start_date {
    return Intl.message(
      'Latest start date',
      name: 'lease_latest_start_date',
      desc: '',
      args: [],
    );
  }

  /// `Grace period (days)`
  String get grace_period_days {
    return Intl.message(
      'Grace period (days)',
      name: 'grace_period_days',
      desc: '',
      args: [],
    );
  }

  /// `Lease length (months)`
  String get lease_length_months {
    return Intl.message(
      'Lease length (months)',
      name: 'lease_length_months',
      desc: '',
      args: [],
    );
  }

  /// `Termination notice (days)`
  String get termination_notice_days {
    return Intl.message(
      'Termination notice (days)',
      name: 'termination_notice_days',
      desc: '',
      args: [],
    );
  }

  /// `Earliest termination day`
  String get earliest_termination_day {
    return Intl.message(
      'Earliest termination day',
      name: 'earliest_termination_day',
      desc: '',
      args: [],
    );
  }

  /// `Days notice before termination`
  String get termination_notice_helper_text {
    return Intl.message(
      'Days notice before termination',
      name: 'termination_notice_helper_text',
      desc: '',
      args: [],
    );
  }

  /// `Both`
  String get both_party {
    return Intl.message(
      'Both',
      name: 'both_party',
      desc: '',
      args: [],
    );
  }

  /// `Early termination right`
  String get early_termination_right {
    return Intl.message(
      'Early termination right',
      name: 'early_termination_right',
      desc: '',
      args: [],
    );
  }

  /// `Landlord`
  String get landlord {
    return Intl.message(
      'Landlord',
      name: 'landlord',
      desc: '',
      args: [],
    );
  }

  /// `Rent`
  String get rent {
    return Intl.message(
      'Rent',
      name: 'rent',
      desc: '',
      args: [],
    );
  }

  /// `Will be shown as this date or today, which ever is the latest`
  String get lease_earliest_start_date_helper_text {
    return Intl.message(
      'Will be shown as this date or today, which ever is the latest',
      name: 'lease_earliest_start_date_helper_text',
      desc: '',
      args: [],
    );
  }

  /// `The date should be after the earliest start date`
  String get msg_input_before_earliest_start {
    return Intl.message(
      'The date should be after the earliest start date',
      name: 'msg_input_before_earliest_start',
      desc: '',
      args: [],
    );
  }

  /// `Lease Period`
  String get lease_period {
    return Intl.message(
      'Lease Period',
      name: 'lease_period',
      desc: '',
      args: [],
    );
  }

  /// `End date`
  String get lease_end_date {
    return Intl.message(
      'End date',
      name: 'lease_end_date',
      desc: '',
      args: [],
    );
  }

  /// `Show to tenant`
  String get show_to_tenant_two_lines {
    return Intl.message(
      'Show to tenant',
      name: 'show_to_tenant_two_lines',
      desc: '',
      args: [],
    );
  }

  /// `Expenses paid by the Landlord\n(except for normal wear and tear)`
  String get expenses_paid_by_the_landlord_except {
    return Intl.message(
      'Expenses paid by the Landlord\n(except for normal wear and tear)',
      name: 'expenses_paid_by_the_landlord_except',
      desc: '',
      args: [],
    );
  }

  /// `Electrical appliance`
  String get electrical_appliances {
    return Intl.message(
      'Electrical appliance',
      name: 'electrical_appliances',
      desc: '',
      args: [],
    );
  }

  /// `Washer`
  String get washer {
    return Intl.message(
      'Washer',
      name: 'washer',
      desc: '',
      args: [],
    );
  }

  /// `Dryer`
  String get dryer {
    return Intl.message(
      'Dryer',
      name: 'dryer',
      desc: '',
      args: [],
    );
  }

  /// `AC`
  String get ac {
    return Intl.message(
      'AC',
      name: 'ac',
      desc: '',
      args: [],
    );
  }

  /// `Fridge`
  String get fridge {
    return Intl.message(
      'Fridge',
      name: 'fridge',
      desc: '',
      args: [],
    );
  }

  /// `Water heater`
  String get water_heater {
    return Intl.message(
      'Water heater',
      name: 'water_heater',
      desc: '',
      args: [],
    );
  }

  /// `Stove`
  String get stove {
    return Intl.message(
      'Stove',
      name: 'stove',
      desc: '',
      args: [],
    );
  }

  /// `Range hood`
  String get range_hood {
    return Intl.message(
      'Range hood',
      name: 'range_hood',
      desc: '',
      args: [],
    );
  }

  /// `Washer dryer combo`
  String get washer_dryer_combo_two_lines {
    return Intl.message(
      'Washer dryer combo',
      name: 'washer_dryer_combo_two_lines',
      desc: '',
      args: [],
    );
  }

  /// `The property has been uploaded`
  String get property_has_been_uploaded {
    return Intl.message(
      'The property has been uploaded',
      name: 'property_has_been_uploaded',
      desc: '',
      args: [],
    );
  }

  /// `View`
  String get view {
    return Intl.message(
      'View',
      name: 'view',
      desc: '',
      args: [],
    );
  }

  /// `Upload property failed`
  String get property_upload_error {
    return Intl.message(
      'Upload property failed',
      name: 'property_upload_error',
      desc: '',
      args: [],
    );
  }

  /// `Photos are optional`
  String get photo_optional {
    return Intl.message(
      'Photos are optional',
      name: 'photo_optional',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Video`
  String get video {
    return Intl.message(
      'Video',
      name: 'video',
      desc: '',
      args: [],
    );
  }

  /// `Add a video`
  String get add_video {
    return Intl.message(
      'Add a video',
      name: 'add_video',
      desc: '',
      args: [],
    );
  }

  /// `Video is required`
  String get video_required {
    return Intl.message(
      'Video is required',
      name: 'video_required',
      desc: '',
      args: [],
    );
  }

  /// `Video has been added`
  String get video_added {
    return Intl.message(
      'Video has been added',
      name: 'video_added',
      desc: '',
      args: [],
    );
  }

  /// `Record`
  String get record {
    return Intl.message(
      'Record',
      name: 'record',
      desc: '',
      args: [],
    );
  }

  /// `Video removed`
  String get video_removed {
    return Intl.message(
      'Video removed',
      name: 'video_removed',
      desc: '',
      args: [],
    );
  }

  /// `Playback speed`
  String get playback_speed {
    return Intl.message(
      'Playback speed',
      name: 'playback_speed',
      desc: '',
      args: [],
    );
  }

  /// `Subtitles`
  String get subtitles {
    return Intl.message(
      'Subtitles',
      name: 'subtitles',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in the required information`
  String get msg_please_fill_in_the_required_information {
    return Intl.message(
      'Please fill in the required information',
      name: 'msg_please_fill_in_the_required_information',
      desc: '',
      args: [],
    );
  }

  /// `Please enter password`
  String get msg_please_enter_password {
    return Intl.message(
      'Please enter password',
      name: 'msg_please_enter_password',
      desc: '',
      args: [],
    );
  }

  /// `Please manually enter the SMS Code`
  String get msg_please_manually_enter_sms_code {
    return Intl.message(
      'Please manually enter the SMS Code',
      name: 'msg_please_manually_enter_sms_code',
      desc: '',
      args: [],
    );
  }

  /// `Please put in a valid date`
  String get msg_please_put_in_a_valid_date {
    return Intl.message(
      'Please put in a valid date',
      name: 'msg_please_put_in_a_valid_date',
      desc: '',
      args: [],
    );
  }

  /// `Please put in a valid amount`
  String get msg_please_put_in_a_valid_amount {
    return Intl.message(
      'Please put in a valid amount',
      name: 'msg_please_put_in_a_valid_amount',
      desc: '',
      args: [],
    );
  }

  /// `Uploading media`
  String get uploading_media {
    return Intl.message(
      'Uploading media',
      name: 'uploading_media',
      desc: '',
      args: [],
    );
  }

  /// `Remodeling options`
  String get remodeling_options {
    return Intl.message(
      'Remodeling options',
      name: 'remodeling_options',
      desc: '',
      args: [],
    );
  }

  /// `Remodeling address`
  String get remodeling_address {
    return Intl.message(
      'Remodeling address',
      name: 'remodeling_address',
      desc: '',
      args: [],
    );
  }

  /// `Painting`
  String get painting {
    return Intl.message(
      'Painting',
      name: 'painting',
      desc: '',
      args: [],
    );
  }

  /// `Wallcoverings`
  String get wallcoverings {
    return Intl.message(
      'Wallcoverings',
      name: 'wallcoverings',
      desc: '',
      args: [],
    );
  }

  /// `AC (window type)`
  String get ac_window_type {
    return Intl.message(
      'AC (window type)',
      name: 'ac_window_type',
      desc: '',
      args: [],
    );
  }

  /// `Removals`
  String get removals {
    return Intl.message(
      'Removals',
      name: 'removals',
      desc: '',
      args: [],
    );
  }

  /// `Toilet replacement`
  String get toilet_replacement {
    return Intl.message(
      'Toilet replacement',
      name: 'toilet_replacement',
      desc: '',
      args: [],
    );
  }

  /// `Pest Control`
  String get pest_control {
    return Intl.message(
      'Pest Control',
      name: 'pest_control',
      desc: '',
      args: [],
    );
  }

  /// `A front closeup of the current AC unit`
  String get imaging_instruction_ac_1 {
    return Intl.message(
      'A front closeup of the current AC unit',
      name: 'imaging_instruction_ac_1',
      desc: '',
      args: [],
    );
  }

  /// `The wall on which the AC unit will be installed`
  String get imaging_instruction_ac_2 {
    return Intl.message(
      'The wall on which the AC unit will be installed',
      name: 'imaging_instruction_ac_2',
      desc: '',
      args: [],
    );
  }

  /// `The room where the AC unit will be installed`
  String get imaging_instruction_ac_3 {
    return Intl.message(
      'The room where the AC unit will be installed',
      name: 'imaging_instruction_ac_3',
      desc: '',
      args: [],
    );
  }

  /// `Remodeling status`
  String get remodeling_status {
    return Intl.message(
      'Remodeling status',
      name: 'remodeling_status',
      desc: '',
      args: [],
    );
  }

  /// `Select remodeling items`
  String get msg_select_remodeling_item {
    return Intl.message(
      'Select remodeling items',
      name: 'msg_select_remodeling_item',
      desc: '',
      args: [],
    );
  }

  /// `Remodeling address and contact`
  String get remodeling_address_and_contacts {
    return Intl.message(
      'Remodeling address and contact',
      name: 'remodeling_address_and_contacts',
      desc: '',
      args: [],
    );
  }

  /// `Remodeling`
  String get remodeling {
    return Intl.message(
      'Remodeling',
      name: 'remodeling',
      desc: '',
      args: [],
    );
  }

  /// `Please put in a valid amount`
  String get please_put_in_a_valid_amount {
    return Intl.message(
      'Please put in a valid amount',
      name: 'please_put_in_a_valid_amount',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
