import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:hava_durumu/search_page.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String sehir = 'Ankara';
  int sicaklik;
  var locationData;
  var woeid;
  String abbr = 'c';

  void getDevicePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.lowest);
    print(position);
  }

  Future<void> getLocationTemperature() async {
    var response =
        await http.get('https://www.metaweather.com/api/location/$woeid/');
    var temperatureDataParsed = jsonDecode(response.body);
    sicaklik = temperatureDataParsed['consolidated_weather'][0]['the_temp'];

    setState(() {
      sicaklik =
          temperatureDataParsed['consolidated_weather'][0]['the_temp'].round();
      abbr = temperatureDataParsed['consolidated_weather'][0]
          ['weather_state_abbr'];
      print('setstate çağırıldı');
    });
  }

  Future<void> getLocationData() async {
    locationData = await http
        .get('https://www.metaweather.com/api/location/search/?query=$sehir');
    var locationDataParsed = jsonDecode(locationData.body);
    woeid = locationDataParsed[0]['woeid'];
  }

  void getDataFromAPI() async {
    await getLocationData();

    getLocationTemperature();
  }

  @override
  void initState() {
    getDataFromAPI();
    getDevicePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('lib/assets/$abbr.jpg'))),
      child: /* sicaklik == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          :*/
          Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // FlatButton(
              //   onPressed: () async {
              //     await getLocationData();
              //   },
              //   child: Text('getLocationData'),
              //   color: Colors.grey,
              // ),
              Text(
                '$sicaklik ° C',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$sehir',
                    style: TextStyle(fontSize: 30),
                  ),
                  IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        sehir = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchPage()));
                        getDataFromAPI();
                        setState(() {
                          sehir = sehir;
                        });
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
