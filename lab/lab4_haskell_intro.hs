-- |The 'joinStrings' function takes a list of strings
-- and returns a new string that consists of all of the strings
-- concatenated together. Remember that strings are lists!
-- Use recursion, but use pattern matching rather than a
-- conditional expression to implement this function.
joinStrings [] = ""
joinStrings (x:xs) = x ++ joinStrings xs

-- |Same as 'joinStrings', but uses foldl or foldr.
joinStrings2 = foldl (++) ""

-- |Implementation of 'elem' using 'foldl'.
elemLeft x = foldl (\a b -> a || (x == b)) False

-- |Implementation 'elem' using 'foldr'.
elemRight x = foldr (\a b -> (x == a) || b) False

-- |Returns an infinite geometric progression
-- of the form [a, ar, ar^2, ar^3, ...]
-- If you get stuck, first try to define the list
-- [1, 2, 4, 8, 16, ...]
geoSeq a r = a : map (\x -> r * x) (geoSeq a r)

