import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// Category Pie Chart
class CategoryPieChart extends StatelessWidget {
  const CategoryPieChart({super.key});

  Stream<QuerySnapshot> getExpensesStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getExpensesStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No data for chart'));
        }

        final docs = snapshot.data!.docs;

        // Group amounts by category
        final Map<String, double> categoryTotals = {};
        for (var doc in docs) {
          final data = doc.data() as Map<String, dynamic>;
          final category = data['category'] ?? 'Other';
          final amount = (data['amount'] ?? 0).toDouble();

          categoryTotals[category] = (categoryTotals[category] ?? 0) + amount;
        }

        // Define colors
        final colors = {
          'Food': Colors.blue,
          'Travel': Colors.orange,
          'Bills': Colors.green,
          'Other': Colors.red,
        };

        // Build pie chart sections
        final sections = categoryTotals.entries.map((entry) {
          return PieChartSectionData(
            value: entry.value,
            title: entry.key,
            color: colors[entry.key] ?? Colors.grey,
            radius: 70,
          );
        }).toList();

        return PieChart(
          PieChartData(
            sections: sections,
            sectionsSpace: 2,
            centerSpaceRadius: 30,
          ),
        );
      },
    );
  }
}