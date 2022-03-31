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

    return Container(
      height: 47.5, width: 120,
      margin: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const FaIcon(FontAwesomeIcons.cat, size: 40),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(numberOfCats.length.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
              const Text('Gatos', style: TextStyle(fontSize: 12))
            ],
          )
        ],
      ),
    );
  }
}
