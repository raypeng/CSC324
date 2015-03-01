import Test.HUnit
import Ex5 (Tree(..), treeSum, eitherMap)

treeSumTests :: Test
treeSumTests = TestList [
    Just 0 ~=? treeSum Empty,
    Nothing ~=? treeSum (Node Nothing Empty Empty),
    Just 4 ~=? treeSum (Node (Just 4) Empty Empty)
    ]

-- Helpers for eitherMap
add10 :: Integer -> Integer
add10 = (+10)

take2 :: [Integer] -> [Integer]
take2 = take 2

eitherMapTests :: Test
eitherMapTests = TestList [
    -- Note: we need to put an explicit type annotation in each of our tests
    Left 15 ~=? eitherMap add10 take2 (Left 5),
    Right [3,2] ~=? eitherMap add10 take2 (Right [3,2,10,4,2])
    ]

main :: IO ()
main = do
    runTestTT treeSumTests
    runTestTT eitherMapTests
    return ()

