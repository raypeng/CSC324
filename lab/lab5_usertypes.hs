{- Lab 5: User-defined types -}

data Point = MyPoint Float Float
-- data Point = MyPoint Float Float deriving Show
-- data Point = Point Float Float deriving Show


-- Question 3: Defining points
p1 :: Point
p1 = MyPoint 2.5 4
p2 :: Point
p2 = MyPoint 1.1 0.2

-- |Compute the distance between two points.
distance :: Point -> Point -> Float
distance (MyPoint x1 y1) (MyPoint x2 y2) =
    let dx = x1 - x2
        dy = y1 - y2
    in  sqrt ((dx*dx) + (dy*dy))


-- Question 4: Functions on points

-- |Returns a new point with coordinates of input point shifted
-- according to the given xshift and yshift.
translate :: Point -> Float -> Float -> Point
translate (MyPoint x y) xshift yshift = MyPoint (x + xshift) (y + yshift)

-- |Returns a string representation of the input point. 
-- The format should be "(3.2, 4.1)".
-- HINT: use the "show" function to turn a Float into a String
toString :: Point -> [Char]
toString (MyPoint x y) = "(" ++ show x ++ ", " ++ show y ++ ")"

-- |Returns True if the two points are equal, and False otherwise.
equal :: Point -> Point -> Bool
equal (MyPoint x1 y1) (MyPoint x2 y2) = (x1 == x2) && (y1 == y2)


-- Question 5: Introduction to typeclasses

-- class Eq a where
--   (==) :: a -> a -> Bool

instance Eq Point where
  (==) p1 p2 = equal p1 p2


-- Question 6: Another typeclasses
-- Make Point an instance of the Show typeclass here.

-- class Show a where
--   show :: a -> String

instance Show Point where
  show p = toString p
