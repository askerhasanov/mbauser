import 'package:flutter/material.dart';
import '../pages/views/myCoursePage.dart';
import '../elements/colors.dart';
import '../elements/mbabutton.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String? transactionId;

  const PaymentSuccessPage({Key? key, this.transactionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MbaColors.red,
        title: const Text('Payment Successful', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 100, color: Colors.green),
              const SizedBox(height: 20),
              const Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: MbaColors.dark,
                ),
              ),
              if (transactionId != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Transaction ID: $transactionId',
                    style: const TextStyle(fontSize: 16, color: MbaColors.dark),
                  ),
                ),
              const SizedBox(height: 30),
              MbaButton(
                text: 'Go to My Courses',
                bgColor: MbaColors.red,
                callback: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MyCoursePage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class PaymentCancelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MbaColors.red,
        title: const Text('Payment Cancelled', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cancel, size: 100, color: MbaColors.red),
              const SizedBox(height: 20),
              const Text(
                'Payment was cancelled.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: MbaColors.dark,
                ),
              ),
              const SizedBox(height: 30),
              MbaButton(
                text: 'Back',
                bgColor: MbaColors.red,
                callback: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class PaymentErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MbaColors.red,
        title: const Text('Payment Failed', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 100, color: MbaColors.red),
              const SizedBox(height: 20),
              const Text(
                'Payment failed. Please try again.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: MbaColors.dark,
                ),
              ),
              const SizedBox(height: 30),
              MbaButton(
                text: 'Back',
                bgColor: MbaColors.red,
                callback: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
