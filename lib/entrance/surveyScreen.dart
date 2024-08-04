import 'package:flutter/material.dart';
import 'package:flutter/services.dart';




class SurveyScreen extends StatefulWidget {

  final String imageSrc;
  final String header;
  final String text;

  const SurveyScreen({
    Key? key,
    required this.imageSrc,
    required this.header,
    required this.text
  }) : super(key: key);

  @override
  State<SurveyScreen> createState() => _SurveyScreen1State();
}

class _SurveyScreen1State extends State<SurveyScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.red,
        child: Column(
          children: [
            Expanded(child: Image.asset(widget.imageSrc, height: 300, width: 300,)),
            SizedBox(height: 60,),
            Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight:Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20,),
                      Text(widget.header, style: TextStyle(fontSize: 25, fontWeight:FontWeight.bold ,color: Colors.white),),
                      SizedBox(height: 20,),
                      Text(widget.text, textAlign:TextAlign.center,style: TextStyle(fontSize: 16, color: Colors.white),),
                    ],),
                )
            ),
          ],
        ),
      ),
    );
  }
}
