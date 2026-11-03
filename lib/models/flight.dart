class Flight {
  final String id;
  final String airlineName;
  final String airlineCode;
  final String aircraft;
  final String fromCode;
  final String fromCity;
  final String fromTime;
  final String fromTerminal;
  final String toCode;
  final String toCity;
  final String toTime;
  final String toTerminal;
  final String duration;
  final String stopsInfo;
  final String cabinClass;
  final String date;
  final int price;
  final String gate;
  final String seat;
  final String flightNumber;
  final String boardingTime;
  final String passengerName;
  final String logoType;

  const Flight({
    required this.id,
    required this.airlineName,
    required this.airlineCode,
    required this.aircraft,
    required this.fromCode,
    required this.fromCity,
    required this.fromTime,
    required this.fromTerminal,
    required this.toCode,
    required this.toCity,
    required this.toTime,
    required this.toTerminal,
    required this.duration,
    required this.stopsInfo,
    required this.cabinClass,
    required this.date,
    required this.price,
    required this.gate,
    required this.seat,
    required this.flightNumber,
    required this.boardingTime,
    this.passengerName = 'Mohammad Alizadeh',
    required this.logoType,
  });

  static List<Flight> sampleFlights = const [
    Flight(
      id: 'fl-1',
      airlineName: 'American Airlines',
      airlineCode: 'AA',
      aircraft: 'A 380',
      fromCode: 'JFK',
      fromCity: 'New york',
      fromTime: '06:20am',
      fromTerminal: 'T8',
      toCode: 'ZHR',
      toCity: 'Zurich',
      toTime: '04:55pm',
      toTerminal: 'T1',
      duration: '7h 35m',
      stopsInfo: '1 stop in FRA',
      cabinClass: 'Business class',
      date: 'Sep 21, 2024',
      price: 605,
      gate: 'B22',
      seat: '04A',
      flightNumber: 'AA-2849',
      boardingTime: '05:40am',
      logoType: 'american',
    ),
    Flight(
      id: 'fl-2',
      airlineName: 'Delta Airlines',
      airlineCode: 'DL',
      aircraft: '777X',
      fromCode: 'JFK',
      fromCity: 'New york',
      fromTime: '08:15am',
      fromTerminal: 'T4',
      toCode: 'ZHR',
      toCity: 'Zurich',
      toTime: '04:20pm',
      toTerminal: 'T2',
      duration: '7h 05m',
      stopsInfo: '1 stop in CDG',
      cabinClass: 'Business class',
      date: 'Sep 21, 2024',
      price: 660,
      gate: 'A14',
      seat: '02F',
      flightNumber: 'DL-1940',
      boardingTime: '07:35am',
      logoType: 'delta',
    ),
    Flight(
      id: 'fl-3',
      airlineName: 'SWISS International',
      airlineCode: 'LX',
      aircraft: 'A330',
      fromCode: 'JFK',
      fromCity: 'New york',
      fromTime: '05:30pm',
      fromTerminal: 'T4',
      toCode: 'ZHR',
      toCity: 'Zurich',
      toTime: '07:15am',
      toTerminal: 'T1',
      duration: '8h 45m',
      stopsInfo: 'Direct flight',
      cabinClass: 'First class',
      date: 'Sep 21, 2024',
      price: 820,
      gate: 'C08',
      seat: '01A',
      flightNumber: 'LX-401',
      boardingTime: '04:50pm',
      logoType: 'swiss',
    ),
    Flight(
      id: 'fl-4',
      airlineName: 'Emirates',
      airlineCode: 'EK',
      aircraft: 'A380-800',
      fromCode: 'JFK',
      fromCity: 'New york',
      fromTime: '11:20am',
      fromTerminal: 'T4',
      toCode: 'ZHR',
      toCity: 'Zurich',
      toTime: '01:15pm',
      toTerminal: 'T2',
      duration: '13h 55m',
      stopsInfo: '1 stop in DXB',
      cabinClass: 'Business class',
      date: 'Sep 21, 2024',
      price: 910,
      gate: 'D12',
      seat: '07K',
      flightNumber: 'EK-202',
      boardingTime: '10:30am',
      logoType: 'emirates',
    ),
  ];
}

