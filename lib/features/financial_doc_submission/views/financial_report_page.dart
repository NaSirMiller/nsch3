import 'package:flutter/material.dart';

class FinancialReportPage extends StatelessWidget {
  const FinancialReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    // You must return a Widget here
    return Scaffold(
      appBar: AppBar(title: const Text('Financial Report')),
      body: const Center(child: Text('This is the financial report page')),
    );
  }
}
