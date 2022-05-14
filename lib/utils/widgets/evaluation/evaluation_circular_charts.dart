import 'package:flutter/cupertino.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class EvaluationCircularCharts extends StatefulWidget {

  final List<double> data;

  const EvaluationCircularCharts({
    required this.data,
    Key? key
  }) : super(key: key);

  @override
  _EvaluationCircularChartsState createState() => _EvaluationCircularChartsState();
}

class _EvaluationCircularChartsState extends State<EvaluationCircularCharts> {

  List<String> dataLabels = ['Proteina', 'Grasa', 'Humedad', 'Fibra', 'Calcio', 'Fosforo'];

  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: screenSize.width/1.5,
      child: Wrap(
        spacing: 2,
        runSpacing: 2,
        children: List.generate(6, (index){
          return Column(
            children: [
              SizedBox(
                  height: screenSize.width/5,
                  width: screenSize.width/5,
                  child:  SfRadialGauge(
                      enableLoadingAnimation: true,
                      animationDuration: 3000,
                      axes: <RadialAxis>[
                    RadialAxis(
                        showLabels: false,
                        showTicks: false,
                        startAngle: 270,
                        endAngle: 270,
                        radiusFactor: 0.8,
                        axisLineStyle: const AxisLineStyle(
                          thickness: 0.2,
                          color: Color.fromARGB(30, 0, 169, 181),
                          thicknessUnit: GaugeSizeUnit.factor,
                        ),
                        pointers: <GaugePointer>[
                          RangePointer(
                              value: widget.data[index],
                              width: 0.2,
                              sizeUnit: GaugeSizeUnit.factor,
                              enableAnimation: true,
                              animationDuration: 75,
                              animationType: AnimationType.linear,
                              gradient: chartsStyles[index]),
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                              positionFactor: 0.1,
                              widget: Text(widget.data[index].toStringAsFixed(1) + '%'))
                        ]),
                  ])),
              Text(dataLabels[index], style: TextStyle(fontSize: 12),)
            ],
          );
        }),
      ),
    );
  }
}
