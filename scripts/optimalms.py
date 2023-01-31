import csv
import math
from sympy import symbols,expand,diff,solve

metacog,points = symbols("metacog points")
# from metacog plus from buying

#def calcPoints(m,p): 
#    return (10*(m * (m + 1))/2) + m * ( p - (m * (m + 1)/2))
def calcPoints(m,p): 
    return (10*(m * (m + 1))/2) + m * ( p - (m * (m + 1)/2))
expr = calcPoints(metacog,points)
maxExpr = diff(expr,metacog)
# find maxima
maximumPoints = solve(maxExpr,metacog)

solution = maximumPoints.pop()
resolved = expr.subs(metacog,solution)

def solvFake(i):
    metacogLevel = solution.evalf(subs= {points: i })
    pointTotal = resolved.evalf(subs= {points: i})
    return metacogLevel,pointTotal
def solve(i):
    lf,_ = solvFake(i)
    lowerValue = calcPoints(math.floor(lf),i)
    higherValue = calcPoints(math.ceil(lf),i)
    if higherValue >= lowerValue:
        return math.ceil(lf),higherValue
    else:
        return math.floor(lf),lowerValue

def execute(i):
    l,p = solve(i)
    print(i,l,p)
for i in range (50,250,10):
    execute(i)
for i in range (250,500,25):
    execute(i)
for i in range (500,1050,50):
    execute(i)
