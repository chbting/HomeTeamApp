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

  /// `Remodeling`
  String get remodeling {
    return Intl.message(
      'Remodeling',
      name: 'remodeling',
      desc: '',
      args: [],
    );
  }

  /// `Agreements`
  String get agreements {
    return Intl.message(
      'Agreements',
      name: 'agreements',
      desc: '',
      args: [],
    );
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

  /// `Status`
  String get remodeling_status {
    return Intl.message(
      'Status',
      name: 'remodeling_status',
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

  /// `Pest Control`
  String get pest_control {
    return Intl.message(
      'Pest Control',
      name: 'pest_control',
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

  /// `Toilet Replacement`
  String get toilet_replacement {
    return Intl.message(
      'Toilet Replacement',
      name: 'toilet_replacement',
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

  /// `Please select an remodeling item`
  String get msg_select_remodeling_item {
    return Intl.message(
      'Please select an remodeling item',
      name: 'msg_select_remodeling_item',
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

  /// `Removals`
  String get removals {
    return Intl.message(
      'Removals',
      name: 'removals',
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

  /// `Remodeling Address`
  String get remodeling_address {
    return Intl.message(
      'Remodeling Address',
      name: 'remodeling_address',
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

  /// `Remodeling Start Date`
  String get remodeling_start_date {
    return Intl.message(
      'Remodeling Start Date',
      name: 'remodeling_start_date',
      desc: '',
      args: [],
    );
  }

  /// `Remodeling Options`
  String get remodeling_options {
    return Intl.message(
      'Remodeling Options',
      name: 'remodeling_options',
      desc: '',
      args: [],
    );
  }

  /// `Unit, floor, name of the building`
  String get address_line1_label {
    return Intl.message(
      'Unit, floor, name of the building',
      name: 'address_line1_label',
      desc: '',
      args: [],
    );
  }

  /// `Contacts & Remodeling Address`
  String get remodeling_address_and_contacts {
    return Intl.message(
      'Contacts & Remodeling Address',
      name: 'remodeling_address_and_contacts',
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

  /// `e.g. Flat 25, 12/F, Block 1`
  String get address_line1_helper {
    return Intl.message(
      'e.g. Flat 25, 12/F, Block 1',
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

  /// `AC (Window Type)`
  String get ac_window_type {
    return Intl.message(
      'AC (Window Type)',
      name: 'ac_window_type',
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

  /// `Area (Gross)`
  String get area_gross {
    return Intl.message(
      'Area (Gross)',
      name: 'area_gross',
      desc: '',
      args: [],
    );
  }

  /// `Area (S.A.)`
  String get area_net {
    return Intl.message(
      'Area (S.A.)',
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

  /// `S.A.`
  String get area_net_abr {
    return Intl.message(
      'S.A.',
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

  /// `Sign on Visit`
  String get sign_later {
    return Intl.message(
      'Sign on Visit',
      name: 'sign_later',
      desc: '',
      args: [],
    );
  }

  /// `Sign Now`
  String get sign_now {
    return Intl.message(
      'Sign Now',
      name: 'sign_now',
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

  /// `Fill in Personal Information`
  String get fill_in_personal_information {
    return Intl.message(
      'Fill in Personal Information',
      name: 'fill_in_personal_information',
      desc: '',
      args: [],
    );
  }

  /// `Accept / Make an offer`
  String get accept_or_make_an_offer {
    return Intl.message(
      'Accept / Make an offer',
      name: 'accept_or_make_an_offer',
      desc: '',
      args: [],
    );
  }

  /// `Sign the Contract`
  String get sign_the_contract {
    return Intl.message(
      'Sign the Contract',
      name: 'sign_the_contract',
      desc: '',
      args: [],
    );
  }

  /// `Confirm and Submit`
  String get confirm_and_submit {
    return Intl.message(
      'Confirm and Submit',
      name: 'confirm_and_submit',
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

  /// `Please put in a valid amount`
  String get please_put_in_a_valid_amount {
    return Intl.message(
      'Please put in a valid amount',
      name: 'please_put_in_a_valid_amount',
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

  /// `Info Required`
  String get info_required {
    return Intl.message(
      'Info Required',
      name: 'info_required',
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

  /// `Tenant Information`
  String get tenant_info {
    return Intl.message(
      'Tenant Information',
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

  /// `Lease Period`
  String get lease_period {
    return Intl.message(
      'Lease Period',
      name: 'lease_period',
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

  /// `Properties`
  String get property {
    return Intl.message(
      'Properties',
      name: 'property',
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

  /// `1. "Agent": I, David, ("Tenant"), hereby appoint Tner Property Management And Agency Limited as myself in connection with the proposed tenancy of the property set forth in Schedule 1 to this Agreement (the "Property") subject to the terms of this Agreement 's agent.\n\n2. "Validity period": This agreement will take effect from January 1, 2021 to March 31 of the same year (both days inclusive).\n\n3. The agency relationship between the Agent and the Tenant in relation to the Property is a bilateral agency as specified in Column 4 of Schedule 1 to this Agreement.\n\n4. In the case of a bilateral agency relationship, the agency must disclose to the tenant in writing as soon as practicable the amount or rate of commission that the agency will charge the relevant landlord.\n\n5. In addition to the obligations imposed on the Agent by this Agreement or any statute, the Agent shall also perform the obligations set forth in Schedule 2 to this Agreement.\n\n6. "Commission": The provisions of this Agreement governing the commission payable by the Tenant to the Agent are set forth in Schedules 1, 3 and 5 to this Agreement (4).\n\n7. "Property Information": The agent shall provide the tenant with all relevant rental information forms prescribed in the Estate Agents Practice (General Duties and Hong Kong Residential Properties) Regulation in respect of the property.\n\n8. In the case of a bilateral agency relationship, or where the owner is not represented by a licensed estate agent, these forms must be completed and signed by the agent.\n\n9. "Commission": The provisions of this Agreement governing the commission payable by the Tenant to the Agent are set forth in Schedules 1, 3 and 5 to this Agreement (4).`
  String get property_visit_agreement_content {
    return Intl.message(
      '1. "Agent": I, David, ("Tenant"), hereby appoint Tner Property Management And Agency Limited as myself in connection with the proposed tenancy of the property set forth in Schedule 1 to this Agreement (the "Property") subject to the terms of this Agreement \'s agent.\n\n2. "Validity period": This agreement will take effect from January 1, 2021 to March 31 of the same year (both days inclusive).\n\n3. The agency relationship between the Agent and the Tenant in relation to the Property is a bilateral agency as specified in Column 4 of Schedule 1 to this Agreement.\n\n4. In the case of a bilateral agency relationship, the agency must disclose to the tenant in writing as soon as practicable the amount or rate of commission that the agency will charge the relevant landlord.\n\n5. In addition to the obligations imposed on the Agent by this Agreement or any statute, the Agent shall also perform the obligations set forth in Schedule 2 to this Agreement.\n\n6. "Commission": The provisions of this Agreement governing the commission payable by the Tenant to the Agent are set forth in Schedules 1, 3 and 5 to this Agreement (4).\n\n7. "Property Information": The agent shall provide the tenant with all relevant rental information forms prescribed in the Estate Agents Practice (General Duties and Hong Kong Residential Properties) Regulation in respect of the property.\n\n8. In the case of a bilateral agency relationship, or where the owner is not represented by a licensed estate agent, these forms must be completed and signed by the agent.\n\n9. "Commission": The provisions of this Agreement governing the commission payable by the Tenant to the Agent are set forth in Schedules 1, 3 and 5 to this Agreement (4).',
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

  /// `Schedule Properties Visit`
  String get schedule_property_visit {
    return Intl.message(
      'Schedule Properties Visit',
      name: 'schedule_property_visit',
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

  /// `Photo is not required`
  String get photo_not_required {
    return Intl.message(
      'Photo is not required',
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

  /// `Sign in with email`
  String get sign_in_with_email {
    return Intl.message(
      'Sign in with email',
      name: 'sign_in_with_email',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get sign_in_with_google {
    return Intl.message(
      'Sign in with Google',
      name: 'sign_in_with_google',
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
