rem Matrix Effect
rem Author: @mkcdr
rem Copyright (c) 2022

@echo off
setlocal enabledelayedexpansion

rem Window width and height
set /a WIDTH=50
set /a HEIGHT=25

rem ANSI escape sequences
rem and Green foreground levels for shading
set ESC=
set RESET=%ESC%[0m

set FLVL0=%ESC%[38;2;0;255;0m
set FLVL1=%ESC%[38;2;0;230;0m
set FLVL2=%ESC%[38;2;0;204;0m
set FLVL3=%ESC%[38;2;0;179;0m
set FLVL4=%ESC%[38;2;0;153;0m
set FLVL5=%ESC%[38;2;0;128;0m
set FLVL6=%ESC%[38;2;0;102;0m
set FLVL7=%ESC%[38;2;0;77;0m
set FLVL8=%ESC%[38;2;0;51;0m
set FLVL9=%ESC%[38;2;0;26;0m
set FLVL10=%ESC%[38;2;0;0;0m

rem Window settings
title Matrix Effect by @mkcdr
mode con cols=%WIDTH% lines=%HEIGHT%

rem define characters to be displayed in the matrix
set chars=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvqxyz1234567890
set /a charsLength=26*2+10

rem to prevent characters from comming out of the screen
set /a FIXED_HEIGHT=%HEIGHT%-1
set /a FIXED_WIDTH=%WIDTH%-1

rem create and fill a buffer with random characters
rem this buffer will stay constant while program is running
for /l %%i in (0, 1, %FIXED_HEIGHT%) do (
    set line=
    (for /l %%j in (0, 1 %FIXED_WIDTH%) do (
        rem choose an index between 0 and charsLength
        rem then get the character from the chars list
        set /a "_RandIndx=!random!*%charsLength%/32768"
        call set "_RandChar=%%chars:~!_RandIndx!,1%%"
        set line=!line!!_RandChar!
    ))
    set buff[%%i]=!line!
)

rem give a random start for each leading character in the column i
for /l %%i in (0, 1 %FIXED_WIDTH%) do (
    set /a "_RandStart=!random!*%FIXED_HEIGHT%/32768"
    set /a colpos[%%i]=!_RandStart!
)

rem hide the cursor 
echo %ESC%[?25l

:loop

rem coloring the matrix
for /l %%i in (0, 1, %FIXED_HEIGHT%) do (
    set line=
    (for /l %%j in (0, 1 %FIXED_WIDTH%) do (

        rem get the character at position i,j
        set _c=!buff[%%i]:~%%j,1!

        rem get the position of the leading character (brightest character)
        set /a pos=!colpos[%%j]!

        rem calculate shade level
        set /a shade=%FIXED_HEIGHT%-%%i+!pos!
        set /a shade=!shade!%%%FIXED_HEIGHT%

        rem set default black color (shade level 10)
        set color=%FLVL10%

        rem pick the proper color shade
        if !shade! geq 0 (
            if !shade! leq 10 (
                if !shade! equ 0 set color=%FLVL0%
                if !shade! equ 1 set color=%FLVL1%
                if !shade! equ 2 set color=%FLVL2%
                if !shade! equ 3 set color=%FLVL3%
                if !shade! equ 4 set color=%FLVL4%
                if !shade! equ 5 set color=%FLVL5%
                if !shade! equ 6 set color=%FLVL6%
                if !shade! equ 7 set color=%FLVL7%
                if !shade! equ 8 set color=%FLVL8%
                if !shade! equ 9 set color=%FLVL9%
                if !shade! equ 10 set color=%FLVL10%
            )
        )

        rem color the character at position i,j then print it to screen
        set out=!color!!_c!%ESC%[m
        echo %ESC%[%%i;%%jf!out!
    ))
)

rem change the position of leading character for column i
for /l %%i in (0, 1 %FIXED_WIDTH%) do (
    set /a "_RandStop=!random!*%FIXED_HEIGHT%/32768+10"
    if !colpos[%%i]! gtr !_RandStop! (
        set /a colpos[%%i]=0
    ) else (
        set /a colpos[%%i]=!colpos[%%i]!+1
    )
)

goto loop

pause
exit
