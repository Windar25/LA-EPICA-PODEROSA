#ifndef FUNCIONES_HPP
#define FUNCIONES_HPP

#include "utils.hpp"
using namespace std;

void cargarCursosYEscalas(char ***&cursos, double *&cursos_cred,
                          double *escalas, const char *nomCursos,
                          const char *nomEscala);

char *leerExacto(ifstream &arch);

char *leerNombre(ifstream &arch);

void asignarCursos(char ***&cursos, double *&cursos_cred,
                   int cant_actual_cursos, int &cant_total_cursos, char *codigo,
                   char *nombre, double creditos, char *profesor);

char **asignarCursosSimple(char *codigo, char *nombre, char *profesor);

void pruebaDeCargaDeCursos(char ***cursos, double *cursos_cred,
                           const char *nomArch);

#endif  // !FUNCIONES_HPP
// #define
