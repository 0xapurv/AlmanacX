import 'package:cherry_components/cherry_components.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:share/share.dart';

import '../../../models/index.dart';
import '../../../repositories/index.dart';
import '../../../util/index.dart';
import '../../widgets/index.dart';
import '../index.dart';

/// This view all information about a specific ship. It displays Ship's specs.
class ShipPage extends StatelessWidget {
  final String id;

  const ShipPage(this.id);

  @override
  Widget build(BuildContext context) {
    final ShipVehicle _ship =
        context.watch<VehiclesRepository>().getVehicle(id);
    return Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        SliverBar(
          title: _ship.name,
          header: InkWell(
            onTap: () => FlutterWebBrowser.openWebPage(
              url: _ship.getProfilePhoto,
              androidToolbarColor: Theme.of(context).primaryColor,
            ),
            child: CacheImage(_ship?.getProfilePhoto),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () => Share.share(
                FlutterI18n.translate(
                  context,
                  'spacex.other.share.ship.body',
                  translationParams: {
                    'date': _ship.getBuiltFullDate,
                    'name': _ship.name,
                    'role': _ship.primaryRole,
                    'port': _ship.homePort,
                    'missions': _ship.hasMissions
                        ? FlutterI18n.translate(
                            context,
                            'spacex.other.share.ship.missions',
                            translationParams: {
                              'missions': _ship.missions.length.toString()
                            },
                          )
                        : FlutterI18n.translate(
                            context,
                            'spacex.other.share.ship.any_missions',
                          ),
                    'details': Url.shareDetails
                  },
                ),
              ),
              tooltip: FlutterI18n.translate(
                context,
                'spacex.other.menu.share',
              ),
            ),
            PopupMenuButton<String>(
              itemBuilder: (context) => [
                for (final item in Menu.ship)
                  PopupMenuItem(
                    value: item,
                    child: Text(FlutterI18n.translate(context, item)),
                  )
              ],
              onSelected: (text) => FlutterWebBrowser.openWebPage(
                url: _ship.url,
                androidToolbarColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        SliverSafeArea(
          top: false,
          sliver: SliverToBoxAdapter(
            child: RowLayout.cards(children: <Widget>[
              _shipCard(context),
              _specsCard(context),
              _missionsCard(context),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _shipCard(BuildContext context) {
    final ShipVehicle _ship =
        context.watch<VehiclesRepository>().getVehicle(id);
    return CardCell.body(
      context,
      title: FlutterI18n.translate(
        context,
        'spacex.vehicle.ship.description.title',
      ),
      child: RowLayout(children: <Widget>[
        RowText(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.ship.description.home_port',
            ),
            _ship.homePort),
        RowText(
          FlutterI18n.translate(
            context,
            'spacex.vehicle.ship.description.built_date',
          ),
          _ship.getBuiltFullDate,
        ),
        Separator.divider(),
        RowText(
          FlutterI18n.translate(
            context,
            'spacex.vehicle.ship.specifications.feature',
          ),
          _ship.use,
        ),
        RowText(
          FlutterI18n.translate(
            context,
            'spacex.vehicle.ship.specifications.model',
          ),
          _ship.getModel(context),
        ),
      ]),
    );
  }

  Widget _specsCard(BuildContext context) {
    final ShipVehicle _ship =
        context.watch<VehiclesRepository>().getVehicle(id);
    return CardCell.body(
      context,
      title: FlutterI18n.translate(
        context,
        'spacex.vehicle.ship.specifications.title',
      ),
      child: RowLayout(children: <Widget>[
        RowText(
          FlutterI18n.translate(
            context,
            'spacex.vehicle.ship.specifications.role_primary',
          ),
          _ship.primaryRole,
        ),
        if (_ship.hasSeveralRoles)
          RowText(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.ship.specifications.role_secondary',
            ),
            _ship.secondaryRole,
          ),
        RowText(
          FlutterI18n.translate(
            context,
            'spacex.vehicle.ship.specifications.status',
          ),
          _ship.getStatus(context),
        ),
        RowText(
          FlutterI18n.translate(
            context,
            'spacex.vehicle.ship.specifications.coordinates',
          ),
          _ship.getCoordinates(context),
        ),
        Separator.divider(),
        RowText(
          FlutterI18n.translate(
            context,
            'spacex.vehicle.ship.specifications.mass',
          ),
          _ship.getMass(context),
        ),
        RowText(
          FlutterI18n.translate(
            context,
            'spacex.vehicle.ship.specifications.speed',
          ),
          _ship.getSpeed(context),
        ),
      ]),
    );
  }

  Widget _missionsCard(BuildContext context) {
    final ShipVehicle _ship =
        context.watch<VehiclesRepository>().getVehicle(id);
    return CardCell.body(
      context,
      title: FlutterI18n.translate(
        context,
        'spacex.vehicle.ship.missions.title',
      ),
      child: _ship.hasMissions
          ? RowLayout(
              children: <Widget>[
                if (_ship.missions.length > 5) ...[
                  for (final mission in _ship.missions.sublist(0, 5))
                    RowTap(
                      FlutterI18n.translate(
                        context,
                        'spacex.vehicle.ship.missions.mission',
                        translationParams: {
                          'number': mission.flightNumber.toString()
                        },
                      ),
                      mission.name,
                      fallback: FlutterI18n.translate(
                        context,
                        'spacex.other.unknown',
                      ),
                      onTap: () => Navigator.pushNamed(
                        context,
                        LaunchPage.route,
                        arguments: {'id': mission.id},
                      ),
                    ),
                  ExpandChild(
                    child: RowLayout(
                      children: <Widget>[
                        for (final mission in _ship.missions.sublist(5))
                          RowTap(
                            FlutterI18n.translate(
                              context,
                              'spacex.vehicle.ship.missions.mission',
                              translationParams: {
                                'number': mission.flightNumber.toString()
                              },
                            ),
                            mission.name,
                            fallback: FlutterI18n.translate(
                              context,
                              'spacex.other.unknown',
                            ),
                            onTap: () => Navigator.pushNamed(
                              context,
                              LaunchPage.route,
                              arguments: {'id': mission.id},
                            ),
                          ),
                      ],
                    ),
                  )
                ] else
                  for (final mission in _ship.missions)
                    RowTap(
                      FlutterI18n.translate(
                        context,
                        'spacex.vehicle.ship.missions.mission',
                        translationParams: {
                          'number': mission.flightNumber.toString()
                        },
                      ),
                      mission.name,
                      fallback: FlutterI18n.translate(
                        context,
                        'spacex.other.unknown',
                      ),
                      onTap: () => Navigator.pushNamed(
                        context,
                        LaunchPage.route,
                        arguments: {'id': mission.id},
                      ),
                    ),
              ],
            )
          : Text(
              FlutterI18n.translate(
                context,
                'spacex.vehicle.ship.missions.no_missions',
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).textTheme.caption.color,
              ),
            ),
    );
  }
}
