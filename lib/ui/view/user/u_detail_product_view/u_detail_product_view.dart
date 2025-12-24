import 'package:flutter/material.dart';
import 'package:project_order_food/core/model/product.dart';
import 'package:project_order_food/ui/base_app/base_view.dart';
import 'package:project_order_food/ui/config/app_style.dart';
import 'package:project_order_food/ui/shared/app_color.dart';
import 'package:project_order_food/ui/shared/ui_helpers.dart';
import 'package:project_order_food/ui/view/user/u_detail_product_view/controller/u_detail_product_view_controller.dart';

import 'package:project_order_food/ui/widget/common_widget/a_appbar.dart';

class UDetailProductView extends BaseView<UDetailViewController> {
  final Product model;
  UDetailProductView({required this.model, super.key})
      : super(UDetailViewController());

  @override
  AppBar? appBar(BuildContext context) {
    return AAppbar(title: 'Thông tin chi tiết');
  }

  @override
  Widget getMainView(BuildContext context, UDetailViewController controller) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            banner(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AText.listItem(model.title),
                  UIHelper.verticalSpace(8),
                  rowPrice(),
                  UIHelper.verticalSpace(8),
                  AText.body(model.description, maxLines: null),
                ],
              ),
            ),
          ],
        ),
      ),

      // ✅ Phần sửa chính ở đây
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => controller.addCard(model.id),
                  icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
                  label: const Text(
                    'Thêm vào giỏ',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => controller.orderNow(model.id),
                  icon: const Icon(Icons.shopping_bag, color: Colors.white),
                  label: const Text(
                    'Đặt hàng',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rowPrice() {
    return Row(
      children: [
        AText.body(model.strDiscountPrice, color: AColor.red),
        UIHelper.horizontalSpace(6),
        AText.caption(
          model.strPrice,
          color: AColor.red,
          textDecoration: TextDecoration.lineThrough,
        ),
      ],
    );
  }

  Widget banner() {
    return Hero(
      tag: model.id,
      child: Image.network(
        model.img,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
