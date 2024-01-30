from mypyc.build import mypycify
from setuptools import setup

setup(name="main", ext_modules=mypycify(["main.py"]))
