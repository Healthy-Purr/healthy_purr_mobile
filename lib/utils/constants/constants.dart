import 'package:flutter/material.dart';

//-------------URL-------------//

const String url = "https://healthypurr.herokuapp.com/";

const String evaluationUrl = "https://healthy-purr-evaluation.herokuapp.com/evaluation";

//-------------COLORS-------------//

const Color complementaryColor = Color(0xFFE6BEA4);

const Color secondaryColor = Color(0xFFF6EED9);

const Color primaryColor = Color(0xFFFFD28E);

const Color darkColor = Color(0xFF48302E);

const Color catInformationContainerColor = Color(0xFFFFE2B6);

const Color diseasesContainerColor = Color(0xFFFC5C9C);

const Color allergiesContainerColor = Color(0xFFFFE2B6);

const Color updateCatImageButtonColor = Color(0xFFFFD28E);

const Color updateCatInformationButtonColor = Color(0xFFFFB554);

const Color cancelButtonColor = Color(0xFFE3575D);

const Color evaluationOption = Color(0xFFFC5155);

const Color addCatScheduleButtonColor =  Color(0xFF59E4C6);

//-------------ASSETS-------------//

NetworkImage defaultCatImage = const NetworkImage("https://w7.pngwing.com/pngs/270/98/png-transparent-cat-kitten-balloon-birthday-graphy-cats-mammal-hat-cat-like-mammal.png");

const String topRightDecoration = 'assets/images/top-right_decoration.png';

const String healthyPurrLogo = 'assets/images/safety_purr_logocolor.png';

const String pawAsset = 'assets/images/paw.png';

const String photoInstructionImageAsset = 'assets/images/take_photo_example.png';

const String selectOptionInstructionImageAsset = 'assets/images/select_option.png';

//-------------ALERT DIALOG CONTENT-------------//

//--------DELETE CAT--------//

const String deleteCatAlertDialogTitle = '¿Seguro que deseas realizar esta acción?';

const String deleteCatAlertDialogContent = 'Esta acción no podrá revertirse. ¿Estás de acuerdo?';

const String deleteCatAlertDialogConfirmAction = 'Confirmar';

const String deleteCatAlertDialogDismissAction = 'Volver';

//--------CAMERA ALERT DIALOG--------//

const String cameraInstructionAlertDialogTitle = 'Tome una foto a los ingredientes y análisis garantizado de la comida para gatos';

const String selectOptionAlertDialogTitle = '¿Desea continuar con la evaluación o prefiere realizar una comparación entre más comidas?';

const String cameraInstructionDoNotShowAgain = 'No volver a mostrar';

const String cameraInstructionConfirmAction = 'Continuar';

const String selectOptionCompareAction = 'Comparar';

const String selectOptionEvaluateAction = 'Evaluar';

//--------LOGOUT--------//

const String logoutAlertDialogTitle = '¿Seguro que deseas realizar esta acción?';

const String logoutAlertDialogContent = 'Al confirmar cerrarás sesión. Para poder utilizar los servicios de Healthy Purr, deberás iniciar sesión nuevamente.';

const String logoutAlertDialogConfirmAction = 'Cerrar sesión';

const String logoutAlertDialogDismissAction = 'Volver';

//--------EVALUATION--------//
const String evaluationSelectionCatMessage = 'Seleccione un gato de la lista (ten en cuenta que esta opción evaluará el alimento solo para el gato que hayas seleccionado, por lo que si quieres realizar una evaluación para todos tus gatitos, te recomendamos elegir la opción "Realizar Evaluación General")';