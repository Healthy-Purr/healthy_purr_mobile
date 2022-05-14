import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthy_purr_mobile_app/view_models/view_model.dart';
import 'package:provider/provider.dart';

class CatCountContainer extends StatelessWidget {
  const CatCountContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final List<CatViewModel> numberOfCats = [];

    final catList = Provider.of<CatListViewModel>(context, listen: false).getCats();

    for(var enabledCat in catList) {
      if(enabledCat.status == true) {
        numberOfCats.add(enabledCat);
      }
    }

    return Row(
      children: [
        Image.asset('assets/images/cat_siloutte.png', height: 60,),
        const SizedBox(width: 20,),
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(numberOfCats.length.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.black)),
              const Text('Gatos', style: TextStyle(fontSize: 16, color: Colors.black))
            ],
          ),
        ),
      ],
    );
  }
}
