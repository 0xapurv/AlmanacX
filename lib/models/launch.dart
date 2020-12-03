import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:intl/intl.dart';

import '../util/index.dart';
import 'index.dart';

/// Details about a specific launch, performed by a Falcon rocket,
/// including launch & landing pads, rocket & payload information...
class Launch extends Equatable {
  final String patchUrl;
  final List<String> links;
  final List<String> photos;
  final DateTime staticFireDate;
  final int launchWindow;
  final bool success;
  final FailureDetails failure;
  final String details;
  final RocketDetails rocket;
  final LaunchpadDetails launchpad;
  final int flightNumber;
  final String name;
  final DateTime launchDate;
  final String datePrecision;
  final bool upcoming;
  final String id;

  const Launch({
    this.patchUrl,
    this.links,
    this.photos,
    this.staticFireDate,
    this.launchWindow,
    this.success,
    this.failure,
    this.details,
    this.rocket,
    this.launchpad,
    this.flightNumber,
    this.name,
    this.launchDate,
    this.datePrecision,
    this.upcoming,
    this.id,
  });

  factory Launch.fromJson(Map<String, dynamic> json) {
    return Launch(
      patchUrl: json['links']['patch']['small'],
      links: [
        json['links']['webcast'],
        json['links']['reddit']['campaign'],
        json['links']['presskit']
      ],
      photos: (json['links']['flickr']['original'] as List).cast<String>(),
      staticFireDate: json['static_fire_date_utc'] != null
          ? DateTime.tryParse(json['static_fire_date_utc'])
          : null,
      launchWindow: json['window'],
      success: json['success'],
      failure: (json['failures'] as List).isNotEmpty
          ? FailureDetails.fromJson((json['failures'] as List).first)
          : null,
      details: json['details'],
      rocket: RocketDetails.fromJson(json),
      launchpad: LaunchpadDetails.fromJson(json['launchpad']),
      flightNumber: json['flight_number'],
      name: json['name'],
      launchDate:
          json['date_utc'] != null ? DateTime.tryParse(json['date_utc']) : null,
      datePrecision: json['date_precision'],
      upcoming: json['upcoming'],
      id: json['id'],
    );
  }

  int compareTo(Launch other) => flightNumber.compareTo(other.flightNumber);

  String getLaunchWindow(BuildContext context) {
    if (launchWindow == null) {
      return FlutterI18n.translate(context, 'spacex.other.unknown');
    } else if (launchWindow == 0) {
      return FlutterI18n.translate(
        context,
        'spacex.launch.page.rocket.instantaneous_window',
      );
    } else if (launchWindow < 60) {
      return '${NumberFormat.decimalPattern().format(launchWindow)} s';
    } else if (launchWindow < 3600) {
      return '${NumberFormat.decimalPattern().format(launchWindow / 60)} min';
    } else if (launchWindow % 3600 == 0) {
      return '${NumberFormat.decimalPattern().format(launchWindow / 3600)} h';
    } else {
      return '${NumberFormat.decimalPattern().format(launchWindow ~/ 3600)}h ${NumberFormat.decimalPattern().format((launchWindow / 3600 - launchWindow ~/ 3600) * 60)}min';
    }
  }

  DateTime get localLaunchDate => launchDate?.toLocal();

  DateTime get localStaticFireDate => staticFireDate?.toLocal();

  String get getNumber => '#${NumberFormat('00').format(flightNumber)}';

  bool get hasPatch => patchUrl != null;

  bool get hasVideo => links[0] != null;

  String get getVideo => links[0];

  bool get tentativeTime => datePrecision != 'hour';

  String getDetails(BuildContext context) =>
      details ??
      FlutterI18n.translate(context, 'spacex.launch.page.no_description');

  String getLaunchDate(BuildContext context) {
    switch (datePrecision) {
      case 'hour':
        return FlutterI18n.translate(
          context,
          'spacex.other.date.time',
          translationParams: {
            'date': getTentativeDate,
            'hour': getTentativeTime
          },
        );
      default:
        return FlutterI18n.translate(
          context,
          'spacex.other.date.upcoming',
          translationParams: {'date': getTentativeDate},
        );
    }
  }

  String get getTentativeDate {
    switch (datePrecision) {
      case 'hour':
        return DateFormat.yMMMMd().format(localLaunchDate);
      case 'day':
        return DateFormat.yMMMMd().format(localLaunchDate);
      case 'month':
        return DateFormat.yMMMM().format(localLaunchDate);
      case 'quarter':
        return DateFormat.yQQQ().format(localLaunchDate);
      case 'half':
        return 'H${localLaunchDate.month < 7 ? 1 : 2} ${localLaunchDate.year}';
      case 'year':
        return DateFormat.y().format(localLaunchDate);
      default:
        return 'date error';
    }
  }

  String get getShortTentativeTime => DateFormat.Hm().format(localLaunchDate);

  String get getTentativeTime =>
      '$getShortTentativeTime ${localLaunchDate.timeZoneName}';

  bool get isDateTooTentative =>
      datePrecision != 'hour' && datePrecision != 'day';

  String getStaticFireDate(BuildContext context) => staticFireDate == null
      ? FlutterI18n.translate(context, 'spacex.other.unknown')
      : DateFormat.yMMMMd().format(localStaticFireDate);

  String get year => localLaunchDate.year.toString();

  int getMenuIndex(BuildContext context, String url) =>
      Menu.launch.indexOf(url) + 1;

  bool isUrlEnabled(BuildContext context, String url) =>
      links[getMenuIndex(context, url)] != null;

  String getUrl(BuildContext context, String name) =>
      links[getMenuIndex(context, name)];

  bool get hasPhotos => photos.isNotEmpty;

  @override
  List<Object> get props => [
        patchUrl,
        links,
        photos,
        staticFireDate,
        launchWindow,
        success,
        failure,
        details,
        rocket,
        launchpad,
        flightNumber,
        name,
        launchDate,
        datePrecision,
        upcoming,
        id,
      ];
}

/// Auxiliary model to storage all details about a rocket which performed a SpaceX's mission.
class RocketDetails extends Equatable {
  final FairingsDetails fairings;
  final List<Core> cores;
  final List<Crew> crew;
  final List<Payload> payloads;
  final String name;
  final String id;

  const RocketDetails({
    this.fairings,
    this.cores,
    this.crew,
    this.payloads,
    this.name,
    this.id,
  });

  factory RocketDetails.fromJson(Map<String, dynamic> json) {
    return RocketDetails(
      fairings: json['fairings'] != null
          ? FairingsDetails.fromJson(json['fairings'])
          : null,
      cores:
          (json['cores'] as List).map((core) => Core.fromJson(core)).toList(),
      crew: (json['crew'] as List).map((crew) => Crew.fromJson(crew)).toList(),
      payloads: (json['payloads'] as List)
          .map((payload) => Payload.fromJson(payload))
          .toList(),
      name: json['rocket']['name'],
      id: json['rocket']['id'],
    );
  }

  bool get isHeavy => cores.length != 1;

  bool get hasFairings => fairings != null;

  Core get getSingleCore => cores[0];

  bool isSideCore(Core core) {
    if (id == null || !isHeavy) {
      return false;
    } else {
      return cores.indexOf(core) != 0;
    }
  }

  bool get isFirstStageNull {
    for (final core in cores) {
      if (core.id != null) return false;
    }
    return true;
  }

  bool get hasMultiplePayload => payloads.length > 1;

  Payload get getSinglePayload => payloads[0];

  bool get hasCapsule => getSinglePayload.capsule != null;

  Core getCore(String id) => cores.where((core) => core.id == id).first;

  @override
  List<Object> get props => [
        fairings,
        cores,
        crew,
        payloads,
        name,
        id,
      ];
}

/// Auxiliary model to storage details about rocket's fairings.
class FairingsDetails extends Equatable {
  final bool reused;
  final bool recoveryAttempt;
  final bool recovered;

  const FairingsDetails({
    this.reused,
    this.recoveryAttempt,
    this.recovered,
  });

  factory FairingsDetails.fromJson(Map<String, dynamic> json) {
    return FairingsDetails(
      reused: json['reused'],
      recoveryAttempt: json['recovery_attempt'],
      recovered: json['recovered'],
    );
  }

  @override
  List<Object> get props => [
        reused,
        recoveryAttempt,
        recovered,
      ];
}

/// Auxiliar model to storage details about a launch failure.
class FailureDetails extends Equatable {
  final num time;
  final num altitude;
  final String reason;

  const FailureDetails({this.time, this.altitude, this.reason});

  factory FailureDetails.fromJson(Map<String, dynamic> json) {
    return FailureDetails(
      time: json['time'],
      altitude: json['altitude'],
      reason: json['reason'],
    );
  }

  String get getTime {
    final StringBuffer buffer = StringBuffer('T${time.isNegative ? '-' : '+'}');
    final int auxTime = time.abs();

    if (auxTime < 60) {
      buffer.write('${NumberFormat.decimalPattern().format(auxTime)} s');
    } else if (auxTime < 3600) {
      buffer.write(
          '${NumberFormat.decimalPattern().format(auxTime ~/ 60)}min ${NumberFormat.decimalPattern().format(auxTime - (auxTime ~/ 60 * 60))}s');
    } else {
      buffer.write(
          '${NumberFormat.decimalPattern().format(auxTime ~/ 3600)}h ${NumberFormat.decimalPattern().format((auxTime / 3600 - auxTime ~/ 3600) * 60)}min');
    }
    return buffer.toString();
  }

  String getAltitude(BuildContext context) => altitude == null
      ? FlutterI18n.translate(context, 'spacex.other.unknown')
      : '${NumberFormat.decimalPattern().format(altitude)} km';

  String get getReason => toBeginningOfSentenceCase(reason);

  @override
  List<Object> get props => [
        time,
        altitude,
        reason,
      ];
}
