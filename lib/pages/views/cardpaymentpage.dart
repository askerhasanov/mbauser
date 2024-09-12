import 'package:flutter/material.dart';
import 'package:mbauser/elements/colors.dart';

import 'myCoursePage.dart';

class CardPaymentPage extends StatefulWidget {
  const CardPaymentPage({super.key});

  @override
  State<CardPaymentPage> createState() => _CardPaymentPageState();
}




class _CardPaymentPageState extends State<CardPaymentPage> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _curve;

  Future<bool> isSucceeded() async {
    await Future.delayed(Duration(milliseconds: 1000));
    return true;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: ElevatedButton(
            onPressed: () async {
              showDialog(
                barrierColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return Dialog(
                    shadowColor: Colors.black12,
                    child: Container(width: double.infinity,
                      decoration: BoxDecoration(
                        color: MbaColors.lightRed,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: FutureBuilder<bool>(
                          future: isSucceeded(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),],
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              if (snapshot.data!) {

                                ///if true

                                _controller.forward().then((value) async {
                                  await Future.delayed(Duration(seconds: 1));
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyCoursePage(),
                                      ));
                                });

                                return Container(
                                  height: 200,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ScaleTransition(
                                          scale: _curve,
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green,
                                            ),
                                            child: Center(
                                              child: RotationTransition(
                                                turns: _curve,
                                                child: const Icon(Icons.check,
                                                  size: 60,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'Ödəniş uğurludur!',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                /// if false
                                _controller.forward().then((value) async {
                                  await Future.delayed(Duration(seconds: 1));
                                  Navigator.pop(context);
                                });
                                return Container(
                                  height: 200,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ScaleTransition(
                                        scale: _curve,
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red,
                                          ),
                                          child: Center(
                                            child: RotationTransition(
                                              turns: _curve,
                                              child: Icon(
                                                Icons.error_outline,
                                                size: 60,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Xəta baş verdi!',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            } else {
                              return const Text('No data available');
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Text('Ödə'),
          ),
        ),
      ),
    );
  }
}
