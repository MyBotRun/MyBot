@echo off
::if "%1" EQU "compile_only" set compile_only=true
::if "%1" EQU "zip_only" goto :zip_only
::if "%1" EQU "retry" goto :retry
build.bat compile_only