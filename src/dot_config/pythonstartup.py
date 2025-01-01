"""
bashrc but for Python

Runs on both Python and IPython.
"""

from os import environ
from pathlib import Path

P = Path

print(f"\nUsing PYTHONSTARTUP file: {environ.get("PYTHONSTARTUP")}")
print("Read this file for information about custom macros/utilities.")

ipy = None

try:
    from IPython.core.getipython import get_ipython
    ipy = get_ipython()
except ImportError:
    pass

def math_mode():
    from sympy import init_session, Rational, pi

    init_session()

    global R
    R = Rational

    # eval last line
    if ipy:
        ipy.define_macro("ev", "N(_)")

    global radians
    def radians(angle):
        return angle * 2 * pi / 360

def rel():
    """Enable autoreloading of libraries."""
    if ipy:
        ipy.run_line_magic("load_ext", "autoreload")
        ipy.run_line_magic("autoreload", "2")

def data_mode():
    try:
        import numpy as np
    except ImportError:
        pass
    try:
        import pandas as pd
    except ImportError:
        pass
    try:
        import matplotlib.pyplot as plt
    except ImportError:
        pass
