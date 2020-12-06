import 'dart:ffi';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:roadsideassistance/widgets/string_input.dart';
import 'package:roadsideassistance/widgets/disable_string_input.dart';
import 'package:roadsideassistance/widgets/description.dart';
import 'package:roadsideassistance/widgets/submit_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;

// List<CameraDescription> cameras;//for list of cameras
// cameras= await availableCameras();//accesss camera

class Emergency_form extends StatefulWidget {


  @override
  _Emergency_formState createState() => _Emergency_formState();
}
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class _Emergency_formState extends State<Emergency_form> {
  TextEditingController vech_reg_num, cust_name,detailed_type,description_;
  File imageFile;
  _openGallary(BuildContext context) async{
// ignore: deprecated_member_use
var picture =await ImagePicker.pickImage(source: ImageSource.gallery);
this.setState(() {
  imageFile=picture ;
});
Navigator.of(context).pop();
  }


   _openCamera(BuildContext context) async{
// ignore: deprecated_member_use
var picture =await ImagePicker.pickImage(source: ImageSource.camera);
this.setState(() {
  imageFile=picture;
});
Navigator.of(context).pop();
  }




  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make a Choice"),
            content: SingleChildScrollView(
            child: ListBody(children:<Widget>[
              GestureDetector(child: Text("Galary"),
              onTap: (){_openGallary(context);},)
              ,Padding(padding: EdgeInsets.all(8.0))
              ,GestureDetector(child: Text("Camera"),
              onTap: (){_openCamera(context);},)
            ]),  
            ),
          );
        });
  }


   var userlat = 0.0;
  var userlong = 0.0;
  var datalocation;
  void getCurrentLocation() async {
    var Position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    userlat = Position.latitude;
    userlong = Position.longitude;
    print('$userlat'+'$userlong');

//     final oldcoordinates = new Coordinates(userlat, userlong);
//     var oldaddresses =
//         await Geocoder.local.findAddressesFromCoordinates(oldcoordinates);
//     var first = oldaddresses.first;
//     var oldadminarea = first.adminArea;

//     final coordinates = new Coordinates(userlat, userlong);
//     var addresses =
//         await Geocoder.local.findAddressesFromCoordinates(coordinates);
//     var Location = addresses.first;
//     var userlocation = Location.locality;
//     await Future.delayed(Duration(seconds: 1));
//     Navigator.pushReplacementNamed(context, '/home', arguments: {
//       'latitude': userlat,
//       'longitude': userlong,
//       'datalocation': datalocation,
//       'userlocation': userlocation
//     });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    vech_reg_num = new TextEditingController();
    cust_name = new TextEditingController();
    detailed_type= new TextEditingController();
    description_= new TextEditingController();
  }

// Widget _decideImageView(){
//   if(imageFile == null){
//     return Text("No image selected !");
//   }else{
//     Image.file(imageFile,width: 400,height :400);
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: SingleChildScrollView(child:Padding(
        padding: const EdgeInsets.all(25.0),
        child: Card(
          elevation: 10.0,
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: Colors.grey[50],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: String_Input(
                  label_text: "Name",
                  controller_text: cust_name,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: String_Input(
                  label_text: "Vechicle Registration Number",
                  controller_text: vech_reg_num,
                ),
              ),
              RaisedButton( elevation: 10.0,
                onPressed: () {
                  _showChoiceDialog(context);
                },
                child: Text(
                  'Take/Choose Picture',
                  style: TextStyle(fontSize: 20.0),
                ),
                color: Colors.redAccent,
                textColor: Colors.white,
              ),Padding(
                padding: const EdgeInsets.all(10.0),
                child: disable_String_Input(
                  label_text: "Problem Type",
                    controller_text: detailed_type,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: description(
                  label_text: "Description",
                    controller_text: description_,
                ),),
                RaisedButton( elevation: 10.0,
                onPressed: () {
                  getCurrentLocation();
                },
                child: Text(
                  'Fetch Location',
                  style: TextStyle(fontSize: 20.0),
                ),
                color: Colors.redAccent,
                textColor: Colors.white,
              ),
              SizedBox(height: 20.0,),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Container(
                      height: 40.0,
                      child: GestureDetector(
                        onTap: (){
                          EmergencyForm(cust_name.text,vech_reg_num.text,detailed_type.text,description_.text,userlat,userlong);
                        },
                        child: Material(
                          borderRadius: BorderRadius.circular(5.0),
                          shadowColor: Colors.red,
                          color: Colors.redAccent,
                          elevation: 13.0,
                          child:Center(
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),SizedBox(height:20.0)
// ),_decideImageView(),
            ],
          ),
        ),
      ),
    ));
  }
}
void EmergencyForm(String cust_name,String vech_reg_num,String detailed_type,String description_,userlat,userlong){
    var url = "http://192.168.0.101/roadside_assistance/emergencyform.php";
    var data = {"Name":cust_name, "Vechicle_Registration_Number":vech_reg_num, "Problem_type":detailed_type, "Description":description_, "User_Latitude":userlat,"User_Longitute":userlong};
    var res = http.post(url,body: data);
  }
