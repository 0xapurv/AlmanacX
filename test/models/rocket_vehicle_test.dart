import 'package:cherry/models/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RocketVehicle', () {
    test('is correctly generated from a JSON', () {
      expect(
        RocketVehicle.fromJson(const {
          'height': {'meters': 22.25},
          'diameter': {'meters': 1.68},
          'mass': {'kg': 30146},
          'first_stage': {
            'thrust_sea_level': {'kN': 420},
            'thrust_vacuum': {'kN': 480},
            'reusable': false,
            'engines': 1,
            'fuel_amount_tons': 44.3
          },
          'second_stage': {
            'thrust': {'kN': 31},
            'payloads': {
              'composite_fairing': {
                'height': {'meters': 3.5},
                'diameter': {'meters': 1.5}
              }
            },
            'reusable': false,
            'engines': 1,
            'fuel_amount_tons': 3.38
          },
          'engines': {
            'isp': {'sea_level': 267, 'vacuum': 304},
            'thrust_sea_level': {'kN': 420},
            'thrust_vacuum': {'kN': 480},
            'type': 'merlin',
            'version': '1C',
            'propellant_1': 'liquid oxygen',
            'propellant_2': 'RP-1 kerosene',
            'thrust_to_weight': 96
          },
          'payload_weights': [
            {'id': 'leo', 'name': 'Low Earth Orbit', 'kg': 450}
          ],
          'flickr_images': [
            'https://imgur.com/DaCfMsj.jpg',
            'https://imgur.com/azYafd8.jpg'
          ],
          'name': 'Falcon 1',
          'type': 'rocket',
          'active': false,
          'stages': 2,
          'boosters': 0,
          'cost_per_launch': 6700000,
          'success_rate_pct': 40,
          'first_flight': '2006-03-24',
          'wikipedia': 'https://en.wikipedia.org/wiki/Falcon_1',
          'description':
              'The Falcon 1 was an expendable launch system privately developed and manufactured by SpaceX during 2006-2009. On 28 September 2008, Falcon 1 became the first privately-developed liquid-fuel launch vehicle to go into orbit around the Earth.',
          'id': '5e9d0d95eda69955f709d1eb'
        }),
        RocketVehicle(
          id: '5e9d0d95eda69955f709d1eb',
          name: 'Falcon 1',
          type: 'rocket',
          description:
              'The Falcon 1 was an expendable launch system privately developed and manufactured by SpaceX during 2006-2009. On 28 September 2008, Falcon 1 became the first privately-developed liquid-fuel launch vehicle to go into orbit around the Earth.',
          url: 'https://en.wikipedia.org/wiki/Falcon_1',
          height: 22.25,
          diameter: 1.68,
          mass: 30146,
          active: false,
          firstFlight: DateTime.parse('2006-03-24'),
          photos: const [
            'https://imgur.com/DaCfMsj.jpg',
            'https://imgur.com/azYafd8.jpg'
          ],
          stages: 2,
          launchCost: 6700000,
          successRate: 40,
          payloadWeights: const [
            PayloadWeight('Low Earth Orbit', 450),
          ],
          engine: Engine(
            thrustSea: 420,
            thrustVacuum: 480,
            thrustToWeight: 96,
            ispSea: 267,
            ispVacuum: 304,
            name: 'merlin 1C',
            fuel: 'RP-1 kerosene',
            oxidizer: 'liquid oxygen',
          ),
          firstStage: Stage(
            reusable: false,
            engines: 1,
            fuelAmount: 44.3,
            thrust: 420,
          ),
          secondStage: Stage(
            reusable: false,
            engines: 1,
            fuelAmount: 3.38,
            thrust: 31,
          ),
          fairingDimensions: const [3.5, 1.5],
        ),
      );
    });
  });

  group('Engine', () {
    test('is correctly generated from a JSON', () {
      expect(
        Engine.fromJson(const {
          'isp': {'sea_level': 267, 'vacuum': 304},
          'thrust_sea_level': {'kN': 420},
          'thrust_vacuum': {'kN': 480},
          'type': 'merlin',
          'version': '1C',
          'propellant_1': 'liquid oxygen',
          'propellant_2': 'RP-1 kerosene',
          'thrust_to_weight': 96
        }),
        Engine(
          thrustSea: 420,
          thrustVacuum: 480,
          thrustToWeight: 96,
          ispSea: 267,
          ispVacuum: 304,
          name: 'merlin 1C',
          fuel: 'RP-1 kerosene',
          oxidizer: 'liquid oxygen',
        ),
      );
    });
  });

  group('PayloadWeight', () {
    test('is correctly generated from a JSON', () {
      expect(
        PayloadWeight.fromJson(
          const {
            'id': 'leo',
            'name': 'Low Earth Orbit',
            'kg': 450,
          },
        ),
        PayloadWeight(
          'Low Earth Orbit',
          450,
        ),
      );
    });
  });

  group('Stage', () {
    test('First stage is correctly generated from a JSON', () {
      expect(
        Stage.fromJson(const {
          'thrust_sea_level': {'kN': 420},
          'thrust_vacuum': {'kN': 480},
          'reusable': false,
          'engines': 1,
          'fuel_amount_tons': 44.3
        }),
        Stage(
          reusable: false,
          engines: 1,
          fuelAmount: 44.3,
          thrust: 420,
        ),
      );
    });

    test('Second stage is correctly generated from a JSON', () {
      expect(
        Stage.fromJson(const {
          'thrust': {'kN': 31},
          'payloads': {
            'composite_fairing': {
              'height': {'meters': 3.5},
              'diameter': {'meters': 1.5}
            }
          },
          'reusable': false,
          'engines': 1,
          'fuel_amount_tons': 3.38
        }),
        Stage(
          reusable: false,
          engines: 1,
          fuelAmount: 3.38,
          thrust: 31,
        ),
      );
    });
  });
}
