import 'package:flutter/cupertino.dart';
import 'package:healthy_purr_mobile_app/utils/widgets/evaluation/evaluation_list.dart';

class EvaluationRecordView extends StatefulWidget {
  const EvaluationRecordView({Key? key}) : super(key: key);

  @override
  State<EvaluationRecordView> createState() => _EvaluationRecordViewState();
}

class _EvaluationRecordViewState extends State<EvaluationRecordView> {

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      height: screenSize.height,
      width: screenSize.width,
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Historial',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Stack(
              children: const [
                EvaluationList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}