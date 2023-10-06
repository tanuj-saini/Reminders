import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:reminder/Home/HomeScreen.dart';
import 'package:reminder/User/authContoller.dart';
import 'package:reminder/utils/Loder.dart';
import 'package:reminder/utils/Pallate.dart';

class MapScreen extends ConsumerStatefulWidget {
  MapScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _Map();
  }
}

class _Map extends ConsumerState<MapScreen> {
  double Lati = 900;
  double Longi = 000;
  dynamic address = "";
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ref.watch(authContoller.notifier).getNoti(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoderScreen();
        }
        double Llatii = double.parse(snapshot.data!.Latitude);
        double Llongi = double.parse(snapshot.data!.Longitude);
        return Scaffold(
            appBar: AppBar(
              title: Text("Pick Up Location"),
              centerTitle: true,
            ),
            body: Stack(children: [
              OpenStreetMapSearchAndPick(
                buttonTextColor: Colors.black,
                center: LatLong(Llatii, Llongi),
                buttonColor: Colors.blue,
                buttonText: 'Set Current Location',
                onPicked: (pickedData) {
                  print(pickedData.latLong.latitude);
                  print(pickedData.latLong.longitude);
                  print(pickedData.address);
                  Lati = pickedData.latLong.latitude;
                  Longi = pickedData.latLong.longitude;
                  address = pickedData.address;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => HomeScreen(
                            currLati: Lati.toString(),
                            currLogi: Longi.toString(),
                            cuuAddress: address,
                          )));
                },
              ),
            ]));
      },
    );
  }
}

// Navigator.of(context).push(MaterialPageRoute(
//                       builder: (ctx) => HomeScreen(
//                             currLati: Lati.toString(),
//                             currLogi: Longi.toString(),
//                             cuuAddress: address,
                          
//                           )));