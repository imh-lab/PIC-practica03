#Práctica 3. Principios de computadores
#Ismael Martín Herrera
#alu0101397375@ull.edu.es
#
#----------------------------------------------------------------------------------------------

#                                           CÓDIGO EN C++
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
#----------------------------------------------------------------------------------------------

#                                   REGISTROS USADOS: 

#Para los variable flotantes: (Registro del coprocesador)
    #Desde $f4 hasta $f10, por ser registros temporales, y disponibles para uso, según el convenio establecido. 
    #   También hago uso del registro $f16, para guardar la división 1/factorial, este registro está
    #   en el segundo tramo establecido por convenio como registro temporal flotante. 
    #Destacar que los registros no lo uso en pares puesto que en precisión simple no es necesario, debido a que 
    #esta requiere 32 bits, y los registros del coprocesador MIPS son de 32 bits cada uno. 

#Registros, $v0,$a0 para impresión por pantalla y lectura de teclado: se explican en los comentarios al lado 
#de la parte del código en la que se hace uso de los mismos.

#Para las variables de tipo int:
#   He usado los registros $t0 y $t1, ambos dentro de la franja de registros temporales. 
#       $t0 --> i
#       $t1 --> factorial (luego se convierte a flotante de precisión simple tal y como está en los comentarios
#                          para poder trabajar con el resto del código en flotante simple).

#----------------------------------------------------------------------------------------------

#                                  APARTADO 3:
# Explica brevemente cómo puedes transformar tu programa al cálculo del número e en doble precisión. Escribe 
# de forma detallada si realizar este cambio afecta a la elección de tus registros.
# 
#   Para que mi código calcule el valor del número e en doble precisión, habría que cambiar algunas instrucciones tales como
#   add.s por add.d, li.s --> li.d, y con el resto de instrucciones .s, habría que hacer lo propio. Por otra parte, en las líneas
#   114 a 115, habría que hacer algunos cambios para realizar la conversión del registro asigando a la variable factorial a doble 
#   precisión, el código quedaría de la siguiente forma:

#                          Código en precisión simple |  Código en doble precisión
#                               mtc1 $t1, $f7         |        mtc1 $t1, $f7
#                               cvt.s.w $f9, $f7      |        cvt.d.w $f9, $f7  
#                             
#   tal y como se observa habría que cambiar de .s a .d 

#   En cuanto a los registros, si que habría que hacer cambios, y tener en cuenta un aspecto sumamente importante, y es que los
#   registros del coprocesador MIPS (el encargado de los registros en punto flotante), tiene 32 bits, suficientes para la simple
#   precisión. Sin embargo, para representar en doble precisión requerimos 64 bits, por lo que habría que utilizar los registros
#   en pares, por ejemplo $f0-$f1. 
# 
# 
#----------------------------------------------------------------------------------------------

        .data #directiva que indica la zona de datos

titulo:         .asciiz "Práctica 3. PRINCIPIO DE COMPUTADORES\n"
mensaje1:       .asciiz "Introduzca el error máximo permitido: "
resultado:      .asciiz "El número e = "
msjterminos:    .asciiz "\nNúmero de términos calculados: "

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
    syscall #Registro $f0, establecido por convenio para la lectura de float, al que se le carga de $v0, error --> $f0
    #----------------------------------------------------------------------------------------------
    
    #Inicialización de variables:

    #     float resultado{1};
    li.s $f4, 1.0
    #     float resultado2{1};
    li.s $f5, 1.0
    #     int factorial{1};
    li   $t1, 1
    #     int i{0}; 
    move $t0, $zero     #Contador del do-while, i --> $t0
    #----------------------------------------------------------------------------------------------

    #do-while{}

    do: 
        addu $t0, 1         # i += 1

        mul $t1, $t1, $t0  # factorial = factorial * i | factorial --> $t1
        mov.s $f4, $f5      # resultado = resultado2

        # Conversión de t1 a flotante simple, para poder hacer el cálculo posterior, 1/factorial, y que este resulte en punto flotante
        mtc1 $t1, $f7
        cvt.s.w $f9, $f7    

        li.s $f10, 1.0         #Inicializamos a 1 el registro $f10, para poder realizar a continuación 1/factorial
        div.s $f16, $f10, $f9  # (1/factorial)
 

        add.s $f5, $f5, $f16   #resultado2 += (1/factorial); resultado2 -->$f5

        sub.s $f8, $f5, $f4 #resultado2 - resultado = $f8; $f5 - $f4 = $f8

        c.le.s $f8, $f0     #Condición invertida while((resultado2- resultado) >= error)
        bc1t while          #Salto en caso de cumplirse la condición anterior

        b do    # Salto al do, si la condición previa no se cumple     
    while:

    add $t0, 1      # i + 1 Para ser impreso al final, por contar empezar a iterar con la variable i inicializada a 0, 
                    # para luego sumarle 1 al entrar al bucle do - while {}
    #----------------------------------------------------------------------------------------------

    #Impresión por pantalla del resultado de e

    #std::cout << "El número e = " 

    li $v0, 4       #Registro $v0 inicizalizado a 4. Por convenio esto permite la impresión por pantalla de strings
    la $a0, resultado  #Registro $a0 predeterminado por convenio para cargar la dirección de la string a imprimir
    syscall

    #<< resultado2 << std::endl;
    mov.s $f12, $f5
    li $v0, 2       #Registro $v0 inicializado a 2, porque por convenio esto permite imprimir float por pantalla
    syscall
    #----------------------------------------------------------------------------------------------

    #Impresión del número de términos calculados
    #std::cout << "Número de términos calculados: "

    li $v0, 4       #Registro $v0 inicizalizado a 4. Por convenio esto permite la impresión por pantalla de strings
    la $a0, msjterminos  #Registro $a0 predeterminado por convenio para cargar la dirección de la string a imprimir
    syscall

    #<< i + 1 

    li $v0, 1       #Registro $v0 inicizalizado a 1. Por convenio esto permite la impresión por pantalla de int
    move $a0, $t0   #Registro $a0 predeterminado por convenio para mover el int a imprimir
    syscall
    #----------------------------------------------------------------------------------------------
#Fin del programa (exit)

li $v0, 10
syscall


#                                                                                   ISMAEL MARTÍN HERRERA -- Universidad de La Laguna -- PRINCIPIOS DE COMPUTADORES