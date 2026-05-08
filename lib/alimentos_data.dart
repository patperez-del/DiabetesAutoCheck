final List<Map<String, dynamic>> alimentosBase = [
  // Frutas
  {"nombre": "Manzana", "categoria": "Fruta", "cal": 52, "carb": 14, "ig": 40},
  {"nombre": "Plátano", "categoria": "Fruta", "cal": 96, "carb": 27, "ig": 60},
  {"nombre": "Naranja", "categoria": "Fruta", "cal": 47, "carb": 12, "ig": 43},
  {"nombre": "Frutillas", "categoria": "Fruta", "cal": 32, "carb": 8, "ig": 25},
  {"nombre": "Uva", "categoria": "Fruta", "cal": 69, "carb": 18, "ig": 53},
  {"nombre": "Sandía", "categoria": "Fruta", "cal": 30, "carb": 8, "ig": 72},

  // Verduras y tubérculos
  {"nombre": "Lechuga", "categoria": "Verdura", "cal": 15, "carb": 2, "ig": 10},
  {"nombre": "Tomate", "categoria": "Verdura", "cal": 18, "carb": 4, "ig": 15},
  {"nombre": "Brócoli", "categoria": "Verdura", "cal": 35, "carb": 7, "ig": 15},
  {"nombre": "Zanahoria", "categoria": "Verdura", "cal": 41, "carb": 10, "ig": 35},
  {"nombre": "Papa cocida", "categoria": "Verdura", "cal": 87, "carb": 20, "ig": 78},
  {"nombre": "Papas fritas", "categoria": "Comida rápida", "cal": 312, "carb": 41, "ig": 75},
  {"nombre": "Camote", "categoria": "Verdura", "cal": 86, "carb": 20, "ig": 54},

  // Cereales
  {"nombre": "Avena", "categoria": "Cereal", "cal": 68, "carb": 12, "ig": 55},
  {"nombre": "Arroz blanco", "categoria": "Cereal", "cal": 130, "carb": 28, "ig": 73},
  {"nombre": "Arroz integral", "categoria": "Cereal", "cal": 110, "carb": 23, "ig": 50},
  {"nombre": "Fideos", "categoria": "Cereal", "cal": 131, "carb": 25, "ig": 55},
  {"nombre": "Quínoa", "categoria": "Cereal", "cal": 120, "carb": 21, "ig": 53},
  {"nombre": "Cereal azucarado", "categoria": "Cereal", "cal": 380, "carb": 84, "ig": 75},

  // Panes
  {"nombre": "Pan integral", "categoria": "Pan", "cal": 69, "carb": 12, "ig": 50},
  {"nombre": "Pan blanco", "categoria": "Pan", "cal": 75, "carb": 14, "ig": 70},
  {"nombre": "Marraqueta", "categoria": "Pan", "cal": 140, "carb": 28, "ig": 70},
  {"nombre": "Hallulla", "categoria": "Pan", "cal": 180, "carb": 30, "ig": 72},
  {"nombre": "Pan amasado", "categoria": "Pan", "cal": 220, "carb": 35, "ig": 75},
  {"nombre": "Pan con palta", "categoria": "Pan", "cal": 300, "carb": 38, "ig": 60},
  {"nombre": "Pan con queso", "categoria": "Pan", "cal": 330, "carb": 32, "ig": 60},
  {"nombre": "Pan con mantequilla", "categoria": "Pan", "cal": 320, "carb": 32, "ig": 65},
  {"nombre": "Pan con mermelada", "categoria": "Pan", "cal": 340, "carb": 55, "ig": 75},

  // Legumbres
  {"nombre": "Lentejas", "categoria": "Legumbre", "cal": 116, "carb": 20, "ig": 30},
  {"nombre": "Garbanzos", "categoria": "Legumbre", "cal": 164, "carb": 27, "ig": 28},
  {"nombre": "Porotos", "categoria": "Legumbre", "cal": 127, "carb": 23, "ig": 35},

  // Proteínas
  {"nombre": "Pollo", "categoria": "Proteína", "cal": 165, "carb": 0, "ig": 0},
  {"nombre": "Carne magra", "categoria": "Proteína", "cal": 250, "carb": 0, "ig": 0},
  {"nombre": "Pescado", "categoria": "Proteína", "cal": 206, "carb": 0, "ig": 0},
  {"nombre": "Atún", "categoria": "Proteína", "cal": 132, "carb": 0, "ig": 0},
  {"nombre": "Huevo", "categoria": "Proteína", "cal": 155, "carb": 1, "ig": 0},

  // Lácteos y grasas
  {"nombre": "Leche", "categoria": "Lácteo", "cal": 42, "carb": 5, "ig": 30},
  {"nombre": "Yogur natural", "categoria": "Lácteo", "cal": 59, "carb": 3, "ig": 35},
  {"nombre": "Yogur endulzado", "categoria": "Lácteo", "cal": 95, "carb": 16, "ig": 50},
  {"nombre": "Queso", "categoria": "Lácteo", "cal": 350, "carb": 2, "ig": 0},
  {"nombre": "Quesillo", "categoria": "Lácteo", "cal": 98, "carb": 3, "ig": 25},
  {"nombre": "Mantequilla", "categoria": "Grasa saludable", "cal": 717, "carb": 0, "ig": 0},
  {"nombre": "Palta", "categoria": "Grasa saludable", "cal": 160, "carb": 9, "ig": 10},
  {"nombre": "Aceite de oliva", "categoria": "Grasa saludable", "cal": 119, "carb": 0, "ig": 0},
  {"nombre": "Nueces", "categoria": "Grasa saludable", "cal": 654, "carb": 14, "ig": 15},
  {"nombre": "Almendras", "categoria": "Grasa saludable", "cal": 579, "carb": 22, "ig": 15},

  // Bebidas y café
  {"nombre": "Agua", "categoria": "Bebida", "cal": 0, "carb": 0, "ig": 0},
  {"nombre": "Café solo", "categoria": "Bebida", "cal": 2, "carb": 0, "ig": 0},
  {"nombre": "Café con leche", "categoria": "Bebida", "cal": 60, "carb": 6, "ig": 30},
  {"nombre": "Cappuccino", "categoria": "Bebida", "cal": 120, "carb": 12, "ig": 45},
  {"nombre": "Latte", "categoria": "Bebida", "cal": 150, "carb": 15, "ig": 45},
  {"nombre": "Chocolate con leche", "categoria": "Bebida", "cal": 190, "carb": 30, "ig": 60},
  {"nombre": "Jugo natural", "categoria": "Bebida", "cal": 45, "carb": 11, "ig": 50},
  {"nombre": "Bebida azucarada", "categoria": "Bebida", "cal": 42, "carb": 11, "ig": 65},

  // Dulces
  {"nombre": "Chocolate", "categoria": "Dulce", "cal": 546, "carb": 61, "ig": 45},
  {"nombre": "Sahne-Nuss", "categoria": "Dulce", "cal": 540, "carb": 55, "ig": 50},
  {"nombre": "Galletas dulces", "categoria": "Dulce", "cal": 480, "carb": 70, "ig": 70},
  {"nombre": "Torta", "categoria": "Dulce", "cal": 350, "carb": 45, "ig": 65},
  {"nombre": "Helado", "categoria": "Dulce", "cal": 207, "carb": 24, "ig": 61},

  // Comida chilena
  {"nombre": "Empanada de pino", "categoria": "Comida chilena", "cal": 450, "carb": 45, "ig": 65},
  {"nombre": "Humita", "categoria": "Comida chilena", "cal": 250, "carb": 40, "ig": 60},
  {"nombre": "Pastel de choclo", "categoria": "Comida chilena", "cal": 420, "carb": 55, "ig": 65},
  {"nombre": "Cazuela", "categoria": "Comida chilena", "cal": 350, "carb": 35, "ig": 50},
  {"nombre": "Completo", "categoria": "Comida chilena", "cal": 450, "carb": 45, "ig": 70},
  {"nombre": "Sopaipilla", "categoria": "Comida chilena", "cal": 180, "carb": 25, "ig": 75},
  {"nombre": "Churrasco italiano", "categoria": "Comida chilena", "cal": 650, "carb": 55, "ig": 70},

  // Comida rápida
  {"nombre": "Pizza", "categoria": "Comida rápida", "cal": 285, "carb": 36, "ig": 60},
  {"nombre": "Tacos", "categoria": "Comida rápida", "cal": 230, "carb": 22, "ig": 55},
  {"nombre": "Hamburguesa", "categoria": "Comida rápida", "cal": 500, "carb": 40, "ig": 65},
  {"nombre": "Hamburguesa tipo McDonald’s", "categoria": "Comida rápida", "cal": 520, "carb": 45, "ig": 70},
  {"nombre": "Nuggets", "categoria": "Comida rápida", "cal": 300, "carb": 16, "ig": 50},// Extras importantes
  {"nombre": "Azúcar", "categoria": "Dulce", "cal": 387, "carb": 100, "ig": 65},
  {"nombre": "Stevia", "categoria": "Dulce", "cal": 0, "carb": 0, "ig": 0},
  {"nombre": "Té", "categoria": "Bebida", "cal": 2, "carb": 0, "ig": 0},
  {"nombre": "Té con azúcar", "categoria": "Bebida", "cal": 30, "carb": 8, "ig": 65},
  {"nombre": "Mermelada", "categoria": "Dulce", "cal": 250, "carb": 65, "ig": 65},
  {"nombre": "Manjar", "categoria": "Dulce", "cal": 320, "carb": 55, "ig": 70},
  {"nombre": "Bebida zero", "categoria": "Bebida", "cal": 1, "carb": 0, "ig": 0},
  {"nombre": "Jugo en caja", "categoria": "Bebida", "cal": 45, "carb": 11, "ig": 60},
  {"nombre": "Galletas saladas", "categoria": "Cereal", "cal": 430, "carb": 70, "ig": 70},
  {"nombre": "Pan con huevo", "categoria": "Pan", "cal": 350, "carb": 30, "ig": 55},
  {"nombre": "Pan con jamón", "categoria": "Pan", "cal": 320, "carb": 30, "ig": 55},

  {
    "nombre": "Helado vainilla",
    "categoria": "Dulce",
    "cal": 207,
    "carb": 24,
    "ig": 60,
  },
  {
    "nombre": "Helado chocolate",
    "categoria": "Dulce",
    "cal": 216,
    "carb": 25,
    "ig": 60,
  },
  {
    "nombre": "Helado frutilla",
    "categoria": "Dulce",
    "cal": 192,
    "carb": 22,
    "ig": 60,
  },

// LÁCTEOS
  {
    "nombre": "Quesillo",
    "categoria": "Lácteo",
    "cal": 98,
    "carb": 3.4,
    "ig": 30,
  },
  {
    "nombre": "Queso Chanco",
    "categoria": "Lácteo",
    "cal": 330,
    "carb": 1.3,
    "ig": 0,
  },
  {
    "nombre": "Queso Gouda",
    "categoria": "Lácteo",
    "cal": 356,
    "carb": 2.2,
    "ig": 0,
  },
  {
    "nombre": "Queso Brie",
    "categoria": "Lácteo",
    "cal": 334,
    "carb": 0.5,
    "ig": 0,
  },
  {
    "nombre": "Queso Parmesano",
    "categoria": "Lácteo",
    "cal": 431,
    "carb": 4.1,
    "ig": 0,
  },

// CEREALES
  {
    "nombre": "Quinoa",
    "categoria": "Cereal",
    "cal": 120,
    "carb": 21.3,
    "ig": 53,
  },
  {
    "nombre": "Cous cous",
    "categoria": "Cereal",
    "cal": 112,
    "carb": 23.2,
    "ig": 65,
  },
  {
    "nombre": "Burgol",
    "categoria": "Cereal",
    "cal": 83,
    "carb": 18.6,
    "ig": 48,
  },
  {
    "nombre": "Pasta Orzo",
    "categoria": "Cereal",
    "cal": 130,
    "carb": 25,
    "ig": 60,
  },

// VERDURAS
  {
    "nombre": "Betarraga",
    "categoria": "Verdura",
    "cal": 43,
    "carb": 10,
    "ig": 64,
  },
  {
    "nombre": "Zapallo",
    "categoria": "Verdura",
    "cal": 26,
    "carb": 7,
    "ig": 75,
  },
  {
    "nombre": "Zapallo italiano",
    "categoria": "Verdura",
    "cal": 17,
    "carb": 3.1,
    "ig": 15,
  },
  {
    "nombre": "Zanahoria",
    "categoria": "Verdura",
    "cal": 41,
    "carb": 9.6,
    "ig": 70,
  },
  {
    "nombre": "Repollo",
    "categoria": "Verdura",
    "cal": 25,
    "carb": 6,
    "ig": 10,
  },
  {
    "nombre": "Repollo morado",
    "categoria": "Verdura",
    "cal": 31,
    "carb": 7,
    "ig": 10,
  },
  {
    "nombre": "Rúcula",
    "categoria": "Verdura",
    "cal": 25,
    "carb": 3.7,
    "ig": 15,
  },
  {
    "nombre": "Berros",
    "categoria": "Verdura",
    "cal": 11,
    "carb": 1.3,
    "ig": 10,
  },

// FRUTAS
  {
    "nombre": "Chirimoya",
    "categoria": "Fruta",
    "cal": 75,
    "carb": 18,
    "ig": 54,
  },
  {
    "nombre": "Sandía",
    "categoria": "Fruta",
    "cal": 30,
    "carb": 8,
    "ig": 76,
  },
  {
    "nombre": "Melón",
    "categoria": "Fruta",
    "cal": 34,
    "carb": 8,
    "ig": 65,
  },
  {
    "nombre": "Mandarina",
    "categoria": "Fruta",
    "cal": 53,
    "carb": 13,
    "ig": 30,
  },
  {
    "nombre": "Plátano",
    "categoria": "Fruta",
    "cal": 89,
    "carb": 23,
    "ig": 51,
  },
  {
    "nombre": "Piña",
    "categoria": "Fruta",
    "cal": 50,
    "carb": 13,
    "ig": 59,
  },
  {
    "nombre": "Durazno",
    "categoria": "Fruta",
    "cal": 39,
    "carb": 10,
    "ig": 42,
  },
  {
    "nombre": "Mango",
    "categoria": "Fruta",
    "cal": 60,
    "carb": 15,
    "ig": 60,
  },
  {
    "nombre": "Maracuyá",
    "categoria": "Fruta",
    "cal": 97,
    "carb": 23,
    "ig": 50,
  },

// DULCES
  {
    "nombre": "Manjar",
    "categoria": "Dulce",
    "cal": 315,
    "carb": 55,
    "ig": 70,
  },
  {
    "nombre": "Miel",
    "categoria": "Dulce",
    "cal": 304,
    "carb": 82,
    "ig": 85,
  },
  {
    "nombre": "Mermelada",
    "categoria": "Dulce",
    "cal": 250,
    "carb": 65,
    "ig": 65,
  },

// BEBIDAS
  {
    "nombre": "Vino tinto",
    "categoria": "Bebida",
    "cal": 85,
    "carb": 2.6,
    "ig": 0,
  },
  {
    "nombre": "Vino blanco",
    "categoria": "Bebida",
    "cal": 82,
    "carb": 2.6,
    "ig": 0,
  },

// PROTEÍNAS
  {
    "nombre": "Pavo",
    "categoria": "Proteína",
    "cal": 135,
    "carb": 0,
    "ig": 0,
  },
  {
    "nombre": "Ostiones",
    "categoria": "Proteína",
    "cal": 111,
    "carb": 5.4,
    "ig": 0,
  },
  {
    "nombre": "Jaiba",
    "categoria": "Proteína",
    "cal": 97,
    "carb": 0,
    "ig": 0,
  },

// GRASAS
  {
    "nombre": "Aceite de coco",
    "categoria": "Grasa saludable",
    "cal": 862,
    "carb": 0,
    "ig": 0,
  },
  {
    "nombre": "Ghee",
    "categoria": "Grasa saludable",
    "cal": 900,
    "carb": 0,
    "ig": 0,
  },
];