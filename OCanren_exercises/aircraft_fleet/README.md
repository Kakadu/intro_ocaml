# The Range of a Fleet of Aircraft 


## Background

There is a fleet of N identical aircraft, where every aircraft has a fuel capacity of C liters and
fuel efficiency of R miles per liter of fuel. The fleet has a mission of reaching some target located
at a distance D from the airbase, where CR < D < NCR. Once taking off, there
is no more airbase along the way for the fleet to land and refuel. The fleet adopts such a  strategy that
at any stage, any one aircraft could be abandoned, whose fuel is simultanously transferred to some fellow
aircraft. The mission is considered as successful if  at least
one aircraft  finally reaches the target.


## Abstraction


### Discrete Motion

For some arbitrary positive interger B, we take C/B liters as one unit of fuel
and take (RC)/B miles as one unit of distance, and say that an aircraft has a
maximum capacity of B units of fuel, and with which it can fly for B units of
distance at the most. We call B the _abstract capacity_ of an aircraft.

Moreover, we assume that an aircraft consumes fuel and covers distance in a discrete
(or unit-by-unit) and propotional manner, where one unit of fuel is consumed at
a time,  resulting in one unit of distance flied.

### Discrete Fuel Trasnfer 

Transfer of fuel within the fleet is also discrete:  only whole units
are allowed. For example, if an aircraft has 3 units of fuel left in the tank
that has a capacity of 5 units, then it can only refuel for 1 unit or 2 units.


## Remarks

Although the value of the abstract capacity B is arbitrarily picked, we must set it
to at least 2. If we set B = 1 then it would be impossible for the fleet to reach
the target, given our _discrete motion_ and _discrete fuel transfer_ assumptions.


For instance, B = 1 implies that the fleet would move forward for 1 unit of distance, 
running out of fuel and all aircraft abandoned.  B = 2 implies two possibilities:

1. moving forward for 2 units of distance, and then running out of fuel;
1. moving forward for 1 unit, then abandoning one aircraft, tansferring its fuel to the other, who
continues to fly for 2 units. Thus the fleet achieves the range of 3 units.


## Reference

J. N. Franklin _[The Range of a Fleet of Aircraft](https://doi.org/10.1137/0108039)_
Journal of the Society for Industrial and Applied Mathematics, 8(3), 541–548. (8 pages) 


