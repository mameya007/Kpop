import 'package:flutter/material.dart';
import 'utils.dart';





class GIdol extends StatefulWidget{
  final Band currentBand;
  final bool random;
  GIdol({Key key,@required this.currentBand,@required this.random}) : super(key:key);
  @override
  State createState()=> new GIdolState(currentBand: currentBand,random: random);

}
class GIdolState extends State<GIdol>{
  bool random;
  Idol currentIdol;
  Band currentBand;
  GIdolState({Key key , @required this.currentBand,@required this.random});
  int _chances;
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    new Container(
    child:new Text("Welcome"),
//      child: new Image.asset(currentBand),
    );
    // TODO: implement build
  }

}