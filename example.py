from z3 import Solver, EnumSort, Const, Distinct

s = Solver()
Color, (red, green, blue) = EnumSort('Color',  ['red', 'green', 'blue'])

a = Const('a', Color)
b = Const('b', Color)
s.add(Distinct(a, b))

s.check()
print(s.model())
# [b = green, a = red]
