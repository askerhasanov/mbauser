import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mbauser/elements/colors.dart';
import 'package:mbauser/elements/uiHelpers.dart';
import 'package:mbauser/pages/views/myCoursePage.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/mbaProvider.dart';


class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  bool isBeingNotified = false;


  String imgSrc(String gender){
    return gender == 'man' ? 'images/male.png' : 'images/female.png';
  }

  @override
  Widget build(BuildContext context) {

    UserModel? user = Provider.of<MBAProvider>(context, listen: false).currentUser;

    print('images/${user!.gender! == 'man' ? 'male' : 'female'}.png');

    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height*0.9,
        color: MbaColors.lightBg,
        child: Center(
          child: Column(
            children: [
              ///header
              Container(
                decoration: const BoxDecoration(
                  color: MbaColors.red,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: MbaColors.dark,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(0, 1)
                    )
                  ]
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: Image.asset(imgSrc(user.gender!), height: 60,),
                          ),
                          const SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Xoş gördük!", style: TextStyle(fontWeight: FontWeight.bold, color: MbaColors.white, fontSize: 16),),
                              Text(user.fullName!, style: TextStyle(fontWeight: FontWeight.normal, color: MbaColors.white, fontSize: 14),),
                              Text('/${user.userName}', style: TextStyle(color: MbaColors.darkRed, fontWeight: FontWeight.bold),),
                            ],
                          )
                        ]
                      ),
                      Row(
                        children: [
                          const Text('Baku 9C', style: TextStyle(color: MbaColors.reddishGray, fontSize: 16, fontWeight: FontWeight.bold),),
                          const SizedBox(width: 10,),
                          IconButton(
                              onPressed: (){
                                setState(() {
                                  isBeingNotified = !isBeingNotified;
                                  UiHelpers.showSnackBar(context: context, title: isBeingNotified ? "Bildirimlər açıldı" : "Bildirimlər bağlandı");
                                });
                              },
                              icon: Icon(
                                isBeingNotified  ? Clarity.bell_solid_badged : Clarity.bell_solid,
                                color: isBeingNotified  ? MbaColors.red : Colors.white,
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: Image.asset(
                      'images/landing.png',
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
                    MbaCircularButton(callback: (){}, icon: Icons.people, name: 'Heyət',),
                    MbaCircularButton(callback: (){}, icon: Icons.newspaper, name: 'Xəbərlər',),
                    MbaCircularButton(callback: (){}, icon: Icons.event, name: 'Eventlər',),
                    MbaCircularButton(callback: (){}, icon: Icons.app_registration, name: 'Müraciət',),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  ///aktiv kurs yoxsa
                  //elave edilmeyib!
                  /// eger aktiv kurs varsa
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MyCoursePage()));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: MbaColors.red,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipOval(
                            child: Image.asset('images/1.png', height: 40,),
                          ),
                          const Text('Kursunuza baxın', style: TextStyle(color: MbaColors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                          const Icon(FontAwesome.chevron_right_solid, color: MbaColors.white,),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Populyar kurslar', style: TextStyle(color: MbaColors.black, fontWeight: FontWeight.bold, fontSize: 16),),
                    TextButton(onPressed: (){}, child: const Text('hamısına bax', style: TextStyle(color: MbaColors.red, fontSize: 16, fontWeight: FontWeight.bold),)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  height: 270,
                  child: ListView.builder(
                    itemCount: 3,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 1,
                                spreadRadius: 0,
                                offset: Offset.zero
                              )
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          width: 250,
                          height: 200,// Fixed width
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 150,
                                width: 250,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(10),
                                  ),
                                  child: Image.asset(
                                    'images/2.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                height: 100,
                                decoration: const BoxDecoration(
                                  color: MbaColors.lightRed3,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      Text(
                                        'Sade paket',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: MbaColors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.sports_motorsports,
                                            color: MbaColors.black,
                                            size: 14,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '8 ders',
                                            style: TextStyle(
                                              color: MbaColors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            FontAwesome.star_solid,
                                            size: 16,
                                            color: Colors.yellow,
                                            applyTextScaling: true,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '4.5',
                                            style: TextStyle(
                                              color: MbaColors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
        ],
          ),
        ),
      ),
    );
  }
}

class MbaCircularButton extends StatelessWidget{

  final VoidCallback callback;
  final IconData icon;
  final String name;

   const MbaCircularButton({
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
                padding: const EdgeInsets.all(10),
                shape: const CircleBorder(),
                backgroundColor: MbaColors.lightRed3,
              ),
              onPressed: callback,
              child: Icon(icon, color: MbaColors.red, size: 20,)
          ),
          Text(name, style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}
