import 'package:cached_network_image/cached_network_image.dart';
import 'package:custome_mobile/data/models/attachments_models.dart';
import 'package:custome_mobile/views/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrokerAttachmentsScreen extends StatelessWidget {
  final List<Attachment> attachments;
  final List<AttachmentType> additionalAttachments;
  const BrokerAttachmentsScreen(
      {Key? key,
      required this.attachments,
      required this.additionalAttachments})
      : super(key: key);

  List<Widget> _buildAttachmentslist(List<Attachment> attachments) {
    List<Widget> list = [];
    int i = 0;
    for (var element in attachments) {
      var elem = Container(
        margin: const EdgeInsets.all(7),
        height: 100.h,
        width: 100.w,
        child: CachedNetworkImage(imageUrl: element.image!),
      );
      i++;
      list.add(elem);
    }
    return list;
  }

  List<Widget> _buildAttachmentsTypelist(List<AttachmentType> attachments) {
    List<Widget> list = [];
    int i = 0;
    for (var element in attachments) {
      var elem = SizedBox(
        width: 200.w,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(7),
              height: 100.h,
              width: 100.w,
              child: CachedNetworkImage(imageUrl: element.image!),
            ),
            Text(element.name!)
          ],
        ),
      );
      i++;
      list.add(elem);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(title: "تفاصيل المرفقات"),
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                margin: const EdgeInsets.symmetric(vertical: 7),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("الأوراق المحملة"),
                        SizedBox(
                          height: 5,
                        ),
                        Wrap(children: _buildAttachmentslist(attachments)),
                      ]),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 7),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("الأوراق الاضافية المطلوبة"),
                        SizedBox(
                          height: 5,
                        ),
                        Wrap(
                            children: _buildAttachmentsTypelist(
                                additionalAttachments)),
                      ]),
                ),
              ),
              const SizedBox(
                height: 75,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
