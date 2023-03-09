@echo off

set fname=%1
nim -d:ssl c %fname%.nim 

echo --------------------
echo %fname%.exe output:

echo[
%fname%.exe
echo[

echo --------------------