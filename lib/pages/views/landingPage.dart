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
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height + 100,
        color: Colors.white,
        child: Container(
          child: Center(
            child: Column(
              children: [
      
                ///header
                Container(
                  color: MbaColors.red,
                  child: Padding(
                    padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              ClipOval(
                                child: Image.asset('images/1.jpeg', height: 60,),
                              ),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Name Surname', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),),
                                  Text('/askerhasanov', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
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
                                  color: isBeingNotified  ? Colors.white : Colors.grey,
                                )
                            ),
                          ]
                        ),
                      ],
                    ),
                  ),
                ),
                ///mainimage
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: Image.asset(
                        'images/2.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
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
                SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: MbaColors.red,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipOval(
                            child: Image.asset('images/1.jpeg', height: 40,),
                          ),
                          Text('Kursunuza baxın', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                          Icon(FontAwesome.chevron_right_solid, color: Colors.white,),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Populyar kurslar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                      TextButton(onPressed: (){}, child: Text('hamısına bax')),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Expanded(
                  child: ListView.builder(
                    itemCount: 3,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      ///extract courseThumbnail widget
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: 250,
                          child: Column(
                            children: [
                              SizedBox(
                                  height: 190,
                                  width: 250,
                                  child: Image.asset('images/1.jpeg', fit: BoxFit.cover,)),
                              Container(
                                height: 110,
                                decoration: BoxDecoration(
                                  color: MbaColors.red,
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Sade paket', textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                                      Row(
                                        children: [
                                          Icon(Icons.sports_motorsports, color: Colors.white,),
                                          SizedBox(width: 5,),
                                          Text('8 ders' , style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Icon(FontAwesome.star_solid, size: 20, color: Colors.yellow,),
                                          SizedBox(width: 5,),
                                          Text('4.5', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
      
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
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
                backgroundColor: MbaColors.red,
              ),
              onPressed: callback,
              child: Icon(icon, color: Colors.white, size: 25,)
          ),
          Text(name, style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}
