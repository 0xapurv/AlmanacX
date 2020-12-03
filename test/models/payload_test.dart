import 'package:cherry/models/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Payload', () {
    test('is correctly generated from a JSON', () {
      expect(
        Payload.fromJson(const {
          "dragon": {
            "capsule": {
              "reuse_count": 1,
              "water_landings": 1,
              "last_update": "descripction",
              "launches": [
                {
                  "flight_number": 10,
                  "name": "CRS-2",
                  "date_utc": "2015-06-28T14:21:00.000Z",
                  "id": "5eb87ce1ffd86e000604b333"
                }
              ],
              "serial": "C104",
              "status": "unknown",
              "type": "Dragon 1.0",
              "id": "5e9e2c5bf359189ef23b2667"
            }
          },
          "name": "FalconSAT-2",
          "reused": true,
          "customers": ["DARPA"],
          "nationalities": ["United States"],
          "manufacturers": ["SSTL"],
          "mass_kg": 20,
          "orbit": "LEO",
          "periapsis_km": 400,
          "apoapsis_km": 500,
          "inclination_deg": 39,
          "period_min": 90.0,
          "id": "5eb0e4b5b6c3bb0006eeb1e1"
        }),
        Payload(
          capsule: CapsuleDetails(
            reuseCount: 1,
            splashings: 1,
            lastUpdate: 'descripction',
            launches: [
              LaunchDetails(
                flightNumber: 10,
                name: 'CRS-2',
                date: DateTime.parse('2015-06-28T14:21:00.000Z'),
                id: '5eb87ce1ffd86e000604b333',
              )
            ],
            serial: 'C104',
            status: 'unknown',
            type: 'Dragon 1.0',
            id: '5e9e2c5bf359189ef23b2667',
          ),
          name: 'FalconSAT-2',
          reused: true,
          customer: 'DARPA',
          nationality: 'United States',
          manufacturer: 'SSTL',
          mass: 20,
          orbit: 'LEO',
          periapsis: 400,
          apoapsis: 500,
          inclination: 39,
          period: 90.0,
          id: '5eb0e4b5b6c3bb0006eeb1e1',
        ),
      );
    });
  });
}
