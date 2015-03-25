import Data.Maybe (fromJust)

data SExpr
    = SVar String
    | SLam String SExpr
    | SApp SExpr SExpr
    | SIntConst Integer

data Expr
    = Lam (Expr -> Expr)
    | App Expr Expr
    | IntConst Integer

translate :: [(String, Expr)] -> SExpr -> Expr
translate env (SVar x) = fromJust (lookup x env)
translate env (SLam name x) = Lam (\x' -> translate ((name, x') : env) x)
translate env (SApp f x) = App (translate env f) (translate env x)
translate env (SIntConst x) = IntConst x

eval :: Expr -> Expr
eval (App (Lam f) x) = eval (f (eval x))
eval x = x

