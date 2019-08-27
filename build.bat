@echo off

rmdir /s /q build
rmdir /s /q __pycache__
rmdir /s /q dist\*.exe

pyinstaller --clean --noupx -c -F -i favicon.ico ETMAP_class.py -p ProcessET.py --hidden-import win32timezone --hiddenimport=pandas._libs.tslibs.np_datetime --exclude-module win32ctypes

del /q ETMAP_class.spec
rmdir /s /q build
rmdir /s /q __pycache__
