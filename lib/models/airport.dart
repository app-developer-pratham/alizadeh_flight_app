class Airport {
  final String code;
  final String city;
  final String country;
  final String airportName;

  const Airport({
    required this.code,
    required this.city,
    required this.country,
    required this.airportName,
  });

  static const List<Airport> popularAirports = [
    Airport(
      code: 'JFK',
      city: 'New york',
      country: 'United States',
      airportName: 'John F. Kennedy International',
    ),
    Airport(
      code: 'ZHR',
      city: 'Zurich',
      country: 'Switzerland',
      airportName: 'Kloten Zurich Airport',
    ),
    Airport(
      code: 'LHR',
      city: 'London',
      country: 'United Kingdom',
      airportName: 'Heathrow Airport',
    ),
    Airport(
      code: 'HND',
      city: 'Tokyo',
      country: 'Japan',
      airportName: 'Haneda International Airport',
    ),
    Airport(
      code: 'CDG',
      city: 'Paris',
      country: 'France',
      airportName: 'Charles de Gaulle Airport',
    ),
    Airport(
      code: 'DXB',
      city: 'Dubai',
      country: 'United Arab Emirates',
      airportName: 'Dubai International Airport',
    ),
    Airport(
      code: 'SIN',
      city: 'Singapore',
      country: 'Singapore',
      airportName: 'Singapore Changi Airport',
    ),
    Airport(
      code: 'SFO',
      city: 'San Francisco',
      country: 'United States',
      airportName: 'San Francisco International',
    ),
  ];
}
