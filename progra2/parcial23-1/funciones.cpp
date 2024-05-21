#include "funciones.hpp"

#include <cstring>
#include <iomanip>
using namespace std;
#define INCREMENTO 5

void cargarCursosYEscalas(char ***&cursos, double *&cursos_cred,
                          double *escalas, const char *nomCursos,
                          const char *nomEscala) {
  ifstream archCursos(nomCursos, ios ::in);
  if (!archCursos.is_open()) {
    cout << "Error al abrir " << nomCursos << endl;
    exit(1);
  }

  ifstream archCEscala(nomEscala, ios ::in);
  if (!archCEscala.is_open()) {
    cout << "Error al abrir " << nomEscala << endl;
    exit(1);
  }

  int cant_actual_cursos = 0, cant_total_cursos = 0;
  cursos = new char **[INCREMENTO] {};
  cursos_cred = new double[INCREMENTO]{};

  char *codigo, *nombre, *profesor, car;
  double creditos;
  int dni;

  while (1) {
    codigo = leerExacto(archCursos);
    if (codigo == nullptr) break;
    nombre = leerExacto(archCursos);
    archCursos >> creditos >> car >> dni >> car;
    profesor = leerNombre(archCursos);
    asignarCursos(cursos, cursos_cred, cant_actual_cursos, cant_total_cursos,
                  codigo, nombre, creditos, profesor);
    cant_actual_cursos++;
  }

  char c;
  double valor_credito;
  while (1) {
    archCEscala >> c;
    if (archCEscala.eof()) break;
    archCEscala >> c;
    int pos = int(c - '0' - 1);
    archCEscala >> c >> valor_credito;
    archCEscala.get();
    escalas[pos] = valor_credito;
  }
}

char *leerExacto(ifstream &arch) {
  char *dato, buffer[200]{};
  arch.getline(buffer, 200, ',');
  if (arch.eof()) return nullptr;
  dato = new char[strlen(buffer) + 1]{};
  strcpy(dato, buffer);
  return dato;
}

char *leerNombre(ifstream &arch) {
  char *dato, buffer[200]{};
  arch.getline(buffer, 200, '\r');
  dato = new char[strlen(buffer) + 1]{};
  strcpy(dato, buffer);
  return dato;
}

void asignarCursos(char ***&cursos, double *&cursos_cred,
                   int cant_actual_cursos, int &cant_total_cursos, char *codigo,
                   char *nombre, double creditos, char *profesor) {
  if (cant_total_cursos == cant_actual_cursos) {
    cant_total_cursos += INCREMENTO;
    char ***auxCursos = new char **[cant_total_cursos] {};
    double *auxCursosCred = new double[cant_total_cursos]{};
    for (int i = 0; i < cant_actual_cursos; i++) {
      auxCursos[i] = cursos[i];
      auxCursosCred[i] = cursos_cred[i];
    }
    delete cursos_cred;
    delete cursos;
    cursos = auxCursos;
    cursos_cred = auxCursosCred;
  }

  cursos[cant_actual_cursos] = asignarCursosSimple(codigo, nombre, profesor);
  cursos_cred[cant_actual_cursos] = creditos;
}

char **asignarCursosSimple(char *codigo, char *nombre, char *profesor) {
  char **dato = new char *[3]{};
  dato[0] = codigo;
  dato[1] = nombre;
  dato[2] = profesor;
  return dato;
}

void pruebaDeCargaDeCursos(char ***cursos, double *cursos_cred,
                           const char *nomArch) {
  ofstream archRep(nomArch, ios ::out);
  if (!archRep.is_open()) {
    cout << "Error al abrir " << nomArch << endl;
    exit(1);
  }

  for (int i = 0; cursos[i]; i++) {
    char **auxCursos = cursos[i];
    archRep << auxCursos[0] << setw(60) << auxCursos[1] << setw(50)
            << auxCursos[2] << setw(20) << cursos_cred[i] << '\r';
  }
}
