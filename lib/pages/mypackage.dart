// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class Mypackagepage extends StatefulWidget {
  final double userMoney;
  final List<Map<String, dynamic>> purchasedItems;

  const Mypackagepage({
    super.key,
    required this.userMoney,
    required this.purchasedItems,
  });

  @override
  State<Mypackagepage> createState() => _MypackagepageState();
}

class _MypackagepageState extends State<Mypackagepage> {
  void _showItemDetails(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item['name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                item['image'],
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 16),
              Text(
                "描述: \n${item['details'] ?? '未知'}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                "價格: \$${item['price'] ?? '未知'}",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("關閉"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> obtainedItems =
        widget.purchasedItems.where((item) => item['obtain'] == true).toList();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "我的物品",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "我的金錢: \$${widget.userMoney.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "已購買物品:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            if (obtainedItems.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "目前沒有已購買的物品。",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: obtainedItems.length,
              itemBuilder: (context, index) {
                final item = obtainedItems[index];
                return GestureDetector(
                  onTap: () => _showItemDetails(context, item),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              item['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          item['name'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
