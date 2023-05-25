
import 'package:weather_app_clean_bloc/core/resources/data_state.dart';
import 'package:weather_app_clean_bloc/features/feature_bookmark/data/data_sourse/local/city_dao.dart';
import 'package:weather_app_clean_bloc/features/feature_bookmark/domain/entities/city_entity.dart';
import 'package:weather_app_clean_bloc/features/feature_bookmark/domain/repository/city_repository.dart';

class CityRepositoryImpl extends CityRepository{
  CityDao cityDao;

  CityRepositoryImpl(this.cityDao);

  @override
  Future<DataState<String>> deleteCityByName(String name) async {
   try{
     await cityDao.deleteCityByName(name);
     return DataSuccess(name);
   }catch(e){
     print(e.toString());
     return DataFailed(e.toString());
   }
  }

  @override
  Future<DataState<City?>> findCityByName(String name) async {
    try{
      City? city = await cityDao.findCityByName(name);
      return DataSuccess(city);
    }catch(e){
      print(e.toString());
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<List<City>>> getAllCityFromDB() async {
    try{
      List<City> cities = await cityDao.getAllCity();
      return DataSuccess(cities);
    }catch(e){
      print(e.toString());
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<City>> saveCityToDB(String cityName) async {
   try{
     // check city exist or not
     City? checkCity = await cityDao.findCityByName(cityName);
     if(checkCity != null){
       return DataFailed('$cityName has Already exist');
     }
     // inser city to database
     City city =City(name: cityName);
     await cityDao.insertCity(city);
     return DataSuccess(city);
   }catch(e){
     print(e.toString());
     return DataFailed(e.toString());
   }
  }


}


