import 'dart:convert';

import 'package:html/parser.dart' as html_parser;
import 'package:intl/intl.dart';
import 'package:news/models/econews_model.dart';
import 'package:news/services/time.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class ApiService {
  static const String baseUrl = "https://www.mk.co.kr";
  static const String rss = "rss";
  static const String economy = "30100041";

/* xml로부터 받아옴 */
  static Future<List<EcoNews>> getTodaysEconomyNews() async {
    //print('getToday run!!');
    final url = Uri.parse('$baseUrl/$rss/$economy');
    final response = await http.get(url);
    List<EcoNews> ecoNewsList = [];
    // print(response.statusCode);
    if (response.statusCode == 200) {
      //xml fetch
      //print("nice fetch!");
      final document = xml.XmlDocument.parse(response.body);

      final newsChannel = document.findAllElements('channel').first; //findAll해야 작동.

      final newsItems = newsChannel.findElements('item');

      Uri htmlUrl;
      String imgLink;
      String formattedTime;
      for (var item in newsItems) {
        formattedTime = item.findElements('pubDate').first.innerText;
        htmlUrl = Uri.parse(item.findElements('link').first.innerText);
        imgLink = "";

        // 기사 html 받아오는 부분.
        final htlmResponse = await http.get(htmlUrl);
        if (htlmResponse.statusCode == 200) {
          //html fetch (시간 형식 맞춰서 가져오기 위해.)
          DateTime newsDateTime = Time().getFormttedTime(htlmResponse.body);
          formattedTime = "${DateTime.now().difference(newsDateTime).inHours} 시간 전";
          imgLink = getImgLink(htlmResponse.body);
        }

        EcoNews addEcoNews = EcoNews(
          title: item.findElements('title').first.innerText,
          link: item.findElements('link').first.innerText,
          category: item.findElements('category').first.innerText,
          author: item.findElements('author').first.innerText,
          pubDate: formattedTime,
          description: item.findElements('description').first.innerText,
          no: item.findElements('no').first.innerText,
          content: await getNewsPage(item.findElements('no').first.innerText),
          imgLink: imgLink,
        );

        ecoNewsList.add(addEcoNews);
      }
      return ecoNewsList;
    }
    throw Error();
  }

/*  html 파서-> 뉴스기사 리턴. */
  static Future<String> getNewsPage(String newsNo) async {
    //print('getNewsPage run!');
    final url = Uri.parse('$baseUrl/news/economy/$newsNo');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final document = html_parser.parse(response.body);
      final newsPage = document.getElementsByClassName('news_cnt_detail_wrap');
      //print(newsPage[0] /*.children[10]*/ .text);
      while (newsPage[0].text.startsWith('\n')) {
        newsPage[0].text = newsPage[0].text.substring(1);
      }
      return newsPage[0].text;
    }

    throw Error();
  }

/* ai 요약본 생성함수 */
  static Future<String> getSummary({required String title, required String content}) async {
    String summaryBaseUrl = "https://naveropenapi.apigw.ntruss.com/text-summary/v1/summarize";
    final url = Uri.parse(summaryBaseUrl);

    /// client id, secret 암호화 필요. gitignore 필수.
    final header = {
      "X-NCP-APIGW-API-KEY-ID": "1za4909xw5",
      "X-NCP-APIGW-API-KEY": "LHLP7AwQ6ecLeCp3Eh74juUgO5wIF2llmyZ41pgE",
      "Content-Type": "application/json",
    };
    //print(title + content);

    ///jsonEncode 안 하니까 오류 나옴. 왜지?
    final body = jsonEncode({
      "document": {
        "title": title,
        "content": content,
      },
      "option": {
        "language": "ko",
        "model": "news",
        "tone": 2,
        "summaryCount": 3
      }
    });
    //print(body);
    final response = await http.post(url, headers: header, body: body);

    if (response.statusCode == 200) {
      // print("요약 결과:${response.body}");
      return jsonDecode(utf8.decode(response.bodyBytes))['summary'];
    } else {
      print("summary failed: ${jsonDecode(response.body)}");
      return "failed";
    }
  }

  static String getImgLink(String responseBody) {
    final document = html_parser.parse(responseBody);
    final metaTag = document.head?.querySelector('meta[property="og:image"]');

    if (metaTag != null) {
      return metaTag.attributes['content']!;
    } else {
      return "failed";
    }
  }
}
