List<Map<String,String>> generarMenu(int calorias){

  if(calorias < 1600){

    return [
      {
        "desayuno":"Yogur natural + avena",
        "almuerzo":"Pollo + ensalada + quinoa",
        "cena":"Tortilla espinaca"
      },
      {
        "desayuno":"Pan integral + palta",
        "almuerzo":"Pescado + arroz integral",
        "cena":"Ensalada atún"
      }
    ];

  }

  if(calorias < 2200){

    return [
      {
        "desayuno":"Yogur + fruta",
        "almuerzo":"Pollo + quinoa + ensalada",
        "cena":"Tortilla verduras"
      },
      {
        "desayuno":"Avena",
        "almuerzo":"Lentejas",
        "cena":"Ensalada pollo"
      }
    ];

  }

  return [
    {
      "desayuno":"Avena + yogur",
      "almuerzo":"Carne + arroz integral",
      "cena":"Ensalada atún"
    }
  ];

}