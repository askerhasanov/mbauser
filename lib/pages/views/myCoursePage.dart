import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:mbauser/elements/colors.dart';
import 'package:mbauser/elements/pageheader.dart';
import 'package:mbauser/elements/uiHelpers.dart';
import 'package:mbauser/providers/mbaProvider.dart';
import 'package:provider/provider.dart';

import '../../services/reservationService.dart';

class MyCoursePage extends StatefulWidget {
  const MyCoursePage({super.key});

  @override
  State<MyCoursePage> createState() => _MyCoursePageState();
}

class _MyCoursePageState extends State<MyCoursePage> {

  bool isReserved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
       child: Column(
         children: [
           const pageHeader(text: 'Kursum'),

           Padding(
               padding: const EdgeInsets.all(10),
             child: Padding(
               padding: const EdgeInsets.only(top: 40.0),
               child: Stack(
                 clipBehavior: Clip.none,
                 children: [
                   Container(
                     decoration: const BoxDecoration(
                       color: MbaColors.darkRed,
                       borderRadius: BorderRadius.all(Radius.circular(10)),
                     ),
                     child: Padding(
                       padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
                       child: Container(
                         padding: const EdgeInsets.all(10),
                         decoration: const BoxDecoration(
                           color: MbaColors.lightRed,
                           borderRadius: BorderRadius.all(Radius.circular(10)),
                         ),
                         child: Column(
                           children: [
                             //
                             Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        //dersler
                                        Column(
                                          children: [
                                            const Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(width: 120,child: Text('Dərslər:', style: TextStyle(color: MbaColors.darkRed, fontSize: 18, fontWeight: FontWeight.bold),)),
                                                Text('12/14', style: TextStyle(color: MbaColors.darkRed, fontSize: 18, fontWeight: FontWeight.bold),),
                                              ],
                                            ),
                                            const SizedBox(height: 10,),
                                            Row(
                                              children: [
                                                Expanded(child: LinearProgressIndicator( borderRadius: BorderRadius.circular(10), minHeight: 10, value: 12/14, backgroundColor: Colors.white, color: MbaColors.darkRed,))
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        //next lesson
                                        const Row(
                                          children: [
                                            SizedBox(width: 120,child: Text('Növbəti dərs:', style: TextStyle(color: MbaColors.darkRed, fontSize: 18, fontWeight: FontWeight.bold),)),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Icon(FontAwesome.forward_solid, color: Colors.red,),
                                                  SizedBox(width: 10,),
                                                  Expanded(child: Text('13. Motosikllə dönüşlər, tur, yarış və adventur metodları', style: TextStyle(color: Colors.white, fontSize: 16,),)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        //filial
                                        const Row(
                                          children: [
                                            SizedBox(width: 120,child: Text('Filial:', style: TextStyle(color: MbaColors.darkRed, fontSize: 18, fontWeight: FontWeight.bold),)),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Icon(FontAwesome.map_pin_solid, color: Colors.red,),
                                                  SizedBox(width: 10,),
                                                  Expanded(child: Text('Elit filialı', style: TextStyle(color: Colors.white, fontSize: 16,),)),
                                                ],
                                              ),
                                            ),

                                            Expanded(child: Text('', style: TextStyle(color: Colors.white, fontSize: 16,),)),
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        //rezervasiya
                                        Row(
                                          children: [
                                            const SizedBox(width: 120,child: Text('Rezervasiya:', style: TextStyle(color: MbaColors.darkRed, fontSize: 18, fontWeight: FontWeight.bold),)),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  const Icon(FontAwesome.calendar_check, color: MbaColors.red,),
                                                  const SizedBox(width: 10,),
                                                  Consumer<MBAProvider>(
                                                    builder: (_, state, __){
                                                      return Expanded(
                                                          child: Row(
                                                            children: [
                                                              Expanded(child: Text(isReserved ? state.finalDate.toString() : 'Seçilməyib', style: const TextStyle(color: Colors.white, fontSize: 16,),)),
                                                              ElevatedButton(
                                                                  onPressed: isReserved ? () => _cancelReservation(state.finalDate.toString()) : () => _selectReservationDate(),
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(isReserved ? FontAwesome.x_solid : FontAwesome.calendar),
                                                                      const SizedBox(width: 10,),
                                                                      Text(isReserved ? 'Ləğv et' : 'Seç'),
                                                                    ],
                                                                  )
                                                              )
                                                            ],
                                                          )
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                             //
                             //
                             const SizedBox(height: 10,),

                             //Novbeti ders
                           ],
                         ),
                       ),
                     ),
                   ),
                   Positioned(
                       top: -30,
                       left: 30,
                       child: Container(
                         constraints: const BoxConstraints(
                           maxWidth: 200,
                         ),
                         decoration: const BoxDecoration(
                           color: MbaColors.light,
                           borderRadius: BorderRadius.all(Radius.circular(50)),
                         ),
                         child: const Padding(
                           padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                           child: SizedBox(
                             height: 40,
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Icon(Icons.sports_motorsports, color: MbaColors.red,),
                                 SizedBox(width: 10,),
                                 Text('PREMIUM PAKET', style: TextStyle(color: MbaColors.red, fontWeight: FontWeight.bold, fontSize: 18),),
                               ],
                             ),
                           ),
                         ),
                       )
                   ),
                   Positioned(
                       top: -20,
                       right: 20,
                       child: Container(
                         decoration: const BoxDecoration(
                           color: Colors.green,
                           shape: BoxShape.circle,
                         ),
                         child: const Padding(
                           padding: EdgeInsets.all(10.0),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Icon(FontAwesome.play_solid, color: Colors.white, size: 20,),
                              // Icon(FontAwesome.stop_solid), when stop icon background black, when spinner backgroud yellow[700],  else green
                             ],
                           ),
                         ),
                       )
                   )
                 ]

               ),
             ),
           ),

           ElevatedButton(
             onPressed: () async {
               if (await ReservationService().isSlotAvailable(DateTime(2024, 9, 2,), '15:00',)) {
                 await ReservationService().addReservation(
                     courseId: 'SP0002',
                     day: DateTime(2024, 9, 2,),
                     time: '15:00',
                     userFullName: 'Mirfariz Seyidli');
                 // Show success message or navigate
               } else {
                 // Show "slot full" message
                 UiHelpers.showSnackBar(context: context, title: 'Göstərilən tarix və saatda yerlər dolmuşdur.', color: MbaColors.red);
               }
             },
             child: const Text('Reserve'),
           ),
         ],
       ),
      )
    );
  }

  Future<void> _cancelReservation(String selectedDate) async {
    if (isLessThanOneHourToNow(selectedDate)) {
      UiHelpers.showSnackBar(
          context: context, title: 'Vaxt keçdiyi üçün və ya bir saatdan az vaxt qaldığı üçün ləğv edə bilməzsiniz!');
    } else {
      var response = await _showYesNoDialog();
      if (response == 'yes') {
        
        setState(() {
          isReserved = false;
          Provider.of<MBAProvider>(context, listen: false).finalDate = null;
        });
        // Here you can add the logic to actually cancel the reservation
      } else {
        
      }
    }
  }

  bool isLessThanOneHourToNow(String dateTimeString) {
    DateTime givenDateTime = DateTime.parse(dateTimeString);
    DateTime now = DateTime.now();
    Duration difference = givenDateTime.difference(now);
    return difference.isNegative || difference.inMinutes < 60;
  }

  _showYesNoDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Təsdiq'),
          content: const SingleChildScrollView(
            child: ListBody(
              children:<Widget>[
                Text('Dərsin başlamasına bir saatdan artıq vaxt qalmışdır. Yenə də ləğv etmək istəyirsinizmi?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Xeyr'),
              onPressed: () {
                Navigator.of(context).pop('no'); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Bəli'),
              onPressed: () {
                // Handle Yes action
                Navigator.of(context).pop('yes'); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  
  _selectReservationDate(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text('Rezervasiya vaxtını seçin'),
            content: SizedBox(
              height: 500,
              width: double.maxFinite,
              child: Column(
                children: [
                  //head part
                  Consumer<MBAProvider>(
                    builder: (_, state, __){
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: (){
                              _presentDatePicker();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(
                                    color: MbaColors.red,
                                    width: 2,
                                  )
                              ),
                              child: Center(
                                child: Text(
                                    state.selectedDate != null ? DateFormat('EEEE, d MMMM, yyyy').format(state.selectedDate!).toString() : 'Tarix'
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              _presentTimePicker();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(
                                    color: MbaColors.red,
                                    width: 2,
                                  )
                              ),
                              child: Center(
                                child: Text(
                                    state.selectedTime != null
                                        ? '${state.selectedTime!.hour.toString().padLeft(2, '0')} : ${state.selectedTime!.minute.toString().padLeft(2, '0')}'
                                        : 'Saat'
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  // future builder
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: MbaColors.red
                        ),
                        height: 50,
                        width: 50,
                        child: const Center(child: Text('Dolu')),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: const Text('Boş'),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: const Text('Boş'),
                      ),
                    ]
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  _presentDatePicker() {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      ).then((pickedDate) {
        if (pickedDate == null) {
          return;
        }
        // Handle selected date (pickedDate)
        Provider.of<MBAProvider>(context, listen: false).selectDate(pickedDate);
      });
    }

  _presentTimePicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Saatı seçin'),
          content: SizedBox(
            width: double.maxFinite, // Set the width here
            height: 300, // Set the height here
            child: _buildTimeList(),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('İmtina'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Təsdiq'),
              onPressed: () {
                if (Provider.of<MBAProvider>(context, listen: false).selectedTime != null && Provider.of<MBAProvider>(context, listen: false).selectedDate != null ) {
                  // Combine _selectedDate and _selectedTime
                  DateTime selectedDateTime = DateTime(
                    Provider.of<MBAProvider>(context, listen: false).selectedDate!.year,
                    Provider.of<MBAProvider>(context, listen: false).selectedDate!.month,
                    Provider.of<MBAProvider>(context, listen: false).selectedDate!.day,
                    Provider.of<MBAProvider>(context, listen: false).selectedTime!.hour,
                    Provider.of<MBAProvider>(context, listen: false).selectedTime!.minute,
                  );
                  /// TODO: add reservation dateTime to server
                  Navigator.of(context).pop();
                }else{
                  Navigator.of(context).pop();
                  UiHelpers.showSnackBar(context: context, title: 'Tarix və ya vaxtı seçməmisiniz!');
                }
              },
            ),
          ],
        );
      },
    ).then((selectedDateTime) {
      if (selectedDateTime != null) {// Do something with the selected date and time
        Provider.of<MBAProvider>(context, listen: false).updateFinalDate(selectedDateTime);
      }
    });
  }

  Widget _buildTimeList() {
    DateTime now = DateTime.now();
    int currentHour = now.hour;
    int startHour = currentHour + 1;
    if (startHour < 9) startHour = 9; // Ensure minimum start time is 9 AM
    int endHour = 21; // 9 PM

    List<Widget> timeSlots = [];
    for (int hour = startHour; hour <= endHour; hour++) {
      timeSlots.add(
        ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${hour.toString().padLeft(2, '0')}:00', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
          ),
          onTap: () {
            Provider.of<MBAProvider>(context, listen: false).selectTime(TimeOfDay(hour: hour, minute: 00));
          },
        ),
      );
    }
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of columns
        childAspectRatio: 2.0, // Adjust as needed
      ),
      shrinkWrap: true,
      children: timeSlots,
    );
  }
}
