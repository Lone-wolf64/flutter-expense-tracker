import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


// Transaction List
class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  Stream<QuerySnapshot> getExpensesStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .orderBy('date', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getExpensesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No expenses yet.'));
        }

        final docs = snapshot.data!.docs;

        return ListView.separated(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final tx = docs[index].data() as Map<String, dynamic>;
            final title = tx['title'] ?? 'Untitled';
            final amount = tx['amount'] ?? 0;
            final category = tx['category'] ?? 'Other';
            final date = (tx['date'] as Timestamp).toDate();

            return ListTile(
              tileColor: Colors.cyan[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              leading: const Icon(Icons.receipt),
              title: Text(title),
              subtitle: Text(
                '$category • ${date.toLocal().toString().split(' ')[0]}',
              ),
              trailing: Text(
                '₹$amount',
                style: const TextStyle(color: Colors.black),
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 12),
        );
      },
    );
  }
}