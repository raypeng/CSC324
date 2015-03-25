{- Assignment 2 - A Racket Interpreter

This module is the main program for the interpreter.
All of your work should go into this file.

We have provided a skeleton interpreter which can be run
successfully on sample.rkt; it is your job to extend this
program to handle the full range of Paddle.

In the space below, please list your group member(s):
Rui Peng,  c5pengru
Yuan Wang, g3naiver
-}

module Interpreter (main) where

import BaseParser (BaseExpr(LiteralInt, LiteralBool, Atom, Compound), parseFile)
import Data.List
import System.Environment (getArgs)

-- import Data.String.Utils -- not allowed to import

-- |Run interpreter on an input file,
--  either from commandline or user input.
--  You should not need to change this function.
main :: IO ()
main =
    getArgs >>= \args ->
    if length args > 0
    then
        parseFile (head args) >>= \baseTree ->
        putStr (interpretPaddle baseTree)
    else
        putStrLn "Enter the name of a file: " >>
        getLine >>= \file ->
        parseFile file >>= \baseTree ->
        putStr (interpretPaddle baseTree)



-- |Take the output of the base parser and interpret it,
--  first constructing the AST, then evaluating it,
--  and finally returning string representations of the results.
--  You will need to make this function more robust against errors.
interpretPaddle :: Maybe [BaseExpr] -> String
interpretPaddle (Just exprs) =
    let asts = map parseExpr exprs
        res = my_eval_all asts
-- limit number of lines according to err type if any
--        nodefine = filter_out_nooutput res
--        vals = restrict_output nodefine
        vals = my_eval_all asts
    in
      -- String representations of each value, joined with newlines
--      unlines (map show exprs) -- show BaseExpr
--      unlines (map show asts) -- show AST
      unlines (map show vals) -- show evalutated



-- An expression data type
data Expr = Number Integer |
            Boolean Bool |

            And Expr Expr |
            Or Expr Expr |
            If Expr Expr Expr |
            Cond [Expr] |
            Pair Expr Expr |

            AddOp [Expr] |
            MulOp [Expr] |
            NotOp [Expr] |
            List [Expr] |
            Equalp [Expr] |
            LessThanOp [Expr] |
            Emptyp [Expr] |
            Car [Expr] |
            Cdr [Expr] |

            Define Expr Expr |
            Symbol [Char] |
            Lambda [Expr] Expr [Char] |
            Apply Expr [Expr] |

            Let [Expr] Expr |
            Lets [Expr] Expr |
                
            NoOutput |

            TypeError |
            SyntaxError |
            NameError


instance Show Expr where
    show (Number x) = show x
    show (Boolean True) = "#t"
    show (Boolean False) = "#f"

    show (And e1 e2) =
        "(and " ++ show e1 ++ " " ++ show e2 ++ ")"
    show (Or e1 e2) =
        "(or " ++ show e1 ++ " " ++ show e2 ++ ")"
    show (If e1 e2 e3) =
        "(if " ++ show e1 ++ " " ++ show e2 ++ " " ++ show e3 ++ ")"

    show (Cond lpair) =
        "(cond " ++ join " " (map show lpair) ++ ")"
    show (Pair e1 e2) =
        "[" ++ show e1 ++ " " ++ show e2 ++ "]"
    show (Let lpair expr) =
        "(let (" ++ join " " (map show lpair) ++ ") " ++ show expr ++ ")"
    show (Lets lpair expr) =
        "(let* (" ++ join " " (map show lpair) ++ ") " ++ show expr ++ ")"

    show (AddOp l) =
        "(+ " ++ join " " (map show l) ++ ")"
    show (MulOp l) =
        "(* " ++ join " " (map show l) ++ ")"
    show (NotOp l) =
        "(not " ++ join " " (map show l) ++ ")"
    show (Equalp l) =
        "(equal? " ++ join " " (map show l) ++ ")"
    show (LessThanOp l) =
        "(< " ++ join " " (map show l) ++ ")"
    show (List l) =
        "'(" ++ join " " (map lshow l) ++ ")"
    show (Emptyp l) =
        "(empty? " ++ join " " (map show l) ++ ")"
    show (Car l) =
        "(first " ++ join " " (map show l) ++ ")"
    show (Cdr l) =
        "(rest " ++ join " " (map show l) ++ ")"

    show (Define sym val) =
        "(define " ++ show sym ++ " " ++ show val ++ ")"
    show (Apply f args) =
        "(apply " ++ show f ++ " (" ++ join " " (map show args) ++ "))"
    show (Lambda params expr name) =
        if name == ""
        then "#<procedure>"
        else "#<procedure:" ++ name ++ ">"

    show (Symbol sym) =
        sym

    show NoOutput =
        "NoOutput"

    show TypeError =
        "TypeError"
    show SyntaxError =
        "SyntaxError"
    show NameError =
        "NameError"


-- special case of show list with '(() (1 2)) instead of '('() '(1 2))
lshow (List l) = "(" ++ join " " (map lshow l) ++ ")"
lshow others = show others
    


-- |Take a base tree produced by the starter code,
--  and transform it into a proper AST.
parseExpr :: BaseExpr -> Expr

parseExpr (LiteralInt n) = Number n
parseExpr (LiteralBool b) = Boolean b

parseExpr (Compound [Atom "and", x, y]) =
    And (parseExpr x) (parseExpr y)
parseExpr (Compound [Atom "or", x, y]) =
    Or (parseExpr x) (parseExpr y)
parseExpr (Compound [Atom "if", b, x, y]) =
    If (parseExpr b) (parseExpr x) (parseExpr y)
parseExpr (Compound (Atom "cond" : l)) =
    parseCond l

parseExpr (Compound (Atom "+" : l)) =
    AddOp (map parseExpr l)
parseExpr (Compound (Atom "*" : l)) =
    MulOp (map parseExpr l)
parseExpr (Compound (Atom "not" : l)) =
    NotOp (map parseExpr l)
parseExpr (Compound (Atom "list" : l)) =
    List (map parseExpr l)
parseExpr (Compound (Atom "equal?" : l)) =
    Equalp (map parseExpr l)
parseExpr (Compound (Atom "<" : l)) =
    LessThanOp (map parseExpr l)
parseExpr (Compound (Atom "empty?" : l)) =
    Emptyp (map parseExpr l)
parseExpr (Compound (Atom "first" : l)) =
    Car (map parseExpr l)
parseExpr (Compound (Atom "rest" : l)) =
    Cdr (map parseExpr l)

parseExpr (Compound [Atom "define", Atom sym, val]) =
    case (parseExpr val) of
      Lambda lvar expr "" ->
          Define (Symbol sym) (Lambda lvar expr sym)
      valid_val ->
          Define (Symbol sym) valid_val
parseExpr (Compound [Atom "define", Compound (Atom sym : params), expr]) =
    let val = Compound [Atom "lambda", Compound params, expr]
    in case (parseExpr val) of
         Lambda lvar expr "" ->
             Define (Symbol sym) (Lambda lvar expr sym)
         _ -> SyntaxError -- actually never happens

parseExpr (Compound [Atom "lambda", Compound params, expr]) =
    Lambda (map parseExpr params) (parseExpr expr) ""
parseExpr (Compound ((Compound [Atom "lambda", params, expr]) : args)) =
    let lambda = parseExpr (Compound [Atom "lambda", params, expr])
    in case lambda of
         Lambda _ _ _ -> Apply lambda (map parseExpr args)
         _ -> SyntaxError

parseExpr (Compound [Atom "let", Compound binds, expr]) =
    Let (map parseLet binds) (parseExpr expr)
parseExpr (Compound [Atom "let*", Compound binds, expr]) =
    Lets (map parseLet binds) (parseExpr expr)

parseExpr (Atom sym) =
    Symbol sym

parseExpr (Compound (Atom f : args)) =
    if elem f ["+", "*", "not", "equal?", "<", "list", "empty?", "first",
               "rest", "and", "or", "if", "cond", "let", "let*", "lambda",
               "define", "else"]
    then SyntaxError
    else Apply (Symbol f) (map parseExpr args)

parseExpr _ =
    SyntaxError


-- need to raise syntax error unless
-- one and only one else, as last cond
parseCond l =
    case l of
      [] -> SyntaxError
      lexpr ->
          let len = length lexpr
          in
            check_cond ((map parseCondBase (take (len - 1) lexpr)) ++
                        [parseCondLast (last lexpr)])
              
parseCondLast (Compound [Atom "else", x]) =
    Pair (Boolean True) (parseExpr x)
parseCondLast _ =
    SyntaxError

parseCondBase (Compound [Atom "else", x]) =
    SyntaxError
parseCondBase (Compound [x, y]) =
    Pair (parseExpr x) (parseExpr y)
parseCondBase _ =
    SyntaxError

parseLet (Compound [Atom x, y]) =
    Pair (Symbol x) (parseExpr y)
parseLet _ =
    SyntaxError

is_syntax_error e =
    case e of
      SyntaxError -> True
      _ -> False
is_name_error e =
    case e of
      NameError -> True
      _ -> False
is_type_error e =
    case e of
      TypeError -> True
      _ -> False
is_any_error e = is_syntax_error e ||
                 is_name_error e ||
                 is_type_error e

check_cond :: [Expr] -> Expr -- Cond [Expr] | SyntaxError
check_cond lexpr =
    case (find is_syntax_error lexpr) of
      Just _ -> SyntaxError
      Nothing -> Cond lexpr



-- symbol table type
-- closer to head, closer to local scope
type STE = ([Char], Expr)
type ST = [STE]

-- insert new local binding to head of ST
lambda_bind :: ST -> STE -> ST 
lambda_bind t (sym, val) = (sym, val) : t

-- insert new top level bidings
define_bind :: ST -> STE -> Maybe ST
define_bind t (sym, val) =
    if elem sym ["+", "*", "not", "equal?", "<", "list", "empty?", "first",
                 "rest", "and", "or", "if", "cond", "let", "let*", "lambda",
                 "define", "else"]
    then Nothing
    else case (find_bind t sym) of
           Nothing -> Just ((sym, val) : t)
           Just _ -> Nothing

-- find binding to sym in ST
find_bind :: ST -> [Char] -> Maybe STE
find_bind [] _ = Nothing
find_bind ((k, v) : xs) key =
    if k == key
    then Just (k, v)
    else find_bind xs key

-- prepare SymbolTable, accumulate all define clauses
-- must have error handling here!
st_prep :: [Expr] -> ST
st_prep [] = []
st_prep (e:es) =
    let st = st_prep es
    in case e of
         Define (Symbol var) val ->
             if elem var ["+", "*", "not", "equal?", "<", "list", "empty?",
                          "first", "rest", "and", "or", "if", "cond", "let",
                          "let*", "lambda", "define", "else"]
             then st
             else
                 case (find_bind st var) of
                   Just _ -> st -- duplicate def
                   Nothing ->
                       let evaled = evaluate val st
                       in
                         if is_any_error evaled
                         then st
                         else (var, evaled) : st
         _ -> st

-- generate all asts as input to st_prep
sublists asts =
    let len = length asts
        range = [0 .. (len - 1)]
    in
      map (\n -> take n asts) range

-- middle man
my_eval (a, b) = evaluate a b

-- use asts up to a point to build up st, use (ast, st) to eval
my_eval_all asts =
    let asts_in = sublists asts
        st_list = map (st_prep . reverse) asts_in
        ast_st_tups = zip asts st_list
    in
      map my_eval ast_st_tups

-- filter out all NoOutput
filter_out_nooutput vals =
    filter (\v -> case v of
                    NoOutput -> False
                    _ -> True)
           vals

-- restrict output lines according to errors occurred
restrict_output vals =
    case (find is_syntax_error vals) of
      Just _ -> [SyntaxError]
      Nothing ->
          case (find is_name_error vals) of
            Just _ -> [NameError]
            Nothing ->
                case (findIndex is_type_error vals) of
                  Just n -> take (n + 1) vals
                  Nothing -> vals



-- |Evaluate an AST by simplifying it into
--  a number, boolean, list, or function value.
evaluate :: Expr -> ST -> Expr
evaluate (Number n) t = Number n
evaluate (Boolean b) t = Boolean b

evaluate (List l) t =
    let lexpr = map (\e -> evaluate e t) l
    in case (filter is_any_error lexpr) of
         [] -> List lexpr
         errs -> throw errs

evaluate (And x y) t =
    case (evaluate x t, evaluate y t) of
      (Boolean xx, Boolean yy) -> Boolean (xx && yy)
      (a, b) -> throw [a, b]

evaluate (Or x y) t =
    case (evaluate x t, evaluate y t) of
      (Boolean xx, Boolean yy) -> Boolean (xx || yy)
      (a, b) -> throw [a, b]

evaluate (If cond x y) t =
    case (evaluate cond t) of
      Boolean True -> evaluate x t
      Boolean False -> evaluate y t
      err -> throw [err]

evaluate (Cond lpair) t =
    let conds = map (\p -> cond_of p t) lpair
        execs = map (\p -> exec_of p t) lpair
    in case (filter is_any_error (conds ++ execs)) of
         [] ->
             let i = first_true_index conds
             in case i of
                  Number idx -> evaluate (execs !! (fromInteger idx)) t
                  err -> throw [err]
         errs -> throw errs

evaluate (AddOp l) t =
    case (map (\e -> evaluate e t) l) of
      [Number xx, Number yy] -> Number (xx + yy)
      err -> throw err

evaluate (MulOp l) t =
    case (map (\e -> evaluate e t) l) of
      [Number xx, Number yy] -> Number (xx * yy)
      err -> throw err

evaluate (NotOp l) t =
    case (map (\e -> evaluate e t) l) of
      [Boolean xx] -> Boolean (not xx)
      err -> throw err

evaluate (Equalp l) t =
    case (map (\e -> evaluate e t) l) of
      [Boolean a, Boolean b] -> Boolean (a == b)
      [Number a, Number b] -> Boolean (a == b)
      [List a, List b] -> list_equal (List a) (List b) t
      err -> throw err

evaluate (LessThanOp l) t =
    case (map (\e -> evaluate e t) l) of
      [Number xx, Number yy] -> Boolean (xx < yy)
      err -> throw err

evaluate (Emptyp l) t =
    case (map (\e -> evaluate e t) l) of
      [List []] -> Boolean True
      [List _] -> Boolean False
      err -> throw err

evaluate (Car l) t =
    case (map (\e -> evaluate e t) l) of
      [List []] -> TypeError
      [List (x:xs)] -> x
      err -> throw err

evaluate (Cdr l) t =
    case (map (\e -> evaluate e t) l) of
      [List []] -> TypeError
      [List (x:xs)] -> List xs
      err -> throw err

evaluate (Define (Symbol sym) val) t =
    if elem sym ["+", "*", "not", "equal?", "<", "list", "empty?",
                 "first", "rest", "and", "or", "if", "cond", "let",
                 "let*", "lambda", "define", "else"]
    then NameError -- reserved keywords
    else
        case (find_bind t sym) of
          Just _ -> NameError -- duplicate def
          Nothing ->
              let evaled = evaluate val t
              in
                if is_any_error evaled
                then evaled -- now evaled is err itself
                else NoOutput

-- 1) (lambda (x) (+ a x)) need to find binding for a
-- do trick of assigning lvar to 1, check if NameError
-- since NameError will shadow other TypeError
-- TODO
-- 2) need to replace a with its binded val
-- in order to enforce lexical scoping
evaluate (Lambda lvar expr name) t =
    let tt = (name, Number 1) : -- deal with recursive definition
             ((map (\s -> case s of
                           Symbol ss -> (ss, Number 1))
               lvar) ++ t)
    in case (evaluate expr tt) of
         NameError -> NameError
         SyntaxError -> SyntaxError
         _ -> Lambda lvar expr name

evaluate (Apply (Symbol sym) args) t =
    let f = evaluate (Symbol sym) t
    in case f of
      Lambda lvar expr _ -> evaluate (Apply f args) t
      NameError -> NameError
      _ -> TypeError

evaluate (Apply (Lambda lvar expr _) args) t =
    let eargs = map (\e -> evaluate e t) args
    in case (filter is_any_error eargs) of
         [] ->
             if length lvar /= length eargs
             then TypeError
             else
                 let binds = map (\tup -> case tup of
                                            (k, v) -> Pair k v)
                             (zip lvar eargs)
                     exec = Let binds expr
                 in
                   evaluate exec t
         errs -> throw errs

evaluate (Symbol x) t =
    case (find_bind t x) of
      Just (_, val) -> val
      Nothing ->
          if elem x ["+", "*", "not", "equal?", "<", "list", "empty?",
                     "first", "rest"]
          then Lambda [] (Number 1) x -- just for the sake of printing lambda
          else NameError

evaluate (Let binds expr) t =
    case (bind_let binds t) of
      (st, Nothing) -> evaluate expr st
      (_, Just err) -> err

evaluate (Lets binds expr) t =
    case (bind_lets binds t) of
      (st, Nothing) -> evaluate expr st
      (_, Just err) -> err

evaluate TypeError t = TypeError
evaluate SyntaxError t = SyntaxError
evaluate NameError t = NameError


-- default error is type error
throw :: [Expr] -> Expr
throw l =
    case (find is_syntax_error l) of
      Just _ -> SyntaxError
      Nothing ->
          case (find is_name_error l) of
            Just _ -> NameError
            Nothing -> TypeError


-- helpers for eval Cond
cond_of :: Expr -> ST -> Expr -- Boolean | Error
cond_of (Pair c e) t =
    case (evaluate c t) of
      Boolean cc -> Boolean cc
      err -> throw [err]

exec_of :: Expr -> ST -> Expr -- Boolean | Error
exec_of (Pair c e) t = e

first_true_index :: [Expr] -> Expr -- Number idx | Error
first_true_index [] = Number 0
first_true_index (x:xs) =
    case x of
      Boolean True -> Number 0
      Boolean False -> Number 1 !+ first_true_index xs
      err -> throw [err]

-- !+ lifted add
(Number x) !+ NameError = NameError
(Number x) !+ SyntaxError = SyntaxError
(Number x) !+ TypeError = TypeError
(Number x) !+ (Number y) = Number (x + y)


-- helpers for equal? for list
-- actual work done by leq
leq :: [Expr] -> [Expr] -> ST -> Expr -- Boolean | Error
leq [] [] t = Boolean True
-- need to raise type error
leq (a:as) (b:bs) t =
    case (evaluate (Equalp [a, b]) t) of
      Boolean x -> (Boolean x) !& leq as bs t
      err -> throw [err]

-- need to raise type error
list_equal :: Expr -> Expr -> ST -> Expr -- Boolean | Error
list_equal (List la) (List lb) t =
    let lena = length la
        lenb = length lb
    in
      if lena == lenb
      then leq la lb t
      else Boolean False

-- !& lifted and
(Boolean x) !& NameError = NameError
(Boolean x) !& SyntaxError = SyntaxError
(Boolean x) !& TypeError = TypeError
(Boolean x) !& (Boolean y) = Boolean (x && y)


-- helpers for let
-- return (new st, if binds can succeed in let)
bind_let :: [Expr] -> ST -> (ST, Maybe Expr) -- Nothing | Just Error
bind_let lpair t =
    let vals = map (\p -> case p of
                            Pair (Symbol sym) val -> evaluate val t
                            _ -> SyntaxError)
               lpair
        syms = map (\p -> case p of
                            Pair (Symbol sym) val -> sym
                            _ -> "") -- use "" to trap illegal vars
               lpair
    in case (find (\s -> s == "") syms) of
         Just _ -> ([], Just SyntaxError)
         Nothing ->
             case (filter is_any_error vals) of
               [] -> (((zip syms vals) ++ t), Nothing)
               errs -> ([], Just (throw errs))

-- return (new st, if binds can succeed in let)
bind_lets :: [Expr] -> ST -> (ST, Maybe Expr) -- Nothing | Error
bind_lets [] t = (t, Nothing)
bind_lets ((Pair (Symbol sym) val) : ps) t =
    let evaled = evaluate val t
    in
      if is_any_error evaled
      then ([], Just evaled) -- now evaled is err itself
      else bind_lets ps ((sym, evaled) : t)
bind_lets (_:ps) t = ([], Just SyntaxError) -- deal with [(+ 1 2) 2]



-- can't use join in Data.String.Utils
-- build my own wheel :O
join :: [Char] -> [[Char]] -> [Char]
join sep [] = ""
join sep [s] = s
join sep (x:xs) = x ++ sep ++ join sep xs
