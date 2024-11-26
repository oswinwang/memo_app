import 'package:flutter/material.dart';

class ShopListView extends StatelessWidget {
  final List<Map<String, dynamic>> items; 
  const ShopListView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final filteredItems = items.where((item) => item["obtain"] == false).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          "  徽章",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Flexible(
          child: SizedBox(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return GestureDetector(
                  onTap: () {
                    _showPurchaseDialog(context, item["name"], item["price"]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                item["image"]!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item["name"]!,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "\$ " + item["price"]!.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showPurchaseDialog(BuildContext context, String itemName, double itemPrice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("確認購買"),
        content: Text("確定要購買 $itemName 嗎？\n價格為 \$ $itemPrice"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("取消", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _processPurchase(context, itemName);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
            ),
            child: const Text("確定", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _processPurchase(BuildContext context, String itemName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("成功購買了 $itemName!")),
    );
  }
}
