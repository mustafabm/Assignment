import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

List<String> labels = ['Italy', 'Rome', 'Moscow', 'Varanasi'];

List<bool> selected = [false, false, false, false];
TextEditingController myController = TextEditingController();
ScrollController myScroll = ScrollController();
String newItem = '';

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task 2'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 5)),
              child: checkListbuilder(labels),
              height: MediaQuery.of(context).size.height * 0.3),
          const Divider(
            color: Colors.black,
            thickness: 5,
          ),
          Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            child: TextField(
              controller: myController,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: "Enter Name",
              ),
              onEditingComplete: () {
                newItem = myController.text;
                setState(() {});
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
            child: ElevatedButton(
                onPressed: () {
                  if (newItem.isEmpty) {
                    return;
                  }
                  labels.add(newItem);
                  selected.add(false);

                  setState(() {});
                  myScroll.animateTo(myScroll.position.maxScrollExtent + 40,
                      duration: const Duration(seconds: 1),
                      curve: Curves.decelerate);
                },
                child: const Text('Add to List')),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
            child: ElevatedButton(
                onPressed: () {
                  List<bool> newSelected = [];
                  List<String> newLabels = [];
                  for (int i = 0; i < selected.length; i++) {
                    if (!selected[i]) {
                      newLabels.add(labels[i]);
                      newSelected.add(selected[i]);
                    }
                  }
                  selected = newSelected;
                  labels = newLabels;
                  setState(() {});
                },
                child: const Text('Delete Items')),
          )
        ],
      ),
    );
  }

  Widget checkListbuilder(List<String> labels) {
    return ListView.builder(
        controller: myScroll,
        padding: const EdgeInsets.all(10),
        itemCount: labels.length,
        itemBuilder: (BuildContext context, int index) {
          return CheckboxListTile(
            value: selected[index],
            title: Text(labels[index]),
            controlAffinity: ListTileControlAffinity.leading,
            tileColor: Colors.white,
            onChanged: (bool? value) {
              selected[index] = value!;
              setState(() {});
            },
          );
        });
  }
}
