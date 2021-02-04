import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_flutter_app/helpers/constants.dart';
import 'package:weather_flutter_app/helpers/functions.dart';
import 'package:weather_flutter_app/models/weather_model.dart';

class MainPage extends StatefulWidget {
  static String routeName = '/';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future<WeatherModel> weatherData;
  bool weatherAlerts;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weatherData = getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.2),
          elevation: 2,
          title: Text(
            "Weather Forecast",
            style: kWeatherSmall,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: FutureBuilder<WeatherModel>(
            future: weatherData,
            builder: (BuildContext context, AsyncSnapshot weather) {
              if (weather.hasData) {
                return mainWeatherListView(weather);
              } else if (weather.hasError) {
                print(weather.error);
              }
              return loadingIndicator();
            },
          ),
        ));
  }

  Widget mainWeatherListView(AsyncSnapshot weather) {
    return ListView(
      children: [
        Container(
          height: 300,
          margin: EdgeInsets.only(bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getWeatherIcon(weather.data.current.weather[0].icon),
                  Column(
                    children: [
                      Text(
                        "Today",
                        style: kWeatherSmall,
                      ),
                      Text(DateFormat.yMMMd().format(DateTime.now())),
                    ],
                  ),
                ],
              ),
              Text(
                '${weather.data.current.temp.toInt()}˚',
                style: kWeatherBig,
              ),
              Text('Feels like ${weather.data.current.feelsLike.toInt()}˚'),
              RawMaterialButton(
                constraints: BoxConstraints(
                  maxWidth: 200,
                ),
                onPressed: weather.data.alerts == null
                    ? null
                    : () {
                        showAlerts(context, weather.data.alerts);
                      },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Weather Alerts'),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.new_releases,
                      color: weather.data.alerts == null
                          ? Colors.grey
                          : Colors.red,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Next 48 Hours',
                style: kWeatherXSmall,
              )
            ],
          ),
        ),
        Divider(
          color: Colors.white,
          height: 20,
          thickness: 2,
        ),
        Container(
          height: 150,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: weather.data.hourly.length,
            itemBuilder: (_, i) => Container(
              width: 80,
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: kDailyWeatherStyle,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(convertTimestampToTime(weather.data.hourly[i].dt),
                      style: kWeatherXXSmall),
                  getWeatherIcon(weather.data.hourly[i].weather[0].icon),
                  Text('${weather.data.hourly[i].temp.toInt()}˚',
                      style: kWeatherXSmall)
                ],
              ),
            ),
          ),
        ),
        Divider(
          color: Colors.white,
          height: 20,
          thickness: 2,
        ),
        Container(
          height: 380,
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: weather.data.daily.length,
            itemBuilder: (_, i) {
              return Container(
                alignment: Alignment(0.0, 6.0),
                height: 40,
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(children: [
                      Text(
                        convertTimestampToDay(weather.data.daily[i].dt),
                        style: kWeatherXXSmall,
                      ),
                      SizedBox(
                          width: 30,
                          height: 30,
                          child: getWeatherIcon(
                              weather.data.daily[i].weather[0].icon)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '${weather.data.daily[i].temp.min.toInt().toString()}˚',
                          ),
                          Text(
                            '${weather.data.daily[i].temp.max.toInt().toString()}˚',
                            style: kWeatherXXSmall,
                          ),
                        ],
                      ),
                    ])
                  ],
                ),
              );
            },
          ),
        ),
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Color.fromRGBO(255, 255, 255, 0.2),
            ),
            height: 400,
            padding: EdgeInsets.all(30),
            child: Table(
              children: [
                TableRow(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        children: [
                          Text("Sunrise"),
                          Text(
                            convertTimestampToTime(
                                weather.data.current.sunrise),
                            style: kWeatherXSmall,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        children: [
                          Text("Sunset"),
                          Text(
                            convertTimestampToTime(
                                weather.data.current.sunrise),
                            style: kWeatherXSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        children: [
                          Text("Humidity"),
                          Text(
                            '${weather.data.current.humidity}%',
                            style: kWeatherXSmall,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        children: [
                          Text("Dew Point"),
                          Text(
                            weather.data.current.dewPoint.toString(),
                            style: kWeatherXSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        children: [
                          Text("Wind"),
                          Text(
                            '${weather.data.current.windSpeed.toInt()} Mph',
                            style: kWeatherXSmall,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        children: [
                          Text("Pressure"),
                          Text(
                            '${weather.data.current.pressure} hPa',
                            style: kWeatherXSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ))
      ],
    );
  }

  Widget loadingIndicator() {
    return Center(
      child: SizedBox(
        child: CircularProgressIndicator(),
        width: 60,
        height: 60,
      ),
    );
  }
}
