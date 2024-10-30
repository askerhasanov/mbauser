import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import '../../providers/mbaProvider.dart';
import 'myCoursePage.dart';

class CardPaymentPage extends StatefulWidget {
  final Function(String) onPaymentSuccess;
  final String courseId;

  const CardPaymentPage({super.key, required this.onPaymentSuccess, required this.courseId});

  @override
  State<CardPaymentPage> createState() => _CardPaymentPageState();
}

class _CardPaymentPageState extends State<CardPaymentPage> {
  late WebViewController _webViewController;
  bool isLoading = true;
  String paymentUrl = '';
  String transactionId = '';

  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController();
    createCardPayment();
  }

  Future<void> createCardPayment() async {
    final userId = Provider.of<MBAProvider>(context, listen: false).userId;
    try {
      final response = await _dio.post(
        'https://api.m10.az/acquiring/api/v1/orders/actions/create-payment',
        data: {
          'orderId': widget.courseId,
          'currencyISO': 'AZN',
          'amount': '300', // Update amount as needed
          'confirmURL': 'https://yourapp.com/success',
          'cancelURL': 'https://yourapp.com/cancel',
          'errorURL': 'https://yourapp.com/error',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer yourAccessToken', // Replace with actual token
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          paymentUrl = response.data['paymentURL'];
          transactionId = response.data['transactionId'];
        });
        _webViewController.loadRequest(Uri.parse(paymentUrl));
      } else {
        throw Exception('Failed to create payment');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment creation failed: $e')),
      );
    }
  }

  void _handleWebNavigation(String url) {
    final userId = Provider.of<MBAProvider>(context, listen: false).userId;
    if (url.contains('success')) {
      widget.onPaymentSuccess(transactionId);
      FirebaseDatabase.instance.ref('payments/card').push().set({
        'courseId': widget.courseId,
        'userId': userId,
        'transactionId': transactionId,
        'status': 'paid',
        'amount': '300',
        'date': DateFormat('d/MMMM/y').format(DateTime.now()).toString(),
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyCoursePage()));
    } else if (url.contains('cancel') || url.contains('error')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment cancelled or failed')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Card Payment')),
      body: Stack(
        children: [
          WebViewWidget(controller: _webViewController),
          if (isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
