class Contract {
  int monthlyRent;
  int deposit;

  //todo startDate, endDate, gracePeriod, minLeaseDuration;
  bool waterRequired;
  bool electricityRequired;
  bool gasRequired;
  bool ratesRequired;
  bool managementRequired;

  // todo serializable
  DateTime? startDate, endDate;

  Contract(
      {this.monthlyRent = -1,
      this.deposit = -1,
      this.waterRequired = true,
      this.electricityRequired = true,
      this.gasRequired = true,
      this.ratesRequired = true,
      this.managementRequired = true});

  Contract copyWith(
      {int? monthlyRent,
      int? deposit,
      bool? waterRequired,
      bool? electricityRequired,
      bool? gasRequired,
      bool? ratesRequired,
      bool? managementRequired}) {
    return Contract(
      monthlyRent: monthlyRent ?? this.monthlyRent,
      deposit: monthlyRent ?? this.deposit,
      waterRequired: waterRequired ?? this.waterRequired,
      electricityRequired: electricityRequired ?? this.electricityRequired,
      gasRequired: gasRequired ?? this.gasRequired,
      ratesRequired: ratesRequired ?? this.ratesRequired,
      managementRequired: managementRequired ?? this.managementRequired,
    );
  }
}
