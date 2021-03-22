// Arreglos

#include <iostream>

using namespace std; // mejor no utilizar si invocamos más librerías

int main()
{

  char vocales[]{'a', 'e', 'i', 'o', 'u'};
  cout << "\nLa primera vocal es: " << vocales[0] << endl;
  cout << "La última vocal es: " << vocales[4] << endl;

  //    cin >> vocales[5];  fuera de límites - no hacer esto!!

  double alta_temp[]{90.1, 89.8, 77.5, 81.6};
  cout << "\nLa primera temperatura es: " << alta_temp[0] << endl;

  alta_temp[0] = 100.7; // asignar al primer elemento el valor de 100.

  cout << "La primera temp más alta es ahora: " << alta_temp[0] << endl;
  //

  int puntajes[]{100, 90, 80, 70, 60};

  cout << "\nPrimer puntaje en índice 0: " << puntajes[0] << endl;
  cout << "Segundo puntaje en índice 1: " << puntajes[1] << endl;
  cout << "Tercer puntaje en índice 2:  " << puntajes[2] << endl;
  cout << "Cuarto puntaje en índice 3: " << puntajes[3] << endl;
  cout << "Quinto puntaje en índice 4: " << puntajes[4] << endl;

  cout << "\nIngrese 5 puntajes: ";
  cin >> puntajes[0];
  cin >> puntajes[1];
  cin >> puntajes[2];
  cin >> puntajes[3];
  cin >> puntajes[4];

  cout << "\nEl arreglo actualizado es:" << endl;
  cout << "Primer puntaje en índice 0: " << puntajes[0] << endl;
  cout << "Segundo puntaje en índice 1: " << puntajes[1] << endl;
  cout << "Tercer puntaje en índice 2:  " << puntajes[2] << endl;
  cout << "Cuarto puntaje en índice 3: " << puntajes[3] << endl;
  cout << "Quinto puntaje en índice 4: " << puntajes[4] << endl;

  cout << "\nObserve que el valor del nombre del arreglo es : " << puntajes << endl;

  cout << endl;
  //Utilizando un ciclo for
  for (int i=0;i<5;i++){
      cout<<"El valor del puntaje es "<<puntajes[i]<<'\n';
  }
  return 0;
}