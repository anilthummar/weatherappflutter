import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

import '../data/my_data.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherBlocEvent, WeatherState> {
  WeatherBloc() : super(WeatherBlocInitial()) {
    on<FetchWeather>((event, emit) async {
      emit(WeatherBlocLoading());
      try{
        WeatherFactory wf=WeatherFactory(API_KEY,language: Language.ENGLISH);
        // Weather weather =await wf.currentWeatherByCityName("Ahmedabad");

        print("weatherLocationPoints: latitude: ${event.position.latitude},longitude: ${event.position.longitude}");
        Weather weather =await wf.currentWeatherByLocation(event.position.longitude, event.position.longitude);
        // Weather weather =await wf.currentWeatherByLocation(23.044042587280273,72.50679016113281);
        // Weather weather =await wf.currentWeatherByLocation(52.516358,13.419309);

        print("weatherData  temperature: ${weather.temperature?.celsius} ,tempMin:${weather.tempMin}, tempMax:${weather.tempMax}");
        print("weatherData: ${weather.toJson()}");
        emit(WeatherBlocSuccess(weather));
      }catch(e){
        emit(WeatherBlocFailure());
      }
      
    });
  }
}
