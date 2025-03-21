part of 'plan.dart';

class RouteInfo extends Equatable {
  final String id;
  final String gtfsId;
  final String? shortName;
  final String? longName;
  final TransportMode? mode;
  final int? type;
  final String? desc;
  final String? url;
  final String? color;
  final String? textColor;

  const RouteInfo({
    required this.id,
    required this.gtfsId,
    this.shortName,
    this.longName,
    this.mode,
    this.type,
    this.desc,
    this.url,
    this.color,
    this.textColor,
  });

  factory RouteInfo.fromJson(Map<String, dynamic> json) => RouteInfo(
        id: json['id'] as String,
        gtfsId: json['gtfsId'] as String,
        shortName: json['shortName'] as String,
        longName: json['longName'] as String,
        mode: getTransportMode(mode: json['mode'].toString()),
        type: int.tryParse(json['type'].toString()) ?? 0,
        desc: json['desc'] as String,
        url: json['url'] as String,
        color: json['color'] as String,
        textColor: json['textColor'] as String,
      );

  Color get primaryColor {
    return color != null ? Color(int.tryParse('0xFF$color')!) : Colors.black;
  }

  Color get backgroundColor {
    return color != null ? Color(int.tryParse('0xFF$color')!) : Colors.black;
  }

  @override
  List<Object?> get props => [
        id,
        gtfsId,
        shortName,
        longName,
        mode,
        type,
        desc,
        url,
        color,
        textColor,
      ];
}
