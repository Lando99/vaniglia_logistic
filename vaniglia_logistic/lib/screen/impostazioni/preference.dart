import 'package:flutter/material.dart';
import '../../constants.dart' as Constants;


class SettingsForm extends StatefulWidget {
  static const String routeName = "/SettingsForm";
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {


  List<bool> isSwitches = [false,false,false,false,false,false,false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.mediumBrown,
      appBar: AppBar(
          backgroundColor: Constants.lightBrown,
          elevation: 0.0,
          title: Center(
            child: Text('Impostazioni - ( BETA ) -', style: TextStyle(color: Colors.black),),
          ),
          leading:
          IconButton(
            icon: const Icon(Icons.vertical_align_bottom, color: Colors.black,),
            onPressed: () { Navigator.pop(context);
            },
          )
      ),
      body: Column(
        children: [

          Text('Giorni di consegna'),

          Row(
            children: [
              Switch(
                value: isSwitches[0],
                onChanged: (value){
                  setState(() {
                    isSwitches[0]=value;
                    print(isSwitches[0]);
                  });
                },
                activeTrackColor: Constants.darkBrown,
                activeColor: Constants.lightBrown,
              ),
              Text("Lunedí")
            ],
          ),
          Row(
            children: [
              Switch(
                value: isSwitches[1],
                onChanged: (value){
                  setState(() {
                    isSwitches[1]=value;
                    print(isSwitches[1]);
                  });
                },
                activeTrackColor: Constants.darkBrown,
                activeColor: Constants.lightBrown,
              ),
              Text("Martedí")
            ],
          ),
          Row(
            children: [
              Switch(
                value: isSwitches[2],
                onChanged: (value){
                  setState(() {
                    isSwitches[2]=value;
                    print(isSwitches[2]);
                  });
                },
                activeTrackColor: Constants.darkBrown,
                activeColor: Constants.lightBrown,
              ),
              Text("Mercoledí")
            ],
          ),
          Row(
            children: [
              Switch(
                value: isSwitches[3],
                onChanged: (value){
                  setState(() {
                    isSwitches[3]=value;
                    print(isSwitches[3]);
                  });
                },
                activeTrackColor: Constants.darkBrown,
                activeColor: Constants.lightBrown,
              ),
              Text("Giovedí")
            ],
          ),
          Row(
            children: [
              Switch(
                value: isSwitches[4],
                onChanged: (value){
                  setState(() {
                    isSwitches[4]=value;
                    print(isSwitches[4]);
                  });
                },
                activeTrackColor: Constants.darkBrown,
                activeColor: Constants.lightBrown,
              ),
              Text("Venerdí")
            ],
          ),
          Row(
            children: [
              Switch(
                value: isSwitches[5],
                onChanged: (value){
                  setState(() {
                    isSwitches[5]=value;

                  });
                },
                activeTrackColor: Constants.darkBrown,
                activeColor: Constants.lightBrown,
              ),
              Text("Sabato")
            ],
          ),
          Row(
            children: [
              Switch(
                value: isSwitches[6],
                onChanged: (value){
                  setState(() {
                    isSwitches[6]=value;
                  });
                },
                activeTrackColor: Constants.darkBrown,
                activeColor: Constants.lightBrown,
              ),
              Text("Domenica")
            ],
          )




        ],
      ),
    );
  }
}

