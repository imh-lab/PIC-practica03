
#include <iostream>
int main (){
    double error{0};
    std::cout << "Práctica 3. PRINCIPIO DE COMPUTADORES" << '\n' << "Introduzca el error máximo permitido: ";
    std::cin >> error;
    float resultado{1};
    float resultado2{1};
    float factorial{1};
    int i{0};
    do{
      i += 1;
      factorial = factorial * i;
      resultado = resultado2;
      resultado2 += (1/factorial);
    }
    while ( (resultado2 - resultado) >= error );
    
    std::cout << "El número e = " << resultado2 << std::endl;
    std::cout << "Número de términos calculados: " << i + 1 << std::endl;
    return 0;
}

