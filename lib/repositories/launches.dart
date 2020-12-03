import '../models/index.dart';
import '../services/index.dart';
import '../util/index.dart';
import 'index.dart';

enum LaunchType { upcoming, past }

/// Repository that holds a list of launches.
class LaunchesRepository extends BaseRepository<LaunchesService> {
  List<Launch> _upcomingLaunches;
  List<Launch> _pastLaunches;

  LaunchesRepository(LaunchesService service) : super(service);

  @override
  Future<void> loadData() async {
    // Try to load the data using [ApiService]
    try {
      // Receives the data and parse it
      final response = await service.getLaunches();

      final launches = [
        for (final item in response.data['docs']) Launch.fromJson(item)
      ];

      _upcomingLaunches = launches.where((launch) => launch.upcoming).toList();
      _upcomingLaunches.sort((a, b) => a.compareTo(b));

      _pastLaunches = launches.where((launch) => !launch.upcoming).toList();
      _pastLaunches.sort((b, a) => a.compareTo(b));

      finishLoading();
    } catch (_) {
      receivedError();
    }
  }

  List<Launch> getLaunches(LaunchType type) =>
      type == LaunchType.upcoming ? _upcomingLaunches : _pastLaunches;

  Launch getLaunch(String id) => [..._upcomingLaunches, ..._pastLaunches]
      ?.where((launch) => launch.id == id)
      ?.first;

  int getLaunchIndex(LaunchType type, Launch launch) =>
      getLaunches(type).indexOf(launch);

  Launch get upcomingLaunch => _upcomingLaunches?.first;

  int getLaunchesCount(LaunchType type) => getLaunches(type)?.length;

  List<String> getPhotos(LaunchType type) {
    final auxLaunch = getLaunches(type)?.first;

    return auxLaunch?.hasPhotos == true
        ? auxLaunch.photos
        : SpaceXPhotos.upcoming;
  }
}
