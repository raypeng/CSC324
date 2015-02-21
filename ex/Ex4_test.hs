import Test.HUnit
import Ex4 (primes, Tree(..), infinitree)

primesTests :: Test
primesTests = TestList [
    [2,3,5,7,11] ~=? take 5 primes,
    13 ~=? primes !! 5
    ]

infinitreeTests :: Test
infinitreeTests = TestList [
    0 ~=? root infinitree,
    1 ~=? root (left infinitree),
    1 ~=? root (right infinitree)
    ]

root :: Tree -> Integer
root (Node a _ _) = a
left :: Tree -> Tree
left (Node _ l _) = l
right :: Tree -> Tree
right (Node _ _ r) = r

main :: IO ()
main = do
    runTestTT primesTests
    runTestTT infinitreeTests
    return ()
