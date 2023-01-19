import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:qandeel/constants/colors.dart';
import 'package:pdf_render/pdf_render.dart';
import 'components/book_card_design.dart';

class Dashboard extends StatefulWidget {
  final String contentType;
  const Dashboard({super.key, required this.contentType});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final currentPage = 0.obs;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getBooks().whenComplete(() {
        setState(() {});
      });
    });
    tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.transparent,
          foregroundColor: AppColor.blackColor,
          elevation: 0,
          leading: MaterialButton(
            onPressed: () {},
            child: SvgPicture.asset(
              'assets/icons/menu.svg',
              width: 25,
              height: 25,
            ),
          ),
          title: Text(
            widget.contentType == 'fiction'
                ? 'فکشن'
                : widget.contentType == 'poetry'
                    ? 'شاعری'
                    : widget.contentType == 'research'
                        ? 'تحقیق و تنقید'
                        : widget.contentType == 'text'
                            ? 'تدریسی کتب'
                            : 'تراجم',
            style: TextStyle(
              fontFamily: "Noori_Nastaleeq",
              fontSize: 18,
            ),
          ),
        ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Obx(() {
                  return TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColor.placeholder.withOpacity(0.1),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SvgPicture.asset(
                          'assets/icons/search.svg',
                          width: 25,
                          height: 25,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(12.5),
                      hintText: currentPage.value == 0
                          ? 'کتاب کے عنوان سے تلاش کریں۔'
                          : 'مصنف کے نام سے تلاش کریں۔',
                      hintStyle: TextStyle(
                        color: AppColor.placeholder,
                        fontSize: 14,
                      ),
                    ),
                  );
                }),
              ),
              TabBar(
                labelColor: AppColor.blackColor,
                unselectedLabelColor: AppColor.placeholder,
                indicatorColor: AppColor.blackColor,
                onTap: (value) {
                  currentPage.value = value;
                },
                labelStyle:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                controller: tabController,
                tabs: [
                  Tab(text: 'کتابیں'),
                  Tab(text: 'مصنفین'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: [
                    FutureBuilder(
                      future: getBooks(),
                      builder: (context, snapshot) {
                        return snapshot.connectionState ==
                                ConnectionState.waiting
                            ? Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColor.blackColor,
                                  ),
                                ),
                              )
                            : snapshot.hasData
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 4.0,
                                        mainAxisExtent: 215,
                                      ),
                                      itemBuilder: (context, index) {
                                        return snapshot.data![index];
                                      },
                                    ),
                                  )
                                : Container();
                      },
                    ),
                    FutureBuilder(
                      future: getAuthers(),
                      builder: (context, snapshot) {
                        return snapshot.connectionState ==
                                ConnectionState.waiting
                            ? Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColor.blackColor,
                                  ),
                                ),
                              )
                            : snapshot.hasData
                                ? Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        return Text(snapshot.data![index]);
                                      },
                                    ),
                                  )
                                : Container();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<BookCard>> getBooks() async {
    final books = <BookCard>[];
    final String response =
        await rootBundle.loadString('assets/json/books.json');
    final data = await json.decode(response);
    for (var item in data['books']) {
      if (item['type'] == widget.contentType) {
        await PdfDocument.openAsset(
                'assets/books/${item['type']}/${item['src']}')
            .then((doc) async {
          await doc.getPage(1).then((page) async {
            await page.render().then((pageImage) async {
              await pageImage.createImageIfNotAvailable().whenComplete(() {
                books.add(
                  BookCard(
                    title: item['title'],
                    auther: item['auther'],
                    url: "${item['type']}/${item['src']}",
                    thumbnail: pageImage.imageIfAvailable ??
                        pageImage.createImageDetached(),
                  ),
                );
              });
            });
          });
        });
      }
    }
    return books;
  }

  Future<List<String>> getAuthers() async {
    final authers = <String>[];
    final String response =
        await rootBundle.loadString('assets/json/books.json');
    final data = await json.decode(response);
    for (var item in data['books']) {
      if (item['type'] == widget.contentType) {
        authers.add(item['auther']);
      }
    }
    return authers.toSet().toList();
  }
}
