-- class 3

-- type system

-- in racket
{-
(define (f x)
  (if (> x 20)
      (first x)
      (+ x 10)))
-}
-- is legal, since racket is dynamic typed
-- no type checking at compile time
-- (f 100)
-- will give runtime error
-- type checking is done at runtime

-- haskell is statically typed
-- type of value and identifier determined at compile time

-- f x = if x > 20 then head x else x + 10
-- same function in haskell can't work
-- type inference happens
-- many modern prog lang do so too

-- in repl
-- :type val or :t val
-- gives you the type of val

f x = not x
-- > :type f
-- f :: Bool -> Bool

g x = (head x) : "345"
-- > :type g
-- g :: [Char] -> [Char]


-- class 4

-- haskell does automatic/implicit currying
sayhi = h "hi"
-- sayhi y = h "hi" y

h x y = x ++ ", " ++ y

-- curried definition
h2 x = \y -> x ++ ", " ++ y

-- x y can be any type, but same type for then and else
myf x y = if 3 > 5 then x else y
-- > :t myf
-- myf :: t -> t -> t

myf1 = myf "hi"
-- > :t myf1
-- myf1 :: [Char] -> [Char]

{-
> :type True
True :: Bool
> :type ["hi", "bye"]
["hi", "bye"] :: [[Char]]
> :type ["hi", True]
    Couldn't match expected type `[Char]' with actual type `Bool'
    In the expression: True
    In the expression: ["hi", True]

> :t (&&)
(&&) :: Bool -> Bool -> Bool
> :t h
h :: [Char] -> [Char] -> [Char]
h :: [Char] -> ([Char] -> [Char])
curried approach, higher order function
arrow right associative
1 + (2 + (3 + 4))

generic polymorphism
> :t head
head :: [a] -> a
> :t tail
tail :: [a] -> [a]

> :t (+)
(+) :: Num a => a -> a -> a
> :t [(+), (-)]
[(+), (-)] :: Num a => [a -> a -> a]
> :t foldl
foldl :: (a -> b -> a) -> a -> [b] -> a
-}
