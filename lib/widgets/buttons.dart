import 'package:flutter/material.dart';
class Buttons extends StatelessWidget {
  final String title;
  final VoidCallback onpressed;
  final Color color;
  final double l,t,r,b;
  const Buttons({Key? key,required this.title,required this.onpressed,required this.color, this.l=0, this.t=0, this.r=0, this.b=0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.fromLTRB(l, t, r, b),
      child: Material(
        elevation: 5,
        borderRadius:BorderRadius.circular(20) ,
        color: Colors.blue.shade900,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient:const LinearGradient(
              colors: [Colors.purple, Colors.blue],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: MaterialButton(onPressed:onpressed ,
            height: 50,
            minWidth: 200,
            child: Text(title,style: TextStyle(

              color: color,
            ),),
          ),
        ),
      ),
    );
  }
}
