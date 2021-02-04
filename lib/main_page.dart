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
                      color: Colors.red,
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

  // Widget weatherInterface(AsyncSnapshot weather) {
  //   return Flex(
  //     direction: Axis.vertical,
  //     children: [
  //       Expanded(
  //         flex: 4,
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Image.network(
  //                   'http://openweathermap.org/img/wn/${weather.data.current.weather[0].icon}@2x.png',
  //                 ),
  //                 Column(
  //                   children: [
  //                     Text(
  //                       "Today",
  //                       style: kWeatherSmall,
  //                     ),
  //                     Text(DateFormat.yMMMd().format(DateTime.now())),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //             Text(
  //               '${weather.data.current.temp.toInt()}˚',
  //               style: kWeatherBig,
  //             ),
  //             Text(weather.data.timezone.toString().split('/')[1]),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text('Feels like ${weather.data.current.feelsLike.toInt()}˚'),
  //                 Container(
  //                   margin: EdgeInsets.symmetric(horizontal: 10),
  //                   child: Text(
  //                     '•',
  //                     style: kWeatherSmall,
  //                   ),
  //                 ),
  //                 Text(
  //                     'Sunset ${convertTimestampToTime(weather.data.current.sunset)}'),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             Text(
  //               'Next 48 Hours',
  //               style: kWeatherXSmall,
  //             )
  //           ],
  //         ),
  //       ),
  //       Expanded(
  //         flex: 2,
  //         child: ListView.builder(
  //           shrinkWrap: true,
  //           scrollDirection: Axis.horizontal,
  //           itemCount: weather.data.hourly.length,
  //           itemBuilder: (BuildContext context, int index) => SizedBox(
  //             child: Container(
  //               width: 70,
  //               margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
  //               padding: EdgeInsets.symmetric(vertical: 15),
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.vertical(
  //                   top: Radius.circular(50),
  //                   bottom: Radius.circular(50),
  //                 ),
  //                 color: Colors.white,
  //               ),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   Text(
  //                     convertTimestampToTime(weather.data.hourly[index].dt),
  //                     style: TextStyle(
  //                       color: Colors.black,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   Image.network(
  //                     'http://openweathermap.org/img/wn/${weather.data.hourly[index].weather[0].icon}.png',
  //                   ),
  //                   Text(
  //                     '${weather.data.hourly[index].temp.toInt()}˚',
  //                     style: TextStyle(
  //                       color: Colors.black,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             Text(
  //               'Chance of Rain',
  //             ),
  //           ],
  //         ),
  //       ),
  //       Expanded(
  //         flex: 1,
  //         child: AspectRatio(
  //           aspectRatio: 3,
  //           child: Card(
  //             elevation: 0,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(4)),
  //             color: const Color(0),
  //             child: BarChart(
  //               BarChartData(
  //                 alignment: BarChartAlignment.spaceAround,
  //                 maxY: 20,
  //                 barTouchData: BarTouchData(
  //                   enabled: true,
  //                   touchTooltipData: BarTouchTooltipData(
  //                     tooltipBgColor: Colors.transparent,
  //                     tooltipPadding: const EdgeInsets.all(0),
  //                     tooltipBottomMargin: 8,
  //                     getTooltipItem: (
  //                       BarChartGroupData group,
  //                       int groupIndex,
  //                       BarChartRodData rod,
  //                       int rodIndex,
  //                     ) {
  //                       return BarTooltipItem(
  //                         rod.y.round().toString(),
  //                         TextStyle(
  //                           color: Colors.white,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //                 titlesData: FlTitlesData(
  //                   show: true,
  //                   bottomTitles: SideTitles(
  //                     showTitles: true,
  //                     getTextStyles: (value) => const TextStyle(
  //                         color: Color(0xff7589a2),
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 14),
  //                     margin: 20,
  //                     getTitles: (double value) {
  //                       switch (value.toInt()) {
  //                         case 0:
  //                           return 'Mn';
  //                         case 1:
  //                           return 'Te';
  //                         case 2:
  //                           return 'Wd';
  //                         case 3:
  //                           return 'Tu';
  //                         case 4:
  //                           return 'Fr';
  //                         case 5:
  //                           return 'St';
  //                         case 6:
  //                           return 'Sn';
  //                         default:
  //                           return '';
  //                       }
  //                     },
  //                   ),
  //                   leftTitles: SideTitles(showTitles: false),
  //                 ),
  //                 borderData: FlBorderData(
  //                   show: false,
  //                 ),
  //                 barGroups: [
  //                   BarChartGroupData(
  //                     x: 0,
  //                     barRods: [
  //                       BarChartRodData(y: 8, colors: [
  //                         Colors.yellow,
  //                       ])
  //                     ],
  //                     showingTooltipIndicators: [0],
  //                   ),
  //                   BarChartGroupData(
  //                     x: 1,
  //                     barRods: [
  //                       BarChartRodData(y: 10, colors: [
  //                         Colors.yellow,
  //                       ])
  //                     ],
  //                     showingTooltipIndicators: [0],
  //                   ),
  //                   BarChartGroupData(
  //                     x: 2,
  //                     barRods: [
  //                       BarChartRodData(y: 14, colors: [
  //                         Colors.yellow,
  //                       ])
  //                     ],
  //                     showingTooltipIndicators: [0],
  //                   ),
  //                   BarChartGroupData(
  //                     x: 3,
  //                     barRods: [
  //                       BarChartRodData(y: 15, colors: [
  //                         Colors.yellow,
  //                       ])
  //                     ],
  //                     showingTooltipIndicators: [0],
  //                   ),
  //                   BarChartGroupData(
  //                     x: 4,
  //                     barRods: [
  //                       BarChartRodData(y: 13, colors: [
  //                         Colors.yellow,
  //                       ])
  //                     ],
  //                     showingTooltipIndicators: [0],
  //                   ),
  //                   BarChartGroupData(
  //                     x: 5,
  //                     barRods: [
  //                       BarChartRodData(y: 10, colors: [
  //                         Colors.yellow,
  //                       ])
  //                     ],
  //                     showingTooltipIndicators: [0],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
