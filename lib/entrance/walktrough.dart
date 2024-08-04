import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mbauser/entrance/surveyScreen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../auth/views/selectEntry.dart';

class WalkThroughPage extends StatefulWidget {
  const WalkThroughPage({super.key});

  static final String id = 'walkthrough';

  @override
  State<WalkThroughPage> createState() => _WalkThroughPageState();
}

class _WalkThroughPageState extends State<WalkThroughPage> {
  final controller = PageController(initialPage :0, viewportFraction: 1, keepPage: true);

  int currentPage = 0;

  int getCurrentPage(PageController controller) {
    return controller.page?.round() ?? 0;
  }

  final List<Widget> pagesList = [
    SurveyScreen(
        header: 'TƏCRÜBƏLİ MÜƏLLİMLƏR',
        imageSrc: 'images/1.jpeg',
        text: 'Öz sahələrində kifayət qədər təcrübəyə malik olan, illərdir tələbələri öyrədən müəllimlərdən dərs alın!'
    ),
    SurveyScreen(
        header: 'ASAN ÖYRƏTMƏ',
        imageSrc: 'images/2.jpeg',
        text: 'Müxtəlif həcmdə mühərriklərə malik olan motosikletləri kiçikdən böyüyə real fərdi məşq edərək öyrənin!'
    ),
    SurveyScreen(
        header: 'SƏRBƏST QRAFiK',
        imageSrc: 'images/3.jpeg',
        text: 'Həftənin 7 günü hər gün saat 09 00 -dan 20 00 - dək sizə uyğun bir saatı öncədən seçərək təlimdə iştirak edin!'
    ),

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: 3,
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: (int page) {
                  setState(() {
                    currentPage = page;
                  });
                },
                itemBuilder: (context, index){
                  return pagesList[index];
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmoothPageIndicator(
                    controller: controller,
                    count: pagesList.length,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 20,
                      dotWidth: 20,
                      dotColor: Colors.white70,
                      activeDotColor: Colors.red,
                    ),
                  ),
                ]
              ),
            ),
            IconButton(
                onPressed: (){
                  if(currentPage != 2){
                    controller.nextPage(duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                  }else{
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SelectEntryPage()));
                  }
                  
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.red.shade300,
                ),
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(FontAwesome.chevron_right_solid, color: Colors.black,),
                )
            ),
            SizedBox(width: 30,),
          ],
        ),
      ),
    );
  }
}
