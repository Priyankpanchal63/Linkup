import 'package:flutter/material.dart';
import 'package:linkup/providers/user_provider.dart';
import 'package:linkup/utils/gloable_variable.dart';
import 'package:provider/provider.dart';

class ResponsiveLayot extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayot({super.key,
    required this.mobileScreenLayout,
    required this.webScreenLayout});

  @override
  State<ResponsiveLayot> createState() => _ResponsiveLayotState();
}

class _ResponsiveLayotState extends State<ResponsiveLayot> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }
  addData()async{
    UserProvider _userprovider=Provider.of<UserProvider>(context,listen: false);
    await _userprovider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constrains){
      if(constrains.maxWidth>webScreenSize){
        return widget.webScreenLayout;
      }
      return widget.mobileScreenLayout;
    });
  }
}
