#include "funciones.hpp"

int main() {
  char ***cursos, ***alumnos_nom_mod;
  double *cursos_cred, escalas[5];
  int *alumnos_cod, **almunos;

  cargarCursosYEscalas(cursos, cursos_cred, escalas, "Cursos.csv",
                       "Escalas.csv");

  pruebaDeCargaDeCursos(cursos, cursos_cred, "PruebaCursos.txt");
}
