-- Lab 4: Introduction to Haskell

double x = x + x

sumOfSquares x y = x*x + y*y

absVal x = if x >= 0 then x else -x

celsiusToFahrenheit x = 1.8 * x + 32

join [] = []
join (x:xs) = x ++ join xs

numCommon [] lst = 0
numCommon (x:xs) lst = if elem x lst
                       then 1 + numCommon xs lst
                       else numCommon xs lst

apply f x = f x

makeConstantFunction x = \y -> x

listReverse [] = []
listReverse (x:xs) = listReverse xs ++ [x]
