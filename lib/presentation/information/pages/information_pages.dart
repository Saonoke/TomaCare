import 'package:flutter/material.dart';
import 'package:tomacare/domain/entities/information.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';

class InformationDetailPage extends StatelessWidget {
  final Information diseaseData;

  const InformationDetailPage({Key? key, required this.diseaseData})
      : super(key: key);

  List<Widget> parseContent(String content) {
    List<Widget> widgets = [];
    List<String> lines = content.split('\n');

    for (String line in lines) {
      if (line.startsWith('- ')) {
        widgets.add(Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '\u2022 ',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            Expanded(
              child: Text(
                line.substring(2),
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
          ],
        ));
      } else {
        widgets.add(Text(
          line,
          style: TextStyle(fontSize: 16, color: Colors.black54),
          textAlign: TextAlign.justify,
        ));
      }
      widgets.add(SizedBox(height: 5));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: neutral03,
      appBar: AppBar(
        title: Text(diseaseData.title),
        backgroundColor: neutral03,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: ListView(
          children: [
            // Title Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    diseaseData.title,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: neutral01,
                    ),
                  ),
                  SizedBox(height: 10),
                  Chip(
                    label: Text(
                      "Type: ${diseaseData.type}",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: primaryColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Deskripsi
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Deskripsi Penyakit",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Divider(color: Colors.grey),
                  ...parseContent(diseaseData.content),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Pengobatan
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pengobatan",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  Divider(color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    diseaseData.medicine,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
