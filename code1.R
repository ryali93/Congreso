#################################################
#@author Roy Yali Samaniego <ryali93@gmail.com>
#################################################

########################################
###########   INTRODUCCIÓN  ############
########################################

3+4
6+12

#Aritmetica con R
# Suma
5 + 5 
# Resta
5 - 5 
# Multiplicacion
3 * 5
# Division
(5 + 5) / 2 
# Exponentes
2^5
# Modulo
28%%6

#Asignacion de variables
x <- 42
x
manzanas <- 5
naranjas<-6
frutas<-manzanas+naranjas

########################################
##########   TIPOS DE DATOS  ###########
########################################

#Numerico
num <- 42
#Caracter
char <- "universo"
#Logico
logico <- FALSE

class(num)
class(char)
class(logico)


########################################
#############   VECTORES  ##############
########################################

#Arreglos unidimensionales que pueden almacenar data numerica, caracteres, logicos
vector_numerico <- c(1, 10, 49)
vector_caracter <- c("a", "b", "c")
vector_logico   <- c(T,F,T)

persona <- c("Nombre Apellido", "Estudiante")
names(persona) <- c("Name", "Profession")


semana1 <- c(-40, -30, -14, 110, -35)
semana2 <- c(-20, -32, 16, -50, 140)
dias <- c("Lunes", "Martes", "Miercoles", "Jueves", "Viernes")
names(semana1) <- dias

total <- sum(semana1)+sum(semana2)

total_semana1 <- sum(semana1)
total_semana2 <- sum(semana2)

total_semana1 > total_semana2

#Seleccion
semana1[2]
semana2[4]



#Vector
#Lista
#Matriz
#Data Frame
#Arreglos
