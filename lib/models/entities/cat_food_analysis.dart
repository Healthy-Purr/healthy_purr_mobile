class CatFoodAnalysis {
  final Analysis? analysis;
  final Ingredient? ingredients;
  final Taurine? taurine;
  double result = 0.0;

  CatFoodAnalysis({
    this.analysis,
    this.ingredients,
    this.taurine
  });

  CatFoodAnalysis.fromCopy(this.analysis, this.ingredients, this.taurine);

  setResult(double newValue){
    result = newValue;
  }

  factory CatFoodAnalysis.fromJson(Map<String, dynamic> catJson) {
    return CatFoodAnalysis(
        analysis: Analysis.fromJson(catJson['Analisis']),
        ingredients: Ingredient.fromJson(catJson['Ingredientes']),
        taurine: Taurine.fromJson(catJson['Taurina'])
    );
  }

}

class Analysis {
  final double? calcium;
  final double? fiber;
  final double? phosphorus;
  final double? fat;
  final double? moisture;
  final double? protein;
  final double? ash;
  final double? carbohydrates;

  Analysis({
    this.calcium,
    this.fiber,
    this.phosphorus,
    this.fat,
    this.moisture,
    this.protein,
    this.ash,
    this.carbohydrates
  });

  Analysis.fromCopy(
    this.calcium,
    this.fiber,
    this.phosphorus,
    this.fat,
    this.moisture,
    this.protein,
    this.ash,
    this.carbohydrates
  );

  factory Analysis.fromJson(Map<String, dynamic> catJson) {
    return Analysis(
        calcium: catJson['Calcio'],
        fiber: catJson['Fibra'],
        phosphorus: catJson['Fosforo'],
        fat: catJson['Grasa'],
        moisture: catJson['Humedad'],
        protein: catJson['Proteina'],
        ash: catJson['Ceniza'],
        carbohydrates: catJson['Carbohidratos']
    );
  }

}

class Ingredient {
  final double? meat;
  final double? pig;
  final double? colorant;
  final double? egg;
  final double? milk;
  final double? fish;
  final double? chicken;
  final double? cheese;
  final double? soy;

  Ingredient({
    this.meat,
    this.pig,
    this.colorant,
    this.egg,
    this.milk,
    this.fish,
    this.chicken,
    this.cheese,
    this.soy
  });

  Ingredient.fromCopy(
    this.meat,
    this.pig,
    this.colorant,
    this.egg,
    this.milk,
    this.fish,
    this.chicken,
    this.cheese,
    this.soy
  );

  factory Ingredient.fromJson(Map<String, dynamic> catJson) {
    return Ingredient(
        meat: catJson['Carne'],
        pig: catJson['Cerdo'],
        colorant: catJson['Colorante'],
        egg: catJson['Huevo'],
        milk: catJson['Leche'],
        fish: catJson['Pescado'],
        chicken: catJson['Pollo'],
        cheese: catJson['Queso'],
        soy: catJson['Soja']
    );
  }

}

class Taurine {
  final double? taurine;

  Taurine({
    this.taurine,
  });

  Taurine.fromCopy(
    this.taurine,
  );

  factory Taurine.fromJson(Map<String, dynamic> catJson) {
    return Taurine(
        taurine: catJson['Taurina']
    );
  }

}