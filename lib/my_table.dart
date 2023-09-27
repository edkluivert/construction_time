import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'con_update_model.dart';
import 'constantd.dart';
import 'construction_model.dart';

class MyTablet extends StatefulWidget {
  const MyTablet({super.key});

  @override
  State<MyTablet> createState() => _MyTabletState();
}

class _MyTabletState extends State<MyTablet> {

  final List<String> bauzeiten = [
    "Abspann-abschnitt",
    "Mastnummer",
    "Start",
    "Ende",
    "Bauvorbereitende Maßnahmen",
    "Fällfreigabe",
    "Wurzelstumprodung",
    "Wegebau",
    "Fundamentbau * Vorgänger Liefertermin Fußanker",
    "Aushärtezeit Beton (Stocken)",
    "Aushärtezeit Beton (Seilzug)",
    "Fundament verfüllen",
    "Vormontage * Vorgänger Stahl Liefertermin",
    "Kranmontage / Stocken",
    "Seilzug * Vorgänger Abspannabsch. Fertig gebaut",
    "Betriebsbereitschaft  * Vorgänger Abnahmen"
  ];



  ConstructionModel? constructionModel;

  Future<void> fetchConstructionTypeData(int poleid) async {
    print('Fetching ConstructionTypeData2 info for poleid: $poleid');

    final response = await http.get(
      Uri.parse(
          'https://fa-zeck-demo.azurewebsites.net/api/data/pole/constructiontime/18?code=58Ihuc2f0a_jo2mW-TyfSzqQh2uNZ6PWmB_h0XcSyX1EAzFu0ALyBA==&clientId=default'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);

      if (responseData != null) {
        // Use the factory constructor to create QConstructionTypeData objects
        final ConstructionModel constructionTypeData = ConstructionModel.fromJson(responseData);
       print('got it ${responseData.toString()}');
        setState(() {
          if(constructionModel != null){
            constructionModel = constructionTypeData;
          }

        });
      }
    } else{
    print('Failed to fetch ConstructionTypeData2 data. Status code: ${response.statusCode}');
    }
  }

  late List<TextEditingController> _controllers;
  late TextEditingController secondController;


  @override
  void initState() {
    super.initState();
    _controllers = List.generate(bauzeiten.length, (index) => TextEditingController());
    secondController = TextEditingController();
    fetchConstructionTypeData(13); // Fetch data when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Table(
     border: TableBorder.all(
       color: Colors.blue,
     ),
     defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Colors.redAccent,
          ),
          children: [
            TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('hey'),
                )),

            TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('hey'),
                )),

            TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('hey'),
                )),
          ]
        ),
        ...List.generate(20, (index) => TableRow(
          children: [
            TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('hey'),
                )),
            TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('hey'),
                )),
            TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('hey'),
                )),
          ]
        ))
      ],
    );
  }

  Future<void> updateConstructionTypeData(ConUpdateModel updateModel) async {
    print('Making an update');

    Map<String, dynamic> body = updateModel.toJson();
    final response = await http.put(
      Uri.parse(
          'https://fa-zeck-demo.azurewebsites.net/api/data/pole/constructiontime/18?code=58Ihuc2f0a_jo2mW-TyfSzqQh2uNZ6PWmB_h0XcSyX1EAzFu0ALyBA==&clientId=default'),
      body: jsonEncode(body),
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );

    if (response.statusCode == 200) {

      fetchConstructionTypeData(13);

    } else {
      // Handle the API error here.
      print('Failed to fetch ConstructionTypeData2 data. Status code: ${response.statusCode}');
    }
  }

  // final ConUpdateModel conModel = ConUpdateModel(
  //     constructionTime: ConstructionTime(
  //         startActual: secondController.text.toString()
  //     )
  // );
  //
  // updateConstructionTypeData(conModel);

}

