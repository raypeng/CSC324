-- class 7

-- haskell syntax "type", define type alias for existing
type String = [Char]

-- data String = MyString [Char]
-- could use this, yet have to use constructor every time
-- kind of similar but totally different thing
-- type (class) vs constructor

-- mutation? no, haskell is pure!
-- can only simulate mutation with functions

type Stack = [Integer]
-- let's define: front of list is top of stack
-- > :t ([1,2,3] :: Stack)
-- ([1,2,3] :: Stack) :: Stack

-- quite procedural/imperical way
-- switch to more generic StackOp
type StackOp a = Stack -> (a, Stack)

-- push :: Integer -> Stack -> ((), Stack)
push :: Integer -> StackOp ()
push x stack = ((), x : stack)

-- mutation not really happening, "mutated" only returned

-- pop :: Stack -> (Integer, Stack)
pop :: StackOp Integer
pop (x:xs) = (x, xs)
-- skipping matching []

-- reverseTopTwo :: Stack -> Stack
reverseTopTwo :: StackOp ()
reverseTopTwo stack =
  let (x, s1) = pop stack
      (y, s2) = pop s1
      (_, s3) = push x s2
      (_, s4) = push y s3
  in
      ((), s4)

-- f >>> g: "f then g"
-- 1. take in stack, apply f to get a new stack, throwing away the "data"
-- 2. apply g to the new stack, return
(>>>) :: StackOp a -> StackOp b -> StackOp b
f >>> g = \stack ->
  let (_, s1) = f stack
  in
      g s1

push22 = (push 2) >>> (push 2)
-- > push22 [1,2,3]
-- ((),[2,2,1,2,3])

reverseTopTwo2 :: StackOp ()
reverseTopTwo2 stack =
  let (x, s1) = pop stack
      (y, s2) = pop s1
  in
      (push x >>> push y) s2


-- class 8

-- ideally want to use 
-- pop >>> pop >>> push x >>> push y
-- but what is x, y?
-- need a new operator to deal with data

-- f >~> g: "f bind g"
(>~>) :: StackOp a -> (a -> StackOp b) -> StackOp b
f >~> g = \stack ->
  let (result, s1) = f stack
  in
      (g result) s1

-- (>~>) :: StackOp a -> (a -> StackOp b) -> StackOp b
-- (>~>) :: Maybe a -> (a -> Maybe b) -> Maybe b
-- extremely similar

addOneTop = pop >~> \result -> push (result + 1)
duplicateTop = pop >~> \result -> (push result >>> push result)

-- we can get rid of let
-- and simplify the definition
reverseTopTwo3 :: StackOp ()
reverseTopTwo3 =
  pop >~> \x ->
  pop >~> \y -> 
  push x >>> push y

sumOfStack :: StackOp Integer
sumOfStack [] = (0, []) -- lazy for now, should define isEmpty
sumOfStack stack =
  (pop >~> \top ->
   sumOfStack >~> \sumOfRest ->
   returnNoMutate (top + sumOfRest)) stack

returnNoMutate :: a -> StackOp a
returnNoMutate item = \stack -> (item, stack)

-- > sumOfStack [1,2,3,4,5]
-- (15, [])
-- bad thing is that the stack is popped to empty in the end
-- can be fixed somehow...

-- haskell IO

-- putStrLn
-- putStrLn :: Prelude.String -> IO ()
-- IO () no return value

-- getLine
-- getLine :: IO Prelude.String
-- returns a String

-- >>= haskell equivalent of >~>
-- >>  haskell equivalent of >>>
echo :: IO ()
echo =
  getLine >>= \result ->
  putStrLn result >>
  putStrLn result

-- >>= >> can be used other than IO
-- Monad typeclass generalized
-- > :t (>>=)
-- (>>=) :: Monad m => m a -> (a -> m b) -> m b
-- (>~>) :: StackOp a -> (a -> StackOp b) -> StackOp b
-- (>~>) :: Maybe a -> (a -> Maybe b) -> Maybe b

-- in a sense we don't need to bother defining Maybe StackOp
-- instead, can make them instances of Monad

-- end of haskell
