import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rebooked_app/provider/product_provider.dart';

class AttributeTabScreen extends StatefulWidget {
  const AttributeTabScreen({super.key});

  @override
  State<AttributeTabScreen> createState() => _AttributeTabScreenState();
}

class _AttributeTabScreenState extends State<AttributeTabScreen> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  bool _entered = false;
  final TextEditingController _printController = TextEditingController();

  List<String> _yearList = [];

  bool _isSave = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final ProductProvider _productProvider = Provider.of<ProductProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextFormField(
            validator: ((value) {
                  if(value!.isEmpty){
                    return "Enter Publisher's detail";
                  }else{
                    return null;
                  }
                }),
            onChanged: (value) {
              _productProvider.getFormData(publisherName: value);

            },
            decoration: InputDecoration(
              labelText: 'Publisher',
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Container(
                  width: 100,
                  child: TextFormField(
                    controller: _printController,
                    onChanged: (value) {
                      setState(() {
                        _entered = true;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Print year',
                    ),
                  ),
                )
              ),
              _entered == true ? 
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow.shade800,
                ),
                onPressed:() {
                  setState(() {
                    _yearList.add(_printController.text);
                    _printController.clear();
                  });
                  print(_yearList);
                },
                child: Text("Add"),
              ): Text(""),
            ],
          ),
          if(!_yearList.isEmpty)
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _yearList.length,
                  itemBuilder:(context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            _yearList.removeAt(index);
                            _productProvider.getFormData(yearList: _yearList);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade800,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _yearList[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
              
                ),
              ),
            ),

            if(!_yearList.isEmpty)
              ElevatedButton(
                onPressed: (){
                  _productProvider.getFormData(yearList: _yearList);
                  setState(() {
                    _isSave = true;
                  });
                }, 
                child: Text(
                  _isSave ? "Saved": "Save",
                  style:  TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),

              )
        ],
      ),
    );
  }
}