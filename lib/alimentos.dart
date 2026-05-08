class Alimento {
  final String nombre;
  final String categoria;
  final int calorias;
  final double carbohidratos;
  final String indiceGlicemico;

  Alimento({
    required this.nombre,
    required this.categoria,
    required this.calorias,
    required this.carbohidratos,
    required this.indiceGlicemico,
  });
}

List<Alimento> alimentos = [

  // HELADOS 🍦
  Alimento(nombre: "Helado vainilla", categoria: "Dulces", calorias: 207, carbohidratos: 24, indiceGlicemico: "Alto"),
  Alimento(nombre: "Helado chocolate", categoria: "Dulces", calorias: 216, carbohidratos: 25, indiceGlicemico: "Alto"),
  Alimento(nombre: "Helado frutilla", categoria: "Dulces", calorias: 192, carbohidratos: 22, indiceGlicemico: "Alto"),

  // LÁCTEOS
  Alimento(nombre: "Quesillo", categoria: "Lácteos", calorias: 98, carbohidratos: 3.4, indiceGlicemico: "Bajo"),
  Alimento(nombre: "Queso Chanco", categoria: "Lácteos", calorias: 330, carbohidratos: 1.3, indiceGlicemico: "Bajo"),
  Alimento(nombre: "Queso Gouda", categoria: "Lácteos", calorias: 356, carbohidratos: 2.2, indiceGlicemico: "Bajo"),
  Alimento(nombre: "Queso Brie", categoria: "Lácteos", calorias: 334, carbohidratos: 0.5, indiceGlicemico: "Bajo"),
  Alimento(nombre: "Queso Parmesano", categoria: "Lácteos", calorias: 431, carbohidratos: 4.1, indiceGlicemico: "Bajo"),

  // CEREALES
  Alimento(nombre: "Quinoa", categoria: "Cereales", calorias: 120, carbohidratos: 21.3, indiceGlicemico: "Medio"),
  Alimento(nombre: "Cous cous", categoria: "Cereales", calorias: 112, carbohidratos: 23.2, indiceGlicemico: "Medio"),
  Alimento(nombre: "Burgol", categoria: "Cereales", calorias: 83, carbohidratos: 18.6, indiceGlicemico: "Bajo"),
  Alimento(nombre: "Pasta Orzo", categoria: "Cereales", calorias: 130, carbohidratos: 25, indiceGlicemico: "Medio"),

  // VERDURAS
  Alimento(nombre: "Betarraga", categoria: "Verduras", calorias: 43, carbohidratos: 10, indiceGlicemico: "Medio"),
  Alimento(nombre: "Zapallo", categoria: "Verduras", calorias: 26, carbohidratos: 7, indiceGlicemico: "Medio"),
  Alimento(nombre: "Zapallo italiano", categoria: "Verduras", calorias: 17, carbohidratos: 3.1, indiceGlicemico: "Bajo"),
  Alimento(nombre: "Zanahoria", categoria: "Verduras", calorias: 41, carbohidratos: 9.6, indiceGlicemico: "Medio"),
  Alimento(nombre: "Repollo", categoria: "Verduras", calorias: 25, carbohidratos: 6, indiceGlicemico: "Bajo"),
  Alimento(nombre: "Repollo morado", categoria: "Verduras", calorias: 31, carbohidratos: 7, indiceGlicemico: "Bajo"),
  Alimento(nombre: "Rúcula", categoria: "Verduras", calorias: 25, carbohidratos: 3.7, indiceGlicemico: "Bajo"),
  Alimento(nombre: "Berros", categoria: "Verduras", calorias: 11, carbohidratos: 1.3, indiceGlicemico: "Bajo"),

  // FRUTAS
  Alimento(nombre: "Chirimoya", categoria: "Frutas", calorias: 75, carbohidratos: 18, indiceGlicemico: "Medio"),
  Alimento(nombre: "Sandía", categoria: "Frutas", calorias: 30, carbohidratos: 8, indiceGlicemico: "Alto"),
  Alimento(nombre: "Melón", categoria: "Frutas", calorias: 34, carbohidratos: 8, indiceGlicemico: "Medio"),
  Alimento(nombre: "Mandarina", categoria: "Frutas", calorias: 53, carbohidratos: 13, indiceGlicemico: "Bajo"),
  Alimento(nombre: "Plátano", categoria: "Frutas", calorias: 89, carbohidratos: 23, indiceGlicemico: "Medio"),
  Alimento(nombre: "Piña", categoria: "Frutas", calorias: 50, carbohidratos: 13, indiceGlicemico: "Medio"),
  Alimento(nombre: "Durazno", categoria: "Frutas", calorias: 39, carbohidratos: 10, indiceGlicemico: "Bajo"),
  Alimento(nombre: "Mango", categoria: "Frutas", calorias: 60, carbohidratos: 15, indiceGlicemico: "Medio"),
  Alimento(nombre: "Maracuyá", categoria: "Frutas", calorias: 97, carbohidratos: 23, indiceGlicemico: "Medio"),

  // DULCES
  Alimento(nombre: "Manjar", categoria: "Dulces", calorias: 315, carbohidratos: 55, indiceGlicemico: "Alto"),
  Alimento(nombre: "Miel", categoria: "Dulces", calorias: 304, carbohidratos: 82, indiceGlicemico: "Alto"),
  Alimento(nombre: "Mermelada", categoria: "Dulces", calorias: 250, carbohidratos: 65, indiceGlicemico: "Alto"),

  // BEBIDAS
  Alimento(nombre: "Vino tinto", categoria: "Bebidas", calorias: 85, carbohidratos: 2.6, indiceGlicemico: "Bajo"),
  Alimento(nombre: "Vino blanco", categoria: "Bebidas", calorias: 82, carbohidratos: 2.6, indiceGlicemico: "Bajo"),

  // PROTEÍNAS
  Alimento(nombre: "Pavo", categoria: "Proteínas", calorias: 135, carbohidratos: 0, indiceGlicemico: "Bajo"),
  Alimento(nombre: "Ostiones", categoria: "Proteínas", calorias: 111, carbohidratos: 5.4, indiceGlicemico: "Bajo"),
  Alimento(nombre: "Jaiba", categoria: "Proteínas", calorias: 97, carbohidratos: 0, indiceGlicemico: "Bajo"),

  // GRASAS
  Alimento(nombre: "Aceite de coco", categoria: "Grasas", calorias: 862, carbohidratos: 0, indiceGlicemico: "Bajo"),
  Alimento(nombre: "Ghee", categoria: "Grasas", calorias: 900, carbohidratos: 0, indiceGlicemico: "Bajo"),
];