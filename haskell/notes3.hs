import Prelude hiding (Maybe, Nothing, Just)
-- http://stackoverflow.com/questions/16430025/ambiguous-occurrence

-- class 3

-- type and typeclass

-- data Point = MyPoint Float Float
-- Point: type
-- MyPoint: constructor

-- generic/parametric polymorphism
-- head :: [a] -> a
-- public int myLength(ArrayList<T> lst)

-- ad hoc polymorphism
-- function overloading
-- public int f(int n)
-- public int f(float n)
-- public void f(int n, int[] a)
-- same function name but radically different behaviour

-- no function overloading in haskell
{- error: duplicate type signature declaration
f :: Integer -> Integer
f x = x + 5
f :: [Char] -> Char
f (_:y:_) = y
-}

{- doesn't work either, due to type inference
f (_:y:_) = y
f x = x + 5
-}

-- 4 == 5
-- [1,2,3] == [1,2,3]
-- both works fine

-- (+) == (-)
-- gives error:
-- No instance for (Eq (a0 -> a0 -> a0)) arising from a use of `=='

-- > :t (==)
-- (==) :: Eq a => a -> a -> Bool
-- Eq a => says typeclass constraint

-- typeclass is somewhat like a interface in Java
-- Eq typeclass has two functions (==) (/=)
-- you need to implement all the functions under the interface

-- No instance for (...)
-- violate type class constaint

-- (+) (3 :: Integer) (4 :: Integer)
-- (+) (3 :: Float) (4 :: Float)
-- (+) (3 :: Integer) (4 :: Float) err
-- 3 + 4.3 works!
-- > :t 3
-- 3 :: Num a => a
-- > :t 4.3
-- 4.3 :: Fractional a => a

-- haskell value can be polymorphic
-- different from C++ type coersion on runtime
-- "5" + 6

-- > :t (3 + 4)
-- (3 + 4) :: Num a => a
-- expressions can be polymorphic

-- > :t []
-- [] :: [a]
-- can be a list of anything
-- > :t ([] ++ "hi")
-- ([] ++ "hi") :: [Char]
-- > [] :: [Char]
-- ""

-- 3.5 :: Integer
-- is not coersion, is type signature


-- capture more abstract concept with types

data MaybeInt = Failure | Success Integer deriving Show

-- defining two value constructors
-- Success :: Integer -> MaybeInt
-- Failure :: MaybeInt
-- | can be thought as or

-- have default definition of show
x = Failure
y = Success 10

-- > 1 / 0
-- Infinity
-- > div 1 0
-- *** Exception

safeDiv :: Integer -> Integer -> MaybeInt
safeDiv x 0 = Failure
safeDiv x y = Success (div x y)

data Day = Mon | Tue | Wed | Thu | Fri | Sat | Sun
-- good way to create enum


helper :: MaybeInt -> MaybeInt
helper Failure = Failure
helper (Success n) = Success (n + 1)

-- try avoid using short and single-use helper

divThenAdd1 :: Integer -> MaybeInt
divThenAdd1 x = 
  let y = safeDiv 100 x
  in case y of
    Failure -> Failure
    Success n ->
      let z = safeDiv 100 (n - 10)
      in case z of
        Failure -> Failure
        Success m -> Success (m + 1)

-- chain of computation, but quite lengthy

-- lift: raise the level of function, new context
lift :: (Integer -> Integer) -> (MaybeInt -> MaybeInt)
lift _ Failure = Failure
lift f (Success n) = Success (f n)

-- new haskell function compose
-- > :t (.)
-- (.) :: (b -> c) -> (a -> b) -> a -> c
-- > ((+1) . (*5)) 10
-- 51

(~>) :: MaybeInt -> (Integer -> Integer) -> MaybeInt
(~>) Failure _ = Failure
(~>) (Success n) f = Success (f n)

-- > (Success 10) ~> (*5) ~> (+1)
-- Sucess 51

(>~>) :: MaybeInt -> (Integer -> MaybeInt) -> MaybeInt
(>~>) Failure _ = Failure
(>~>) (Success n) f = f n

safeDivOf100 = safeDiv 100
-- > (Success 4) >~> safeDivOf100 ~> (+10)
-- Success 35
-- > (Success 4) >~> safeDivOf100 ~> (+10)
-- Success 35

-- polymorphic type
-- data Maybe a = Failure | Success a deriving Show
-- or use the haskell built in with Nothing | Just

data Maybe a = Nothing | Just a deriving Show
-- Maybe Int
-- Maybe [[Char]]
-- Maybe [[Int -> Int]]

-- > :t Nothing
-- Nothing :: Maybe a
-- > :t (Just True)
-- (Just True) :: Maybe Bool
-- > :t (Just ["123"])
-- (Just ["123"]) :: Maybe [[Char]]

-- now we can redefine with polymorphic types

(~~>) :: Maybe a -> (a -> b) -> Maybe b
(~~>) Nothing _ = Nothing
(~~>) (Just n) f = Just (f n)

(>~~>) :: Maybe a -> (a -> Maybe b) -> Maybe b
(>~~>) Nothing _ = Nothing
(>~~>) (Just n) f = f n
