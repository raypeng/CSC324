-- Task 0  Review

-- return the square root of the input, failing when the input is negative.
safeRoot :: Float -> Maybe Float
safeRoot x = if x < 0 then Nothing else Just (x ** 0.5)

-- return the first item of a list, failing when the list is empty.
safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (x:xs) = Just x

-- return the "success" value of a maybe, or the second argument if 
-- the first argument is a failure.
getValue :: Maybe a -> a -> a
getValue Nothing y = y
getValue (Just x) y = x


-- Task 1  Maybe and lists

-- return a list containing all "success" values.
filterMaybe :: [Maybe a] -> [a]

isSuccess Nothing = False
isSuccess (Just a) = True
getValue2 (Just a) = a
filterMaybe lst = map getValue2 (filter isSuccess lst)

-- return a success containing a list of all "success" values in the input
-- if there were no failures in the input; otherwise, return a failure.
-- (Can you use foldl here?)
flattenMaybe :: [Maybe a] -> Maybe [a]

flattenMaybe lst = if and (map isSuccess lst)
                   then Just (filterMaybe lst)
                   else Nothing

flattenMaybe2 lst =
  foldl lcons (Just []) lst
  where
  lcons _ Nothing = Nothing
  lcons Nothing _ = Nothing
  lcons (Just alst) (Just b) = Just (alst ++ [b])

-- like foldl, except with Maybes. Up to you to decide what this means.
foldlMaybe :: (a -> b -> a) -> Maybe a -> [Maybe b] -> Maybe a

foldlMaybe f Nothing _ = Nothing
foldlMaybe f (Just a) lst =
  let flattened = flattenMaybe lst
  in case flattened of
    Nothing -> Nothing
    (Just blst) -> Just (foldl f a blst)


-- Task 2  Higher-order Maybe functions

-- map with Maybe. You can do this very elegantly using map and fmap.
liftMap :: (a -> b) -> [Maybe a] -> [Maybe b]
-- liftMap f lst = map (fmap f) lst
liftMap = map . fmap

-- use >>=
composeBind :: (b -> Maybe c) -> (a -> Maybe b) -> a -> Maybe c
composeBind f2 f1 a = (f1 a) >>= f2

-- applies all functions in the first argument in sequence to the second 
-- argument. Use foldl and >>= here.
allBind :: [a -> Maybe a] -> Maybe a -> Maybe a
allBind flst init = foldl (>>=) init flst
