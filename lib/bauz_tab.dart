import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'con_update_model.dart';
import 'constantd.dart';
import 'construction_model.dart';

Future<void> showBauzTable(BuildContext context) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return BauzTable();
    },
  );
}

class BauzTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Bauztein table'),
      content: Container(width: 900, child: MyTable()),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}

class MyTable extends StatefulWidget {
  @override
  State<MyTable> createState() => _MyTableState();
}

class _MyTableState extends State<MyTable> {



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

   late List<TextEditingController> _controllers;
   late TextEditingController secondController;


  List<ConstructionModel> responseDataList = [];

  Future<void> fetchConstructionTypeData(int poleid) async {
    print('Fetching ConstructionTypeData2 info for poleid: $poleid');

    final response = await http.get(
      Uri.parse(
          'https://fa-zeck-demo.azurewebsites.net/api/data/pole/constructiontime/18?code=58Ihuc2f0a_jo2mW-TyfSzqQh2uNZ6PWmB_h0XcSyX1EAzFu0ALyBA==&clientId=default'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);

      if (responseData.isNotEmpty) {
        // Use the factory constructor to create QConstructionTypeData objects
        final List<ConstructionModel> constructionTypeDataList =
        responseData
            .map((data) => ConstructionModel.fromJson(data))
            .toList();

        setState(() {
          responseDataList = constructionTypeDataList;
        });
      }
    } else {
      // Handle the API error here.
      print('Failed to fetch ConstructionTypeData2 data. Status code: ${response.statusCode}');
    }
  }



  @override
  void initState() {
    super.initState();
    _controllers = List.generate(bauzeiten.length, (index) => TextEditingController());
    secondController = TextEditingController();
    fetchConstructionTypeData(13); // Fetch data when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(label: Text('Bauzeiten')),
        DataColumn(label: Text('SOLL')),
        DataColumn(label: Text('IST')),
        DataColumn(label: Text('DIFF')),
        DataColumn(label: Text('')),
      ],
      rows: [
        // Existing rows mapped from responseDataList
        ...responseDataList
            .asMap() // Use asMap to get the index of each item
            .map(
              (index, constructionData) => MapEntry(
            index,
            DataRow(
              cells: <DataCell>[
                // Map bauzeiten values to Bauzeiten column
                DataCell(Text(bauzeiten[index])),
                DataCell(Text(constructionData.spanSectionNumber.toString())),
                DataCell(
                  TextField(
                    controller: _controllers[index],
                    decoration: InputDecoration(
                      hintText: 'No IST Value',
                    ),
                    onChanged: (value) {
                      setState(() {

                      });
                    },
                  ),
                ),
                DataCell(Text('')), // Display calculated DIFF
                DataCell(
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Update IST'),
                  ),
                ),
              ],
            ),
          ),
        )
            .values
            .toList(),

        // Additional rows added manually
        DataRow(
          cells: <DataCell>[
            DataCell(Text(bauzeiten[1])),
            DataCell(Text(responseDataList.isNotEmpty
                ? responseDataList[0].poleNumber.toString()
                : 'N/A')),
            DataCell(
              TextField(
                controller: secondController,
                decoration: InputDecoration(
                  hintText: 'No IST Value',
                ),
                onChanged: (value) {
                  setState(() {

                  });
                },
              ),
            ),
            DataCell(Text(responseDataList[0].startDiff.toString())), // Display calculated DIFF
            DataCell(
              ElevatedButton(
                onPressed: () {
                  final ConUpdateModel conModel = ConUpdateModel(
                    constructionTime: ConstructionTime(
                      startActual: secondController.text.toString()
                    )
                  );

                  updateConstructionTypeData(conModel);
                },
                child: Text('Update IST'),
              ),
            ),
          ],
        ),

        DataRow(
          cells: <DataCell>[
            DataCell(Text(bauzeiten[2])),
            DataCell(Text(responseDataList.isNotEmpty
                ? responseDataList[0].startTarget.toString()
                : 'N/A')),
            DataCell(
              TextField(

                decoration: InputDecoration(
                  hintText: 'Enter IST',
                ),
                onChanged: (value) {
                  setState(() {

                  });
                },
              ),
            ),
            DataCell(Text('')),
            DataCell(
              ElevatedButton(
                onPressed: () {},
                child: Text('Update IST'),
              ),
            ),
          ],
        ),

        DataRow(
          cells: <DataCell>[
            DataCell(Text(bauzeiten[3])),
            DataCell(Text(responseDataList.isNotEmpty
                ? responseDataList[0].bvmSuccessorTarget.toString()
                : 'N/A')),
            DataCell(
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter IST',
                ),
                onChanged: (value) {
                  setState(() {

                  });
                },
              ),
            ),
            DataCell(Text('')),
            DataCell(
              ElevatedButton(
                onPressed: () {},
                child: Text('Update IST'),
              ),
            ),
          ],
        ),

        DataRow(
          cells: <DataCell>[
            DataCell(Text(bauzeiten[4])),
            DataCell(Text(responseDataList.isNotEmpty
                ? responseDataList[0].endTarget.toString()
                : 'N/A')),
            DataCell(
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter IST',
                ),
                onChanged: (value) {

                },
              ),
            ),
            DataCell(Text('')),
            DataCell(
              ElevatedButton(
                onPressed: () {},
                child: Text('Update IST'),
              ),
            ),
          ],
        ),

        DataRow(
          cells: <DataCell>[
            DataCell(Text(bauzeiten[5])),
            DataCell(Text(responseDataList.isNotEmpty
                ? responseDataList[0].ffPredecessorTarget.toString()
                : 'N/A')),
            DataCell(
              TextField(

                decoration: InputDecoration(
                  hintText: 'Enter IST',
                ),
                onChanged: (value) {
                  setState(() {

                  });
                },
              ),
            ),
            DataCell(Text('')),
            DataCell(
              ElevatedButton(
                onPressed: () {},
                child: Text('Update IST'),
              ),
            ),
          ],
        ),
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

}