class EcoNews {
  final String title, link, category, author, pubDate, description, no, content, imgLink;

  EcoNews({
    required this.title, //제목
    required this.link, //기사 링크
    required this.category, //카테고리 (경제)
    required this.author, //저자 (매일경제)
    required this.pubDate, //업데이트 시간
    required this.description, //간추린 요약본
    required this.no, //고유번호
    required this.content, //기사 본문
    required this.imgLink,
  });
}
