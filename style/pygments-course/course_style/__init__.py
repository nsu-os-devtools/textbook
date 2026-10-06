"""'course' Pygments style for the devtools course manual.

Matches the previous listings palette exactly, with one important fix:
the Error token is plain black (NO red box, unlike the 'vs' style).

Palette (same as the old listings setup in style/course.sty):
- comments : green!50!black  -> #008000, upright
- keywords : blue!70!black   -> #0000B2, bold
- strings  : red!70!black    -> #B20000
- everything else (numbers, names, operators, punctuation) : black

Value format for this Pygments version: a single space-separated string,
e.g. "#0000B2 bold" (color + style attributes), NOT a (color, attr) tuple.
"""
from pygments.style import Style
from pygments.token import Token


class Course(Style):
    name = 'course'
    aliases = ['course']
    priority = 0
    background_color = '#ffffff'
    styles = {
        Token.Comment: '#008000',
        Token.Keyword: '#0000B2 bold',
        Token.String: '#B20000',
        Token.Error: '#000000',
    }
