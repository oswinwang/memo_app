import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShopListView extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final String userId;

  const ShopListView({super.key, required this.items, required this.userId});

  @override
  State<ShopListView> createState() => _ShopListViewState();
}

class _ShopListViewState extends State<ShopListView> {
  late List<Map<String, dynamic>> filteredItems;

  @override
  void initState() {
    super.initState();
    _filterItems();
  }

  void _filterItems() {
    setState(() {
      filteredItems = widget.items.where((item) => item["obtain"] == false).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    _showPurchaseDialog(context, item);
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

  void _showPurchaseDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("確認購買"),
        content: Text("確定要購買 ${item["name"]} 嗎？\n價格為 \$ ${item["price"]}"),
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
              _purchaseItem(context, item);
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

  Future<void> _purchaseItem(BuildContext context, Map<String, dynamic> item) async {
    final url = Uri.parse('http://192.168.193.141:5000/API/Purchase/${widget.userId}/${item["id"]}');
    try {
      final response = await http.post(url);
      if (response.statusCode == 201) {
        setState(() {
          item["obtain"] = true; // 更新本地的物品狀態
          _filterItems(); // 重新整理清單
        });
        _showSnackBar(context, "成功購買了 ${item["name"]}!");
      } else if (response.statusCode == 400) {
        final message = json.decode(response.body)["message"];
        _showSnackBar(context, "購買失敗: 資金不足！");
      } else {
        _showSnackBar(context, "購買失敗: 伺服器錯誤！");
      }
    } catch (e) {
      _showSnackBar(context, "購買失敗: 請檢查網路連線！");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.black,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

