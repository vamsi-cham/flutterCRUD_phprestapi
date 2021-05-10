import 'package:http/http.dart' as http;
import 'package:phprestapi/apiurl/apiurl.dart';
import 'package:phprestapi/model/usermodal.dart';

class UserServices {
  static const _GET_ALL_ACTION = 'getdata';
  static const _ADD_EMP_ACTION = 'adduser';
  static const _UPDATE_EMP_ACTION = 'updateuser';
  static const _DELETE_EMP_ACTION = 'deleteuser';
  static const api_key = "srkit28@gmail.com";
  static const api_secret = "srkit28@gmail.com";

  static Future<List<User>> getUsers(sort) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      map['api_key'] = api_key;
      map['api_secret'] = api_secret;
      map['sort'] = sort.toString();
      final response = await http.post(Uri.parse(ApiUrl.userapi), body: map);

      // print('getUsers Response: ${response.body}');
      if (200 == response.statusCode) {
        List<User> list = userFromJson(response.body);
        return list;
      } else {
        // ignore: deprecated_member_use
        return List<User>();
      }
    } catch (e) {
      // ignore: deprecated_member_use
      return List<User>(); // return an empty list on exception/error
    }
  }

  // Method to add employee to the database...
  static Future<String> addUser(
      var name, var age, var mobile, var email) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_EMP_ACTION;
      map['api_key'] = api_key;
      map['api_secret'] = api_secret;
      map['name'] = name;
      map['age'] = age;
      map['email'] = email;
      map['mobile'] = mobile;

      final response = await http.post(Uri.parse(ApiUrl.userapi), body: map);
      print('addUser Response: ${response.body}');
      if (200 == response.statusCode) {
        return 'success';
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to update an Employee in Database...
  static Future<String> updateUser(id, name, age, mobile, email) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_EMP_ACTION;
      map['api_key'] = api_key;
      map['api_secret'] = api_secret;
      map['user_id'] = id;
      map['name'] = name;
      map['age'] = age;
      map['email'] = email;
      map['mobile'] = mobile;

      final response = await http.post(Uri.parse(ApiUrl.userapi), body: map);
      // print('updateUser Response: ${response.body}');
      if (200 == response.statusCode) {
        return 'success';
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to Delete an Employee from Database...
  static Future<String> deleteUser(userId) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_EMP_ACTION;
      map['api_key'] = api_key;
      map['api_secret'] = api_secret;
      map['user_id'] = userId;
      final response = await http.post(Uri.parse(ApiUrl.userapi), body: map);
      // print('deleteUser Response: ${response.body}');
      if (200 == response.statusCode) {
        return 'success';
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; // returning just an "error" string to keep this simple...
    }
  }
}
