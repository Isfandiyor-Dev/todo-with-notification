class Motivation {
  String author;
  String quotes;

  Motivation({
    required this.author,
    required this.quotes,
  });

  factory Motivation.fromJson(Map<String, dynamic> json) {
    return Motivation(author: json["a"], quotes: json['q']);
  }
}
