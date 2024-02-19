import 'dart:ffi';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news/models/econews_model.dart';
import 'package:news/screens/help_screen.dart';
import 'package:news/services/api_service.dart';

import 'package:html/parser.dart' as html_parser;
import 'package:news/services/time.dart';
import 'package:news/widgets/NewsBlock.dart';
import 'package:news/widgets/load_homescreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<EcoNews>> ecoNewsList = ApiService.getTodaysEconomyNews();
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    //WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    initialization();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print

    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!'); //12초
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.blueGrey.shade300,
        title: FutureBuilder(
          future: ecoNewsList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const Center(
                child: Text(
                  '하루뉴스',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }
            return const Text("");
          },
        ),
        leading: FutureBuilder(
          future: ecoNewsList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return IconButton(
                onPressed: () {
                  carouselController.jumpToPage(0);
                },
                icon: const Icon(Icons.home),
              );
            }
            return const Text("");
          },
        ),
        actions: [
          FutureBuilder(
            future: ecoNewsList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpScreen(),
                        ));
                  },
                  icon: const Icon(Icons.help_outline_rounded),
                );
              }
              return const Text("");
            },
          ),
        ],
      ),

      /** FutureBuilder : Future을 기다려주는 위젯!!
       * 알아서 값을 기다려줌.
       * 인자로 future 데이터와, builder 함수를 받음.
       * snapshot으로 데이터가 존재하는지 확인할 수 있음.
       * 로딩-> 출력 가능.
       */

      body: FutureBuilder(
        future: ecoNewsList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: [
                // Expanded(
                //   child: makeList(snapshot),
                // ),
                CarouselSlider.builder(
                  //가로 슬라이더
                  carouselController: carouselController,

                  options: CarouselOptions(
                    enableInfiniteScroll: true, //양 끝 스크롤 벽(역주행/ 넘기 금지)
                    height: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight! - 10,
                    initialPage: 0,
                    viewportFraction: 1, //비율 (0~1)
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                        print(currentIndex);
                      });
                    },
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index, realIndex) {
                    var news = snapshot.data![index];
                    //fetch를 완료했다면 splash를 꺼도 되므로 제거함.
                    FlutterNativeSplash.remove();
                    return newsBlock(news: news);
                  },
                ),
                // for (var news in snapshot.data!)
                //   //데이터 가져오는 데 너무 오래걸리므로 listview로 바꿀 예
                //   Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: newsBlock(news: news),
                //   ),
                Positioned(
                  bottom: 45,
                  right: 20,
                  child: IconButton(
                    onPressed: () {
                      carouselController.nextPage();
                    },
                    icon: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.black,
                    ),
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 45,
                  left: 20,
                  child: IconButton(
                    onPressed: () {
                      carouselController.previousPage();
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.black,
                    ),
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.grey),
                    ),
                  ),
                ),
              ],
            );
          }
          /** 처음 입장 시 로딩화면
           * 로고+ 상표명 등 표시.
           */
          return const LoadHomeScreen();
        },
      ),
    );
  }
}
