class MyReferredUser {
  String id;
  String ipAddress;
  String username;
  String password;
  dynamic salt;
  String email;
  dynamic activationCode;
  dynamic forgottenPasswordCode;
  dynamic forgottenPasswordTime;
  dynamic rememberCode;
  String createdOn;
  String lastLogin;
  String active;
  String firstName;
  String lastName;
  dynamic photo;
  String phone;
  String dateOfBirth;
  String secondaryEmail;
  String securityQuestion1;
  String securityQuestionOneAnswer;
  String securityQuestion2;
  String securityQuestionTwoAnswer;
  dynamic address;
  dynamic city;
  dynamic pincode;
  dynamic landmark;
  dynamic deviceId;
  dynamic platform;
  String registrationThrough;
  String registrationType;
  String referralCode;
  String userPoints;
  String referBy;
  String referByCode;
  String createdDatetime;
  dynamic updatedDatetime;
  String isActivated;
  dynamic assignedCities;
  String giftCardMembership;
  dynamic appId;

  MyReferredUser({
    this.id = "",
    this.ipAddress = "",
    this.username = "",
    this.password = "",
    this.salt = "",
    this.email = "",
    this.activationCode = "",
    this.forgottenPasswordCode = "",
    this.forgottenPasswordTime = "",
    this.rememberCode = "",
    this.createdOn = "",
    this.lastLogin = "",
    this.active = "",
    this.firstName = "",
    this.lastName = "",
    this.photo = "",
    this.phone = "",
    this.dateOfBirth = "",
    this.secondaryEmail = "",
    this.securityQuestion1 = "",
    this.securityQuestionOneAnswer = "",
    this.securityQuestion2 = "",
    this.securityQuestionTwoAnswer = "",
    this.address = "",
    this.city = "",
    this.pincode = "",
    this.landmark = "",
    this.deviceId = "",
    this.platform = "",
    this.registrationThrough = "",
    this.registrationType = "",
    this.referralCode = "",
    this.userPoints = "",
    this.referBy = "",
    this.referByCode = "",
    this.createdDatetime = "",
    this.updatedDatetime = "",
    this.isActivated = "",
    this.assignedCities = "",
    this.giftCardMembership = "",
    this.appId = "",
  });

  MyReferredUser copyWith({
    String? id,
    String? ipAddress,
    String? username,
    String? password,
    dynamic salt,
    String? email,
    dynamic activationCode,
    dynamic forgottenPasswordCode,
    dynamic forgottenPasswordTime,
    dynamic rememberCode,
    String? createdOn,
    String? lastLogin,
    String? active,
    String? firstName,
    String? lastName,
    dynamic photo,
    String? phone,
    String? dateOfBirth,
    String? secondaryEmail,
    String? securityQuestion1,
    String? securityQuestionOneAnswer,
    String? securityQuestion2,
    String? securityQuestionTwoAnswer,
    dynamic address,
    dynamic city,
    dynamic pincode,
    dynamic landmark,
    dynamic deviceId,
    dynamic platform,
    String? registrationThrough,
    String? registrationType,
    String? referralCode,
    String? userPoints,
    String? referBy,
    String? referByCode,
    String? createdDatetime,
    dynamic updatedDatetime,
    String? isActivated,
    dynamic assignedCities,
    String? giftCardMembership,
    dynamic appId,
  }) =>
      MyReferredUser(
        id: id ?? this.id,
        ipAddress: ipAddress ?? this.ipAddress,
        username: username ?? this.username,
        password: password ?? this.password,
        salt: salt ?? this.salt,
        email: email ?? this.email,
        activationCode: activationCode ?? this.activationCode,
        forgottenPasswordCode: forgottenPasswordCode ?? this.forgottenPasswordCode,
        forgottenPasswordTime: forgottenPasswordTime ?? this.forgottenPasswordTime,
        rememberCode: rememberCode ?? this.rememberCode,
        createdOn: createdOn ?? this.createdOn,
        lastLogin: lastLogin ?? this.lastLogin,
        active: active ?? this.active,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        photo: photo ?? this.photo,
        phone: phone ?? this.phone,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        secondaryEmail: secondaryEmail ?? this.secondaryEmail,
        securityQuestion1: securityQuestion1 ?? this.securityQuestion1,
        securityQuestionOneAnswer: securityQuestionOneAnswer ?? this.securityQuestionOneAnswer,
        securityQuestion2: securityQuestion2 ?? this.securityQuestion2,
        securityQuestionTwoAnswer: securityQuestionTwoAnswer ?? this.securityQuestionTwoAnswer,
        address: address ?? this.address,
        city: city ?? this.city,
        pincode: pincode ?? this.pincode,
        landmark: landmark ?? this.landmark,
        deviceId: deviceId ?? this.deviceId,
        platform: platform ?? this.platform,
        registrationThrough: registrationThrough ?? this.registrationThrough,
        registrationType: registrationType ?? this.registrationType,
        referralCode: referralCode ?? this.referralCode,
        userPoints: userPoints ?? this.userPoints,
        referBy: referBy ?? this.referBy,
        referByCode: referByCode ?? this.referByCode,
        createdDatetime: createdDatetime ?? this.createdDatetime,
        updatedDatetime: updatedDatetime ?? this.updatedDatetime,
        isActivated: isActivated ?? this.isActivated,
        assignedCities: assignedCities ?? this.assignedCities,
        giftCardMembership: giftCardMembership ?? this.giftCardMembership,
        appId: appId ?? this.appId,
      );

  factory MyReferredUser.fromJson(Map<String, dynamic> json) => MyReferredUser(
    id: json["id"] ?? "",
    ipAddress: json["ip_address"] ?? "",
    username: json["username"] ?? "",
    password: json["password"] ?? "",
    salt: json["salt"] ?? "",
    email: json["email"] ?? "",
    activationCode: json["activation_code"] ?? "",
    forgottenPasswordCode: json["forgotten_password_code"] ?? "",
    forgottenPasswordTime: json["forgotten_password_time"] ?? "",
    rememberCode: json["remember_code"] ?? "",
    createdOn: json["created_on"] ?? "",
    lastLogin: json["last_login"] ?? "",
    active: json["active"] ?? "",
    firstName: json["first_name"] ?? "",
    lastName: json["last_name"] ?? "",
    photo: json["photo"] ?? "",
    phone: json["phone"] ?? "",
    dateOfBirth: json["date_of_birth"] ?? "",
    secondaryEmail: json["secondary_email"] ?? "",
    securityQuestion1: json["security_question_1"] ?? "",
    securityQuestionOneAnswer: json["security_question_one_answer"] ?? "",
    securityQuestion2: json["security_question_2"] ?? "",
    securityQuestionTwoAnswer: json["security_question_two_answer"] ?? "",
    address: json["address"] ?? "",
    city: json["city"] ?? "",
    pincode: json["pincode"] ?? "",
    landmark: json["landmark"] ?? "",
    deviceId: json["device_id"] ?? "",
    platform: json["platform"] ?? "",
    registrationThrough: json["registration_through"] ?? "",
    registrationType: json["registration_type"] ?? "",
    referralCode: json["referral_code"] ?? "",
    userPoints: json["user_points"] ?? "",
    referBy: json["refer_by"] ?? "",
    referByCode: json["refer_by_code"] ?? "",
    createdDatetime: json["created_datetime"] ?? "",
    updatedDatetime: json["updated_datetime"] ?? "",
    isActivated: json["is_activated"] ?? "",
    assignedCities: json["assigned_cities"] ?? "",
    giftCardMembership: json["gift_card_membership"] ?? "",
    appId: json["app_id"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ip_address": ipAddress,
    "username": username,
    "password": password,
    "salt": salt,
    "email": email,
    "activation_code": activationCode,
    "forgotten_password_code": forgottenPasswordCode,
    "forgotten_password_time": forgottenPasswordTime,
    "remember_code": rememberCode,
    "created_on": createdOn,
    "last_login": lastLogin,
    "active": active,
    "first_name": firstName,
    "last_name": lastName,
    "photo": photo,
    "phone": phone,
    "date_of_birth": dateOfBirth,
    "secondary_email": secondaryEmail,
    "security_question_1": securityQuestion1,
    "security_question_one_answer": securityQuestionOneAnswer,
    "security_question_2": securityQuestion2,
    "security_question_two_answer": securityQuestionTwoAnswer,
    "address": address,
    "city": city,
    "pincode": pincode,
    "landmark": landmark,
    "device_id": deviceId,
    "platform": platform,
    "registration_through": registrationThrough,
    "registration_type": registrationType,
    "referral_code": referralCode,
    "user_points": userPoints,
    "refer_by": referBy,
    "refer_by_code": referByCode,
    "created_datetime": createdDatetime,
    "updated_datetime": updatedDatetime,
    "is_activated": isActivated,
    "assigned_cities": assignedCities,
    "gift_card_membership": giftCardMembership,
    "app_id": appId,
  };
}
