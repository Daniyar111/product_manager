import 'package:flutter/material.dart';

class ImageInput extends StatefulWidget {

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {


  void _openImagePicker(BuildContext context){
    
    showModalBottomSheet(context: context, builder: (BuildContext context){

      return Container(
        height: 150,
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Text(
              'Pick an Image',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10,),
            FlatButton(
              textColor: Theme.of(context).primaryColor,
              child: Text('Use Camera'),
              onPressed: (){},
            ),
            FlatButton(
              textColor: Theme.of(context).primaryColor,
              child: Text('Use Gallery'),
              onPressed: (){},
            ),
          ],
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {

    final buttonColor = Theme.of(context).accentColor;

    return Column(
      children: <Widget>[
        OutlineButton(
          borderSide: BorderSide(
            color: buttonColor,
            width: 2
          ),
          onPressed: (){
            _openImagePicker(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.camera_alt, color: buttonColor,),
              SizedBox(width: 5,),
              Text(
                'Add Image',
                style: TextStyle(color: buttonColor),
              )
            ],
          ),
        )
      ],
    );
  }
}
