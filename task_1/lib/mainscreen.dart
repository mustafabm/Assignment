import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task_1/loading.dart';
import 'models/facility.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool loading = true;

  List<Option> propType = [];
  List<Option> numbrofrooms = [];
  List<Option> othrFacility = [];
  List<List<int>> exclusions = [];

  @override
  void initState() {
    super.initState();
    getjson();
  }

  Future<void> getjson() async {
    var url = 'https://my-json-server.typicode.com/ricky1550/pariksha/db';
    var response = await http.get(Uri.parse(url));
    //print(jsonDecode(response.body).runtimeType);
    var database = jsonDecode(response.body);
    Map<String, dynamic> pt = database['facilities'][0];
    Map<String, dynamic> nor = database['facilities'][1];
    Map<String, dynamic> of = database['facilities'][2];
    List<dynamic> ex = database['exclusions'];
    pt['options'].forEach((element) {
      Facility facility = Facility(pt['name'], int.parse(pt['facility_id']));
      Option opt = Option(element['name'], int.parse(element['id']), false,
          icons[element['icon']]!, facility);
      propType.add(opt);
    });
    nor['options'].forEach((element) {
      Facility facility = Facility(nor['name'], int.parse(nor['facility_id']));
      Option opt = Option(element['name'], int.parse(element['id']), false,
          icons[element['icon']]!, facility);
      numbrofrooms.add(opt);
    });
    of['options'].forEach((element) {
      Facility facility = Facility(of['name'], int.parse(of['facility_id']));
      Option opt = Option(element['name'], int.parse(element['id']), false,
          icons[element['icon']]!, facility);
      othrFacility.add(opt);
    });

    for (var element in ex) {
      List<int> exclsn = [-1, -1, -1];
      var index0 = int.parse(element[0]['facility_id']) - 1;
      var index1 = int.parse(element[1]['facility_id']) - 1;
      var value0 = int.parse(element[0]['options_id']);
      var value1 = int.parse(element[1]['options_id']);
      exclsn[index0] = value0;
      exclsn[index1] = value1;
      exclusions.add(exclsn);
    }
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Task 1'),
        ),
        body: loading
            ? const LoadingScreen()
            : Container(
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  checkListbuilder(propType),
                  checkListbuilder(numbrofrooms),
                  checkListbuilder(othrFacility)
                ])));
  }

  Widget checkListbuilder(List<Option> options) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4,
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(top: 5),
              height: 50,
              color: Colors.blue,
              child: Center(
                  child: Text(
                options[0].facility.name,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1.1),
              ))),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  if (optionallowed(options[index])) {
                    return CheckboxListTile(
                      value: options[index].selected,
                      title: Text(options[index].name),
                      controlAffinity: ListTileControlAffinity.leading,
                      secondary: options[index].icon,
                      tileColor: Colors.white,
                      onChanged: (value) {
                        check(index, options);
                        setState(() {});
                      },
                    );
                  } else {
                    return ListTile(
                      title: Text(options[index].name),
                      tileColor: Colors.grey[300],
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  check(int index, List<Option> options) {
    for (int i = 0; i < options.length; i++) {
      options[i].selected = (index == i) ? !options[i].selected : false;
    }
  }

  bool optionallowed(Option option) {
    if (option.facility.id == 1) {
      int currNorId = -1;
      int currOfId = -1;
      for (var element in numbrofrooms) {
        currNorId = element.selected ? element.id : currNorId;
      }
      for (var element in othrFacility) {
        currOfId = element.selected ? element.id : currOfId;
      }
      for (var element in exclusions) {
        if (element[0] == option.id &&
            ((element[1] == currNorId && element[2] == -1) ||
                (element[1] == -1 && element[2] == currOfId))) {
          return false;
        }
      }
      return true;
    } else if (option.facility.id == 2) {
      int currPtId = -1;
      int currOfId = -1;
      for (var element in propType) {
        currPtId = element.selected ? element.id : currPtId;
      }
      for (var element in othrFacility) {
        currOfId = element.selected ? element.id : currOfId;
      }
      for (var element in exclusions) {
        if (element[1] == option.id &&
            ((element[0] == currPtId && element[2] == -1) ||
                (element[0] == -1 && element[2] == currOfId))) {
          return false;
        }
      }
      return true;
    } else {
      int currPtId = -1;
      int currNorId = -1;
      for (var element in propType) {
        currPtId = element.selected ? element.id : currPtId;
      }
      for (var element in numbrofrooms) {
        currNorId = element.selected ? element.id : currNorId;
      }
      for (var element in exclusions) {
        if (element[2] == option.id &&
            ((element[0] == currPtId && element[1] == -1) ||
                (element[0] == -1 && element[1] == currNorId))) {
          return false;
        }
      }
      return true;
    }
  }
}
