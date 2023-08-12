class userModel {
  String? address;
  String? email;
  String? phone;
  String? profielpic;
  String? uid;
  String? username;

  userModel();

  userModel.fromJson(Map<String, dynamic> json) {
    address = json['Address'];
    email = json['email'];
    phone = json['phone'];
    profielpic = json['profilepic'];
    uid = json['userid'];
    username = json['username'];
  }

  fromJson(Map<String, dynamic> map) {}
}
