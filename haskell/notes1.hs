-- class 1

-- 4 major diff with racket
-- 1) lazy eval
-- 2) statically typed
-- 3) ...
-- 4) ...

-- work flow: write file and load in repl ghci

-- max 3 4
-- 3 + 4 -- infix op

-- \x -> x + 4 in repl err: repl want to convert to str to output
-- (\x -> x + 4) 5
-- (\x y -> x + y * 100) 3 1

-- define var: let instead of define
-- let: special syntactic keyword
-- use let x = 10 in repl
-- use x = 10 in source file
x = 10
f1 = \x -> x + 4
f2 x = x + 4 -- nicer syntax, only diff

-- not enough time for primitives
-- read notes and last term labs

-- :show modules show loaded files
-- :load, :reload = :r

-- special naming convention for operators
-- (+) 3 4 -- equiv: 3 + 4

(++--**!) x y = x + y * 100
-- (++--**!) 1 2 equiv 1 ++--**! 2
-- no letters in infix operators

-- let in haskell, similar to let* in racket
g y = 
  let x = y + 3
      z = 10
      w = x + y
  in
      x + y * z - w

-- function def as pattern matching
-- better syntax for conditions
-- just like racket macros
myf 3 = 100
myf x = 32 + x

-- if only have myf 5 = 100
-- but calling with myf 20
-- gives non-exhaustive patterns error

-- lists: [1, 2, 3]
-- head (car), tail (cdr), null (empty?)
-- cons: 1 : [2, 3] (infix), (:) 1 [2, 3] (prefix)
-- equiv: 3 : 2 : 1 : []
-- 3 : (2 : (1 : [])) (right assoc)

-- 3 : 2 won't give a tuple
-- tuple represented as (3, 2)

-- pattern matching
myg (x:xs) = x + 10 -- equiv: myg lst = (head lst) + 10
myg [] = 1000
-- myg 12 gives type error
-- myg [[1, 2], 3] type error

-- actually don't care about xs
-- equiv: myg (x:_) = x + 10
-- conveys better msg

-- arbitrary pattern
listsecond (x1:x2:xs) = x2
tuplesecond ((_,x2)) = x2

-- string are list of chars
-- head "hello" -> 'h'

-- class 2

-- myfoldl (+) 0 [1,2] -> (+ (+ 0 1) 2)
myfoldl _ i [] = i
myfoldl f i (x:xs) = myfoldl f (f i x) xs
-- myfoldl tail call position
-- advantage: save stack frame O(n) -> O(1)

-- myfoldr (+) 0 [1,2] -> (+ 1 (+ 2 0))
myfoldr _ i [] = i
myfoldr f i (x:xs) = f x (myfoldr f i xs)
-- f tail call position

-- myfoldr (+) 0 [1..100000000] out of memory
-- myfoldl (+) 0 [1..100000000] out of memory
-- can perform tail call optimization, but didn't
-- why?

-- myfoldl (+) 0 [1,2,3]
-- myfoldl (+) 1 [2,3]
-- myfoldl (+) 3 [3]
-- myfoldl (+) 6 []
-- 6

-- haskell does lazy eval, in contrast to eager eval
-- only eval arguments when necessary

-- True || (head []) -> True, short circuit
-- define my own or
f x y = x || y
-- f True (head []) -> True || (head []) -> True

f3 x y = x + 3
-- substitute to argument first before evaluation
-- f3 5 (head []) -> 5

-- myfoldl (+) 0 [1,2,3]
-- accumulate all computations, expand all expression before computation
-- pass in a reference to a funciton call to be evaluated

-- pros: prevent unnecessary computations
-- cons: hard to debug and argue about order of computation

-- lazy eval gives rise to infinite data structure
repeat3 = 3 : repeat3
-- head repeat3 -> 3
-- head doesn't need to deal with rest of the list
-- head (tail repeat3) -> head repeat3 -> 3
-- take 4 repeat3 -> [3,3,3,3]

copied = repeat3
-- bindings are lazy too

i = i + 1
-- compile time fine
-- i + 2 will be infinite computation

-- similar to generator, haskell has default generator

nats = 0 : map (\x -> x + 1) nats
-- head (tail nats) -> 1
-- head (tail (tail nats)) -> 2
-- no magic, just simple substitution

evens = filter (\x -> mod x 2 == 0) nats
odds = filter (\x -> mod x 2 == 1) nats

-- can redo prime number lab ex again in haskell

-- read course notes!
