import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tomacare/domain/entities/plant.dart';
import 'package:tomacare/domain/entities/task.dart';
// import 'package:tomacare/domain/entities/plant.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';
import 'package:tomacare/service/cloudinary.dart';
import 'package:tomacare/service/save_auth.dart';
import 'package:tomacare/utils/exceptions/exceptions.dart';

class PlantService {
  final Cloudinary cloudinary = Cloudinary();
  Future<List<Plant>> getPlants() async {
    final url = Uri.parse('$baseurl/plants/');
    final token = await SaveAuth().getToken();

    headers.addAll({'authorization': 'Bearer $token'});
    final response = await http.get(url, headers: headers);

    List jsonList = jsonDecode(response.body);

    List<Plant> plants = jsonList.map((json) => Plant.fromJson(json)).toList();

    if (response.statusCode == 200) {
      return plants;
    } else if (response.statusCode == 401) {
      throw UnathorizedException(message: response.body);
    } else {
      throw Exception();
    }
  }

  Future<Plant> getPlant({required int id}) async {
    final url = Uri.parse('$baseurl/plants/$id');
    final token = await SaveAuth().getToken();
    headers.addAll({'authorization': 'Bearer $token'});
    final response = await http.get(url, headers: headers);
    final Map<String, dynamic> plant = jsonDecode(response.body)['plant'];

    final List taskJson = jsonDecode(response.body)['task'];
    final List<Task> task =
        taskJson.map((json) => Task.fromJson(json)).toList();

    plant.addAll({'image': jsonDecode(response.body)['image']});
    plant.addAll({'tasks': task});

    if (response.statusCode == HttpStatus.ok) {
      return Plant.fromJson(plant);
    } else {
      throw Exception();
    }
  }

  Future<Plant> createPlant({required Plant plant}) async {
    final url = Uri.parse('$baseurl/plants/');
    final token = await SaveAuth().getToken();

    headers.addAll({'authorization': 'Bearer $token'});
    print('start post');
    final response = await http.post(url,
        headers: headers, body: jsonEncode(plant.toJson()));

    if (response.statusCode == HttpStatus.created) {
      return Plant.fromJson(jsonDecode(response.body));
    } else {
      print('error');
      throw Exception();
    }
  }
}
