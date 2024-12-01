import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:dio/dio.dart';
import 'package:mbauser/helpers/deep_link_handler.dart'; // Import DeepLinkHandler
import '../../main.dart';
import '../../providers/mbaProvider.dart';
import 'package:provider/provider.dart';
import '../../globalVariables.dart';

class CardPaymentPage extends StatefulWidget {
  final Function(String) onPaymentSuccess;
  final String courseId;

  const CardPaymentPage({
    super.key,
    required this.onPaymentSuccess,
    required this.courseId,
  });

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
    _webViewController = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => isLoading = true),
          onPageFinished: (url) {
            setState(() => isLoading = false);
            DeepLinkHandler(navigatorKey).handleDeepLink(Uri.parse(url));
          },
        ),
      );
    _createCardPayment();
  }

  Future<void> _createCardPayment() async {
    final userId = Provider.of<MBAProvider>(context, listen: false).userId;

    try {
      final response = await _dio.post(
        'https://api.m10.az/acquiring/api/v1/orders/actions/create-payment',
        data: {
          'orderId': widget.courseId,
          'currencyISO': 'AZN',
          'amount': '300', // Replace with actual course amount
          'confirmURL': successUrl,
          'cancelURL': cancelUrl,
          'errorURL': errorUrl,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer yourAccessToken', // Replace with your actual token
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
        throw Exception('Failed to create payment: ${response.data}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment creation failed: $e')),
      );
      Navigator.pop(context); // Navigate back on failure
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Card Payment')),
      body: Stack(
        children: [
          WebViewWidget(controller: _webViewController),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
