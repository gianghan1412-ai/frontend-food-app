
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_order_food/core/service/cart_local_data.dart';
import 'package:project_order_food/core/service/get_navigation.dart';
import 'package:project_order_food/locator.dart';
import 'package:project_order_food/ui/base_app/base_controller.dart';
import 'package:project_order_food/ui/router.dart';
import 'package:project_order_food/ui/view/common_view/loading_view/data_app.dart';

import 'package:project_order_food/ui/widget/dialog/a_dialog.dart';

class UDetailViewController extends BaseController {
  final CartLocalData _cartData = CartLocalData();


  void addCard(String productID) async {
    _cartData.addItemCart(productID).whenComplete(() {
      locator<GetNavigation>().openDialog(
          typeDialog: TypeDialog.sucesss,
          content: 'Thêm vào giỏ hàng thành công');
    });
  }
  Future<void> orderNow(String productID) async {
  final user = locator<DataApp>().user;

  if (user.phoneNumber.isEmpty) {
    locator<GetNavigation>().openDialog(
      typeDialog: TypeDialog.waring,
      content: 'Bạn cần điền thông tin để đặt hàng',
      onSubmit: () {
        locator<GetNavigation>().replaceTo(RoutePaths.uProfileView);
      },
    );
    return;
  }


  locator<GetNavigation>().openDialog(
    content: 'Bạn có chắc chắn muốn đặt món này không?',
    typeDialog: TypeDialog.waring,
    onSubmit: () async {
      try {
        final firestore = FirebaseFirestore.instance;
        final orderData = {
          'userID': user.id,
          'productID': productID,
          'quantity': 1,
          'status': 'pending',
          'createDate': DateTime.now().toIso8601String(),
        };

        // 🔸 Thêm đơn hàng mới
        await firestore.collection('order').add(orderData);

        // 🔸 Hiển thị thông báo thành công
        await locator<GetNavigation>().openDialog(
          content: 'Đặt hàng thành công!',
          typeDialog: TypeDialog.sucesss,
          onClose: () {
            // 🔹 Sau khi xem xong, về trang chủ
            locator<GetNavigation>().replaceTo(RoutePaths.uHomeView);
          },
        );
      } catch (e) {
        locator<GetNavigation>().openDialog(
          content: 'Có lỗi khi đặt hàng: $e',
          typeDialog: TypeDialog.error,
        );
      }
    },
  );
}


  }


