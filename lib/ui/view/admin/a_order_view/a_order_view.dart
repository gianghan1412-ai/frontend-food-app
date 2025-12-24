import 'package:flutter/material.dart';
import 'package:project_order_food/core/model/order_model.dart';
import 'package:project_order_food/core/model/status_order.dart';
import 'package:project_order_food/core/service/get_navigation.dart';
import 'package:project_order_food/locator.dart';
import 'package:project_order_food/ui/base_app/base_view.dart';
import 'package:project_order_food/ui/config/app_style.dart';
import 'package:project_order_food/ui/router.dart';
import 'package:project_order_food/ui/shared/app_color.dart';
import 'package:project_order_food/ui/shared/ui_helpers.dart';
import 'package:project_order_food/ui/view/admin/a_order_view/controllers/a_order_view_controller.dart';
import 'package:project_order_food/ui/widget/common_widget/a_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AOrderView extends BaseView<AOrderViewController> {
  AOrderView({super.key}) : super(AOrderViewController());

  @override
  Widget getMainView(BuildContext context, AOrderViewController controller) {
    return Column(
      children: [
        UIHelper.verticalSpaceSmall(),
        listCategory(),
        UIHelper.verticalSpaceSmall(),
        // Expanded(
        //   child: controller.listOrder.isEmpty
        //       ? Center(
        //           child: AText.listItem('Không có hóa đơn nào'),
        //         )
        //       : ListView.separated(
        //           padding: const EdgeInsets.all(16),
        //           itemCount: controller.listOrder.length,
        //           separatorBuilder: (_, __) {
        //             return const SizedBox(
        //               height: 8,
        //             );
        //           },
        //           itemBuilder: (_, int index) {
        //             return orderCard(controller.listOrder[index]);
        //           },
        //         ),
        // )
      Expanded(
  child: controller.listOrder.isEmpty
      ? Center(
          child: AText.listItem('Không có hóa đơn nào'),
        )
      : Builder(
          builder: (_) {
            // 👉 Sắp xếp theo thời gian mới nhất
            final sortedOrders = List<OrderModel>.from(controller.listOrder);
            sortedOrders.sort((a, b) {
              DateTime dateA;
              DateTime dateB;

              // Kiểm tra kiểu dữ liệu (Timestamp hoặc String)
              if (a.createDate is Timestamp) {
                dateA = (a.createDate as Timestamp).toDate();
              } else {
                dateA = DateTime.tryParse(a.createDate.toString()) ?? DateTime(1970);
              }

              if (b.createDate is Timestamp) {
                dateB = (b.createDate as Timestamp).toDate();
              } else {
                dateB = DateTime.tryParse(b.createDate.toString()) ?? DateTime(1970);
              }

              return dateB.compareTo(dateA); // mới nhất lên đầu
            });

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: sortedOrders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, int index) {
                return orderCard(sortedOrders[index]);
              },
            );
          },
        ),
)

      ],
    );
  }

  Widget listCategory() {
    return Wrap(
      runSpacing: 8,
      spacing: 8,
      children: controller.listStatus.map((e) => itemStatus(e)).toList(),
    );
  }

  Widget itemStatus(StatusOrder status) {
    bool isSelected = status.id == controller.statusID;
    return GestureDetector(
      onTap: () {
        controller.updateStatus(status.id);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AColor.yellow : AColor.white,
          border: Border.all(color: AColor.grey, width: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: isSelected
            ? AText.listItem(status.title)
            : AText.body(status.title),
      ),
    );
  }

  Widget orderCard(OrderModel model) {
    return GestureDetector(
      onTap: () async {
        await locator<GetNavigation>()
            .to(RoutePaths.aOrderDetailView, arguments: model)
            .whenComplete(() => controller.reload());
      },
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          border: Border.all(color: AColor.grey, width: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Image.asset(
              'assets/images/order_list.png',
              height: 90,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AText.listItem('Trạng thái: ${model.status.title}'),
                AText.body('Thời gian đặt: ${model.createDate}'),
                AText.body('Tổng: ${model.totalPrice}', color: AColor.red),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  AppBar? appBar(BuildContext context) {
    return AAppbar(title: 'Danh sách hóa đơn');
  }
}
