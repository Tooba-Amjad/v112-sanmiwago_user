class UserMembershipDetails {
  String id;
  String userId;
  String membershipCategory;
  String giftcardMembershipNo;
  String membershipAmount;
  String dateTime;
  String percentage;

  UserMembershipDetails({
    this.id = "",
    this.userId = "",
    this.membershipCategory = "",
    this.giftcardMembershipNo = "",
    this.membershipAmount = "",
    this.dateTime = "",
    this.percentage = "",
  });

  UserMembershipDetails copyWith({
    String? id,
    String? userId,
    String? membershipCategory,
    String? giftcardMembershipNo,
    String? membershipAmount,
    String? dateTime,
    String? percentage,
  }) =>
      UserMembershipDetails(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        membershipCategory: membershipCategory ?? this.membershipCategory,
        giftcardMembershipNo: giftcardMembershipNo ?? this.giftcardMembershipNo,
        membershipAmount: membershipAmount ?? this.membershipAmount,
        dateTime: dateTime ?? this.dateTime,
        percentage: percentage ?? this.percentage,
      );

  factory UserMembershipDetails.fromJson(Map<String, dynamic> json) => UserMembershipDetails(
    id: json["id"] ?? "",
    userId: json["user_id"] ?? "",
    membershipCategory: json["membership_category"] ?? "",
    giftcardMembershipNo: json["giftcard_membership_no"] ?? "",
    membershipAmount: json["membership_amount"] ?? "",
    dateTime: json["date_time"] ?? "",
    percentage: json["percentage"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "membership_category": membershipCategory,
    "giftcard_membership_no": giftcardMembershipNo,
    "membership_amount": membershipAmount,
    "date_time": dateTime,
    "percentage": percentage,
  };
}
