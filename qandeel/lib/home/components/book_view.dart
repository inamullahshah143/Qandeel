import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qandeel/constants/colors.dart';

class BookView extends StatefulWidget {
  final String title;
  final String src;
  const BookView({
    super.key,
    required this.title,
    required this.src,
  });

  @override
  State<BookView> createState() => _BookViewState();
}

class _BookViewState extends State<BookView> {
  bool _isLoading = true;
  PDFDocument? document;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadDocument();
    });
    super.initState();
  }

  loadDocument() async {
    document = await PDFDocument.fromAsset('assets/books/${widget.src}');
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColor.transparent,
          elevation: 0,
          foregroundColor: AppColor.blackColor,
          actions: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 18,
              ),
            ),
          ],
          title: Text(
            widget.title,
            style: TextStyle(
              fontFamily: "Noori_Nastaleeq",
              fontSize: 18,
            ),
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColor.blackColor,
                ),
              )
            : PDFViewer(
                document: document!,
                zoomSteps: 1,
                progressIndicator: CircularProgressIndicator(
                  color: AppColor.blackColor,
                ),
                pickerButtonColor: AppColor.blackColor,
                lazyLoad: true,
                scrollDirection: Axis.horizontal,
              ),
      ),
    );
  }
}
