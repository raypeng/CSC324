-- type worksheet

x = if 3 > 4 then 15 else 40

y = [4,5,6,7]

z = [[4,5], [1,10], [5]]

f x = if x + 3 > 10 then "Hi" else "Bye"

g x = (head x) + 10

myid x = x

h x = [x]

j x y = x > (y + 1)

j1 = j 2

k x y z = if x then y else z

k1 = k True "Hi"

applyToThree f = f 3

apply f x = f x

makeAdder x = \y -> x + y

-- and the following HOF list func

{-

map

filter

foldl

-}

-- user define data types

-- data Point = Point Float Float

data Point = MyPoint Float Float

{-
> :t (MyPoint 1 2)
(MyPoint 1 2) :: Point
> :t MyPoint
MyPoint :: Float -> Float -> Point
> :t Point
error
> :t Integer
error
-}

-- sumCoords :: Point -> Float
sumCoords (MyPoint x y) = x + y
