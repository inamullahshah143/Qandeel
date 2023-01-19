import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qandeel/constants/colors.dart';
import 'package:qandeel/home/components/book_view.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String auther;
  final String url;
  final thumbnail;
  const BookCard({
    super.key,
    required this.title,
    required this.auther,
    required this.url,
    required this.thumbnail,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Get.to(BookView(title: title, src: url));
      },
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.width * 0.45,
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.blackColor.withOpacity(0.25),
                          offset: const Offset(1.0, 1.0),
                          blurRadius: 1.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                      color: AppColor.placeholder,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 25,
                  right: 25,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    height: MediaQuery.of(context).size.width * 0.4,
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.blackColor.withOpacity(0.25),
                          offset: const Offset(1.0, 1.0),
                          blurRadius: 1.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                      color: AppColor.placeholder,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: RawImage(image: thumbnail, fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              title,
              maxLines: 1,
              style: const TextStyle(
                fontFamily: "Noori_Nastaleeq",
                fontSize: 16,
                color: AppColor.blackColor,
              ),
            ),
          ),
          Text(
            auther,
            maxLines: 1,
            style: TextStyle(
              fontFamily: "Noori_Nastaleeq",
              fontSize: 14,
              color: AppColor.blackColor.withOpacity(0.5),
            ),
          )
        ],
      ),
    );
  }
}
