class GameModel {
  GameModel({
    required this.id,
    required this.name,
    required this.players,
    required this.gotReward,
    required this.gameType,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.gameLink,
    required this.gameLinkPassword,
    required this.gameLinkId,
    required this.price,
    required this.spots,
    required this.winning,
    required this.marks,
    required this.registered,
    required this.appLink,
    required this.appDownloadLink,
    required this.resultTime,
  });

  late final String id;
  late final String name;
  late final List<dynamic> players;
  late final List<dynamic> gotReward;
  late final String gameType;
  late final String startTime;
  late final String endTime;
  late final String description;
  late final String gameLink;
  late final String gameLinkPassword;
  late final String gameLinkId;
  late final int price;
  late final int spots;
  late final String winning;
  late final int marks;
  late final List<String> registered;
  late final String appLink;
  late final String appDownloadLink;
  late final String resultTime;

  GameModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    players = json['players'] ?? [];
    gotReward = json['gotReward'] ?? [];
    gameType = json['gameType'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    description = json['description'];
    gameLink = json['gameLink'];
    gameLinkPassword = json['gameLinkPassword'];
    gameLinkId = json['gameLinkId'];
    price = json['price'] ?? 0;
    spots = json['spots'] ?? 0;
    winning = json['winning'] ?? '';
    marks = json['marks'] ?? 0;
    registered = List<String>.from(json['registered'] ?? []);
    appLink = json['appLink'] ?? '';
    appDownloadLink = json['appDownloadLink'] ?? '';
    resultTime = json['resultTime'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['players'] = players;
    data['gotReward'] = gotReward;
    data['gameType'] = gameType;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['description'] = description;
    data['gameLink'] = gameLink;
    data['gameLinkPassword'] = gameLinkPassword;
    data['gameLinkId'] = gameLinkId;
    data['price'] = price;
    data['spots'] = spots;
    data['winning'] = winning;
    data['marks'] = marks;
    data['registered'] = registered;
    data['appLink'] = appLink;
    data['appDownloadLink'] = appDownloadLink;
    data['resultTime'] = resultTime;
    return data;
  }
}
