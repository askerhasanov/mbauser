import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mbauser/elements/colors.dart';
import 'package:mbauser/elements/mbadivider.dart';
import 'package:mbauser/elements/uiHelpers.dart';


class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  bool isBeingNotified = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Center(
        child: Column(
          children: [

            ///header
            Container(
              color: MbaColors.light,
              child: Padding(
                padding: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          ClipOval(
                            child: Image.asset('images/1.jpeg', height: 50,),
                          ),
                          SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name Surname', style: TextStyle(fontWeight: FontWeight.bold, color: MbaColors.red),),
                              Text('/askerhasanov', style: TextStyle(color: MbaColors.darkRed),),
                            ],
                          )
                        ]
                      ),
                    ),
                    Row(
                      children: [
                        Text('Baku 9C', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
                        SizedBox(width: 10,),
                        IconButton(
                            onPressed: (){
                              setState(() {
                                isBeingNotified = !isBeingNotified;
                                UiHelpers.showSnackBar(context, isBeingNotified ? "Bildirimlər açıldı" : "Bildirimlər bağlandı");
                              });
                            },
                            icon: Icon(
                              isBeingNotified  ? Clarity.bell_solid_badged : Clarity.bell_solid,
                              color: isBeingNotified  ? MbaColors.red : Colors.grey,
                            )
                        ),
                      ]
                    ),
                  ],
                ),
              ),
            ),
            ///mainimage
            Container(
              color: MbaColors.red,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Image.asset('images/2.jpeg', height: 200,),
              ),
            ),
            ///buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MbaCircularButton(callback: (){}, icon: Icons.sports_motorsports, name: 'Kurslar',),
                  MbaCircularButton(callback: (){}, icon: Icons.people, name: 'Müəllimlər',),
                  MbaCircularButton(callback: (){}, icon: Icons.newspaper, name: 'Xəbərlər',),
                  MbaCircularButton(callback: (){}, icon: Icons.event, name: 'Eventlər',),
                  MbaCircularButton(callback: (){}, icon: Icons.app_registration, name: 'Müraciət',),
                ],
              ),
            ),
            MbaDivider(text: '*', lineColor: MbaColors.darkRed),
          ],
          //head
          /*
              UserImaGE - USER FULLNAME - USER username

              weather

              notifications

              */

          //body

          /*
                openingImage

                buttons

                progress button

                popular courses slider with see all button

              */

          //bottom


        ),
      ),
    );
  }
}

class MbaCircularButton extends StatelessWidget{

  VoidCallback callback;
  IconData icon;
  String name;

   MbaCircularButton({
    super.key,
    required this.callback,
    required this.icon,
     required this.name
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: CircleBorder(),
                backgroundColor: MbaColors.darkRed,
              ),
              onPressed: callback,
              child: Icon(icon, color: Colors.white, size: 25,)
          ),
          Text(name, style: TextStyle(fontSize: 12, color: MbaColors.darkRed, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}
