import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:dio/dio.dart'; // For API calls

class CardPaymentPage extends StatefulWidget {
  final Function(String) onPaymentSuccess; // Callback for successful payment
  final String courseId; // Course ID to include in the payment

  const CardPaymentPage({super.key, required this.onPaymentSuccess, required this.courseId});

  @override
  State<CardPaymentPage> createState() => _CardPaymentPageState();
}

class _CardPaymentPageState extends State<CardPaymentPage> {
  late WebViewController _webViewController;
  bool isLoading = true;
  String paymentUrl = '';
  String transactionId = '';

  final Dio _dio = Dio(); // Initialize Dio for API requests

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController(); // Initialize the WebView controller
    createCardPayment(); // Call to initiate the payment process
  }

  // Function to create payment using m10 API
  Future<void> createCardPayment() async {
    try {
      // Replace 'yourAccessToken' and other details with actual data from the m10 provider
      final response = await _dio.post(
        'https://api.m10.az/acquiring/api/v1/orders/actions/create-payment',
        data: {
          'orderId': widget.courseId, // Unique course ID as order ID
          'currencyISO': 'AZN', // Replace with the currency you need
          'amount': '300', // The amount for the course
          'confirmURL': 'https://yourapp.com/success', // URL when payment succeeds
          'cancelURL': 'https://yourapp.com/cancel', // URL when payment is cancelled
          'errorURL': 'https://yourapp.com/error', // URL when there's an error
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer yourAccessToken', // Replace with actual access token
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          paymentUrl = response.data['paymentURL']; // Get the payment URL from the response
          transactionId = response.data['transactionId']; // Save the transaction ID
        });

        // Load the payment URL in the WebView
        _webViewController.loadRequest(Uri.parse(paymentUrl));
      } else {
        throw Exception('Failed to create payment');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment creation failed: $e')),
      );
    }
  }

  // Handle WebView navigation to check if the payment succeeded or failed
  void _handleWebNavigation(String url) {
    if (url.contains('success')) {
      // If the payment is successful, call the success callback and pass the transaction ID
      widget.onPaymentSuccess(transactionId);
      Navigator.pop(context); // Close the payment page
    } else if (url.contains('cancel') || url.contains('error')) {
      // If the payment failed or was cancelled, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment cancelled or failed')),
      );
      Navigator.pop(context); // Close the payment page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Payment'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator while waiting for the payment URL
          : WebViewWidget(
        controller: _webViewController, // Attach the WebView controller
      ),
    );
  }
}
