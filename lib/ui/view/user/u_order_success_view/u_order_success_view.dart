import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_order_food/core/model/field_name.dart';
import 'package:project_order_food/ui/router.dart';

class UOrderSuccessView extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const UOrderSuccessView({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    final Timestamp createDate = orderData[FieldName.createDate];
    final int totalPrice = orderData[FieldName.totalPrice];
    final String userId = orderData[FieldName.userID];
    final String orderId = orderData['id'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin đơn hàng'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '✅ Đặt hàng thành công!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Mã người dùng: $userId'),
            Text('Ngày đặt: ${createDate.toDate()}'),
            const Divider(),
            const Text(
              'Chi tiết đơn hàng:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('orderDetail')
                    .where(FieldName.refID, isEqualTo: orderId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Không có sản phẩm nào.'));
                  }
                  final items = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.fastfood),
                          title: Text('Món: ${item[FieldName.productID]}'),
                          subtitle: Text('Số lượng: ${item[FieldName.quantity]}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(),
            Text(
              'Tổng tiền: $totalPrice VNĐ',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, RoutePaths.uHomeView);
                },
                icon: const Icon(Icons.home),
                label: const Text('Về trang chủ'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
