import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
class FetchOrderList{
  String _baseUri = '192.168.11.114:8281/';
  List data;
  Future<dynamic> fetchYetReceivedOrders()async{
    //String _uri = createRepairOrdersListUri(1, 10);
    var _uri = "https://api.themoviedb.org/3/movie/now_playing?api_key=846cd2cdc1ddb950b6f8e90df6261b3a&language=en-US&page=1";
    var response = await http.get(
      Uri.encodeFull(_uri),
      headers: {"Accept":"application/json"}
    );
    var dataFromJson = json.decode(response.body);
    data = dataFromJson['results'];
    //data = dataFromJson['page']['list'];
    print(data);
    return data;
  }

  String createRepairOrdersListUri(int page, int limit){
    String _uri = _baseUri + "api/repairs/repairsOrders/list?page=$page&limit=$limit";
    print(_uri);
    return _uri;
  }

}