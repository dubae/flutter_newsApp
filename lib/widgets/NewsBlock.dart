import 'package:flutter/material.dart';
import 'package:news/models/econews_model.dart';
import 'package:news/services/api_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// 하나의 뉴스 블럭. 제목, 기사 내용 등이 묶여 있음.
class newsBlock extends StatelessWidget {
  newsBlock({
    super.key,
    required this.news,
  }) {
    newsSummary = ApiService.getSummary(title: news.title, content: news.content);
    //print("뉴스콘텐츠:${news.content}");
  }

  final EcoNews news;
  late Future<String> newsSummary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                news.title,
                style: const TextStyle(
                  fontSize: 27,
                ),
              ),
              const SizedBox(
                height: 5,
              ),

              /** 날짜 보기 쉽게 바꾸는 기능 추가하기. */
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(news.pubDate),
                  Text(news.author),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              /**이미지는 추후 기능으로 삽입할 것, 지금은 불필요. */
              Image.network(
                news.imgLink,
                headers: const {
                  "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "AI 요약",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              FutureBuilder(
                future: newsSummary,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data!,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    );
                  }
                  return const SpinKitThreeInOut(
                    color: Colors.black,
                  );
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: const ButtonStyle(),
                      onPressed: () {
                        launchUrlString(news.link);
                      },
                      child: const Text(
                        "뉴스 보러가기",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "위 버튼을 눌러 뉴스 전문을 확인할 수 있습니다.",
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ],
              ),
              // const Text(
              //   "본문",
              //   style: TextStyle(
              //     fontSize: 25,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              // Text(
              //   news.content,
              //   style: const TextStyle(
              //     fontSize: 20,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
