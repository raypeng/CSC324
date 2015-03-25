{- Assignment 2 - A Racket Interpreter

This module provides a very basic parser to handle file input
and parsing literals for you.

You may *not* make any changes to this file.
However, you *must* submit this file on MarkUs, so that your
program works in a standalone directory.
-}

module BaseParser
    (
      BaseExpr(LiteralInt, LiteralBool, Atom, Compound),
      parseFile
    ) where

import Text.ParserCombinators.Parsec  -- For parsing
import System.IO                      -- For File I/O
import Data.String.Utils (rstrip)

-- Data type for base expressions
data BaseExpr = LiteralInt Integer |  -- Literal integer
                LiteralBool Bool |    -- Literal boolean
                Atom String |         -- Any other string
                Compound [BaseExpr]   -- A nested (...) expression
                deriving Show


-- Take a string containing a file name, and create an IO action
-- that reads the contents of the file and creates a sequence
-- of BaseExpr trees, if the parsing succeeds.
-- Note the use of the Maybe type to encapsulate the possibility
-- of failure in parsing.
parseFile :: String -> IO (Maybe [BaseExpr])
parseFile file =
    readFile file >>= \str ->
    case parse paddle "" $ map normalizeChars str of
        Left f -> print f >> return Nothing
        Right res -> return $ Just res
    where
        paddle = manyTill expr eof

        normalizeChars '\n' = ' '
        normalizeChars '\r' = ' '
        normalizeChars '\t' = ' '
        normalizeChars '[' = '('
        normalizeChars ']' = ')'
        normalizeChars x = x


-- Parse a single expression from nested parentheses
expr :: GenParser Char st BaseExpr
expr =
    betweenWS tok <|>
    (between (betweenWS $ char '(') (betweenWS $ char ')') $
        sepBy (tok <|> expr) ws >>=
        return . Compound)
    where
        ws = many $ char ' '
        betweenWS = between ws ws


-- Parse a single token (number, boolean, or string)
tok :: GenParser Char st BaseExpr
tok =
    many1 (alphaNum <|> oneOf "+-*#?<") >>=
    return . makeName . rstrip
    where
        -- Determine whether a string represents a literal or not
        makeName "#t" = LiteralBool True
        makeName "#f" = LiteralBool False
        makeName x = let
            xs = reads x
            in case xs of
                [] -> Atom x
                [(num, _)] -> LiteralInt num
