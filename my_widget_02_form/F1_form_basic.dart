import 'package:flutter/material.dart';

class FormBasicDemo extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _FormBasicDemoSate();
}

class _FormBasicDemoSate extends State<FormBasicDemo>{

  final _formKey = GlobalKey<FormState>();
  String? _name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Co Ban"),
        backgroundColor: Colors.green,
      ),

      backgroundColor: Colors.white,

      body: Padding(padding: EdgeInsets.all(16.8),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Ho Va Ten",
                    hintText: "Nhap Ho va Ten cua ban",
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value){
                    _name = value;
                  },
                ),

                SizedBox(height: 20,),
                Row(
                  children: [
                    ElevatedButton(onPressed: () {
                      if(_formKey.currentState!.validate()){
                        _formKey.currentState!.save();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Xin Chao $_name"))
                        );
                      }
                    }, child: Text("Submit")),
                    SizedBox(width: 20,),
                    ElevatedButton(onPressed: () {
                      _formKey.currentState!.reset();
                      setState(() {
                        _name = null;
                      });
                    }, child: Text("Reset")),
                  ],
                )
              ],
            )
        ),
      ),
    );
  }
}