#!/bin/bash
rm ./a.out
yacc -d parser.y -Wnone
flex scanner.l
gcc y.tab.c -ll -ly -w
echo " "
echo " "
echo "-------------------------------------------------------"
echo "                     Test Case 1: 		     "
echo "         Evaluation of arithmetic expressions "
echo "_______________________________________________________"
cat -n test1.c
echo "-------------------------------------------------------"
echo "          	      Output: 			     "
echo "_______________________________________________________"
./a.out test1.c
echo " "
echo " "
echo "-------------------------------------------------------"
echo "                     Test Case 2: "
echo "                Conditional statement"
echo "_______________________________________________________"
cat -n test2.c
echo "-------------------------------------------------------"
echo "                         Output:	"
echo "_______________________________________________________"
./a.out test2.c
echo " "
echo " "
echo "-------------------------------------------------------"
echo "                     Test Case 3: "
echo "                      While loop"
echo "_______________________________________________________"
cat -n test3.c
echo "-------------------------------------------------------"
echo "                         Output:	"
echo "_______________________________________________________"
./a.out test3.c
echo " "
echo " "
echo "-------------------------------------------------------"
echo "                     Test Case 4: "
echo "               Nested if else statements	"
echo "_______________________________________________________"
cat -n test4.c
echo "-------------------------------------------------------"
echo "                         Output:	"
echo "_______________________________________________________"
./a.out test4.c
echo " "
echo " "
echo "-------------------------------------------------------"
echo "                     Test Case 5: "
echo "                  Nested while loop "
echo "_______________________________________________________"
cat -n test5.c
echo "-------------------------------------------------------"
echo "                         Output:	"
echo "_______________________________________________________"
./a.out test5.c
echo " "
echo " "
echo "-------------------------------------------------------"
echo "                     Test Case 6: "
echo "                        Arrays "
echo "_______________________________________________________"
cat -n test6.c
echo "-------------------------------------------------------"
echo "                         Output:	"
echo "_______________________________________________________"
./a.out test6.c
echo " "
echo " "
echo "-------------------------------------------------------"
echo "                     Test Case 7: "
echo "             Function call with parameters"
echo "_______________________________________________________"
cat -n test7.c
echo "-------------------------------------------------------"
echo "                         Output:	"
echo "_______________________________________________________"
./a.out test7.c
echo " "
echo " "
echo "-------------------------------------------------------"
echo "                     Test Case 8: "
echo "            If else statement inside while loop"
echo "_______________________________________________________"
cat -n test8.c
echo "-------------------------------------------------------"
echo "                         Output:	"
echo "_______________________________________________________"
./a.out test8.c
echo " "
echo " "

