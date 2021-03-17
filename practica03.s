# practica 3. Principio de computadoras
#Ismael Martín Herrera
#alu0101397375@ull.edu.es
#
#
#
# #include <iostream>
#int main (){
#   double error{0};
#   std::cout << "Práctica 3. PRINCIPIO DE COMPUTADORES" << '\n' << "Introduzca el error máximo permitido: ";
#     std::cin >> error;
#     float resultado{1};
#     float resultado2{1};
#     float factorial{1};
#     int i{0};
#     do{
#       i += 1;
#       factorial = factorial * i;
#       resultado = resultado2;
#       resultado2 += (1/factorial);
#     }
#     while ( (resultado2 - resultado) >= error );
    
#     std::cout << "El número e = " << resultado2 << std::endl;
#     std::cout << "Número de términos calculados: " << i + 1 << std::endl;
#     return 0;
# }

#Registro usados:
#$f0, para la variable error

        .data #directiva que indica la zona de datos

titulo:         .asciiz "Práctica 3. PRINCIPIO DE COMPUTADORES\n"
mensaje1:       .asciiz "Introduzca el error máximo permitido: "
resultado:      .asciiz "El número e = "
msjterminos:    .asciiz "Número de términos calculados: "

        .text #directiva que indica la zona de código (en la que están las instrucciones)

main: 

    #Impresión del título del programa por pantalla
    #std::cout << "Práctica 3. PRINCIPIO DE COMPUTADORES" 

    li $v0, 4       #Registro $v0 inicizalizado a 4. Por convenio esto permite la impresión por pantalla de strings
    la $a0, titulo  #Registro $a0 predeterminado por convenio para cargar la dirección de la string a imprimir
    syscall

    #Impresión del mensaje al usuario, para que introduza el error deseado
    #<< "Introduzca el error máximo permitido: "

    li $v0, 4       #Registro $v0 inicizalizado a 4. Por convenio esto permite la impresión por pantalla de strings
    la $a0, mensaje1  #Registro $a0 predeterminado por convenio para cargar la dirección de la string a imprimir
    syscall

    #Lectura de teclado del valor del error introducido por el usuario
    #std::cin >> error;

    li $v0, 6       #Registro $v0 inicializado a 6. Por convenio esto permite leer un float de teclado
    syscall
    move $f0, $v0   #Registro $f0, establecido por convenio para la lectura de float, al que se le carga de $v0
                    #error --> $f0
    
    #Inicialización de variables:

    #     float resultado{1};
    li.s $f4, 1
    #     float resultado2{1};
    li.s $f5, 1
    #     float factorial{1};
    li.s $f6, 1
    #     int i{0}; 
    move $t0, $zero     #Contador del do-while

    #do-while{}

    do: 
        sub.s $f8, $f5, $f4
        ble $f8, $f0 while  #Condición invertida while((resultado2- resultado) >= error)

        addu $t0, 1         # i += 1
        #mtc1 $t0, $f7
        mult $f6, $f6, $t0  # factorial = factorial * i POSIBLE ERROR REVISAR 
        mov.s $f4, $f5      # resultado = resultado2
        div.s $f6, $f6, 1   # (1/factorial)
        add.s $f5, $f5, 
        b do    # Volver al do      
    while:

    add $t0, 1      # i + 1 Para ser impreso al final

    #Impresión por pantalla del resultado de e

    #std::cout << "El número e = " 

    li $v0, 4       #Registro $v0 inicizalizado a 4. Por convenio esto permite la impresión por pantalla de strings
    la $a0, resultado  #Registro $a0 predeterminado por convenio para cargar la dirección de la string a imprimir
    syscall

    #<< resultado2 << std::endl;

    li $v0, 2       #Registro $v0 inicializado a 2, porque por convenio esto permite imprimir float por pantalla
    mov.s $f12, $f5

    #Impresión del número de términos calculados
    #std::cout << "Número de términos calculados: "

    li $v0, 4       #Registro $v0 inicizalizado a 4. Por convenio esto permite la impresión por pantalla de strings
    la $a0, msjterminos  #Registro $a0 predeterminado por convenio para cargar la dirección de la string a imprimir
    syscall

    #<< i + 1 

    li $v0, 1       #Registro $v0 inicizalizado a 1. Por convenio esto permite la impresión por pantalla de int
    move $a0, $t0   #Registro $a0 predeterminado por convenio para mover el int a imprimir
    syscall

#Fin del programa (exit)

li $v0, 10
syscall


