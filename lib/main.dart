import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy_purr_mobile_app/providers/provider.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';
import 'package:healthy_purr_mobile_app/view_models/camera_view_models/camera_view_model.dart';
import 'package:healthy_purr_mobile_app/view_models/evaluation_view_models/evaluation_view_model.dart';
import 'package:healthy_purr_mobile_app/views/view.dart';
import 'package:provider/provider.dart';
import 'package:healthy_purr_mobile_app/view_models/view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //ListViewModels
        Provider(create: (context) => CatListViewModel()),
        Provider(create: (context) => AllergyListViewModel()),
        Provider(create: (context) => DiseaseListViewModel()),
        Provider(create: (context) => EvaluationViewModel()),
        ChangeNotifierProvider(create: (context) => CameraViewModel()),
        //Provider(create: (context) => UserViewModel()),
        //Services
        ChangeNotifierProvider(create: (context) => UserService()),
        ChangeNotifierProvider(create: (context) => CatService()),
        ChangeNotifierProvider(create: (context) => HeadersService()),
        ChangeNotifierProvider(create: (context) => DiseaseService()),
        ChangeNotifierProvider(create: (context) => AllergyService()),
        //Providers
        ChangeNotifierProvider(create: (context) => BottomNavigationBarProvider()),
        ChangeNotifierProvider(create: (context) => RegisterProvider())
      ],
      child: MaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.comfortaaTextTheme(Theme.of(context).textTheme)),
        home: const AuthenticationView(),
      ),
    );
  }
}