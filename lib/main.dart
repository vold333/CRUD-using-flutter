import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CrudScreen(),
    );
  }
}

class CrudScreen extends StatefulWidget {
  @override
  _CrudScreenState createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  List<Map<String, dynamic>> data = [];
  String? selectedId;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = 'http://localhost:8080/empdetails/all';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        data = responseData.map((e) => e as Map<String, dynamic>).toList();
      });
    } else {
      print('Failed to load data');
    }
  }

  Future<void> submitData() async {
    final name = nameController.text;
    final age = ageController.text;

    final url = 'http://localhost:8080/empdetails/add';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'age': age,
      }),
    );

    if (response.statusCode == 200) {
      fetchData();
      nameController.clear();
      ageController.clear();
    } else {
      print('Failed to submit data');
    }
  }

  Future<void> updateData() async {
    final name = nameController.text;
    final age = ageController.text;
    final id = selectedId;

    if (id == null) {
      print('No ID selected for update');
      return;
    }

    final url = 'http://localhost:8080/empdetails/update';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id': id, // Include the id in the JSON body
        'name': name,
        'age': age,
      }),
    );

    if (response.statusCode == 200) {
      fetchData();
      nameController.clear();
      ageController.clear();
      setState(() {
        selectedId = null;
      });
    } else {
      print('Failed to update data');
    }
  }

  Future<void> deleteData(String id) async {
    final url = 'http://localhost:8080/empdetails/delete';
    final response = await http.delete(Uri.parse('$url/$id'));

    if (response.statusCode == 200) {
      fetchData();
    } else {
      print('Failed to delete data');
    }
  }

  void populateFields(Map<String, dynamic> entry) {
    setState(() {
      selectedId = entry['id'].toString();
      nameController.text = entry['name'];
      ageController.text = entry['age'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedId == null ? submitData : updateData,
              child: Text(selectedId == null ? 'Submit' : 'Update'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Employee Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Age')),
                DataColumn(label: Text('Actions')),
              ],
              rows: data
                  .map(
                    (entry) => DataRow(
                  cells: [
                    DataCell(Text(entry['id'].toString())),
                    DataCell(Text(entry['name'])),
                    DataCell(Text(entry['age'].toString())),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              populateFields(entry);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              deleteData(entry['id'].toString());
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
