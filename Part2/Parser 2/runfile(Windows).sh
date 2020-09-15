#!/bin/bash
rm ./a
lex parser.l
yacc -dy parser.y
gcc y.tab.c -w -o a
echo " "
echo " "
echo "==========================================================================================="
echo "                                  Test Case 1: "
echo "==========================================================================================="
./a TestCase1.c
echo " "
echo " "
echo "==========================================================================================="
echo "                                  Test Case 2: "
echo "==========================================================================================="
./a TestCase2.c
echo " "
echo " "
echo "==========================================================================================="
echo "                                  Test Case 3: "
echo "==========================================================================================="
./a TestCase3.c
echo " "
echo " "
echo "==========================================================================================="
echo "                                  Test Case 4: "
echo "==========================================================================================="
./a TestCase4.c
echo " "
echo " "
echo "==========================================================================================="
echo "                                  Test Case 5: "
echo "==========================================================================================="
./a TestCase5.c
echo " "
echo " "
echo "==========================================================================================="
echo "                                  Test Case 6: "
echo "==========================================================================================="
./a TestCase6.c
