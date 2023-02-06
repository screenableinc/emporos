import 'package:emporos/config/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class Request{
  final Object body;
  final Uri path;


  const Request({
    required this.body,
    required this.path

});
  Future<http.Response> fetchData() async{
    // Map<String,String> params = body as Map<String, String>;
    // print(params.toString());
    // String queryString = Uri.parse(params.toString()).query;
    // print(queryString);
    final prefs = await SharedPreferences.getInstance();

    final token  = await prefs.getString('accesstoken').toString();


    return  http.get(path,headers: {'user-agent': 'mobile','token':token});
  }
  Future<http.Response> sendData() async{
    
    return http.post(path,body: body);
  }

}
