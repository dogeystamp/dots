try:
    from sympy import init_session, Rational
    init_session()

    R = Rational
except ImportError:
    pass
