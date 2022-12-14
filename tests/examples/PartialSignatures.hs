{-# LANGUAGE GADTs, NamedWildCards, ScopedTypeVariables #-}

bar :: Int -> _ Int
bar x = Foo True () x


addAndOr1 :: _
addAndOr1 (a, b) (c, d) = (a `plus` d, b || c)
  where plus :: Int -> Int -> Int
        x `plus` y = x + y


addAndOr2 :: _ -> _
addAndOr2 (a, b) (c, d) = (a `plus` d, b || c)
  where plus :: Int -> Int -> Int
        x `plus` y = x + y


addAndOr3 :: _ -> _ -> _
addAndOr3 (a, b) (c, d) = (a `plus` d, b || c)
  where plus :: Int -> Int -> Int
        x `plus` y = x + y


addAndOr4 :: (_ _ _) -> (_ _ _) -> (_ _ _)
addAndOr4 (a, b) (c, d) = (a `plus` d, b || c)
  where plus :: Int -> Int -> Int
        x `plus` y = x + y


addAndOr5 :: (_, _) -> (_, _) -> (_, _)
addAndOr5 (a, b) (c, d) = (a `plus` d, b || c)
  where plus :: Int -> Int -> Int
        x `plus` y = x + y


addAndOr6 :: (Int, _) -> (Bool, _) -> (_ Int Bool)
addAndOr6 (a, b) (c, d) = (a `plus` d, b || c)
  where plus :: Int -> Int -> Int
        x `plus` y = x + y


bar :: _ -> _
bar x = not x


alpha :: _
alpha = 3


bravo :: _ => _
bravo = 3


bravo :: _ => _
bravo = 3

barry :: _a -> (_b _a, _b _)
barry x = (Left "x", Right x)

foo :: a ~ Bool => (a, _)
foo = (True, False)


every :: _ -> _ -> Bool
every _ [] = True
every p (x:xs) = p x && every p xs

every :: (_a -> Bool) -> [_a] -> Bool
every _ [] = True
every p (x:xs) = p x && every p xs


bar :: Bool -> Bool
bar x = (x :: _)

bar :: _a -> _a
bar True  = (False :: _a)
bar False = (True :: _a)


arbitCs1 :: _ => a -> String
arbitCs1 x = show (succ x) ++ show (x == x)

arbitCs2 :: (Show a, _) => a -> String
arbitCs2 x = arbitCs1 x

arbitCs3 :: (Show a, Enum a, _) => a -> String
arbitCs3 x = arbitCs1 x

arbitCs4 :: (Eq a, _) => a -> String
arbitCs4 x = arbitCs1 x

arbitCs5 :: (Eq a, Enum a, Show a, _) => a -> String
arbitCs5 x = arbitCs1 x


foo :: _ => String
foo = "x"

-- No extra constraints



foo :: _ => a
foo = 3


foo :: _ => a
foo = 3

fall :: forall a . _ -> a
fall v = v

bar :: _a -> _a
bar x = not x

foo :: (forall a. [a] -> [a]) -> _
foo x = (x [True, False], x ['a', 'b'])

foo :: (forall a. [a] -> [a]) -> (_, _ _)
foo x = (x [True, False], x ['a', 'b'])


monoLoc :: forall a. a -> ((a, String), (a, _))
monoLoc x = (g True , g False)
  where
    g :: t -> (a, String)
    g _ = (x, "foo")

-- Test case for (fixed) bug that previously generated the following error message:

-- LocalDefinitionBug.hs:9:16:
--     GHC internal error: ???a??? is not in scope during type checking, but it passed the renamer
--     tcl_env of environment: [alA :-> Type variable ???_??? = _,
--                              alC :-> Identifier[x::a, <NotTopLevel>],
--                              alE :-> Type variable ???t??? = t,
--                              rjF :-> Identifier[monoLoc::a
--                                                          -> ((a, String), (a, _)), <NotTopLevel>]]
--     In the type signature for ???g???: g :: t -> (a, String)
--     In an equation for ???monoLoc???:
--         monoLoc x
--           = (g True, g False)
--           where
--               g :: t -> (a, String)
--               g _ = (x, "foo")


-- Fixed by using tcExtendTyVarEnv2 instead of tcExtendTyVarEnv

data NukeMonad a b c

instance Functor (NukeMonad a b) where
  fmap = undefined

instance Applicative (NukeMonad a b) where
  pure = undefined
  (<*>) = undefined

instance Monad (NukeMonad a b) where
  return = undefined
  (>>=) = undefined


isMeltdown :: NukeMonad param1 param2 Bool
isMeltdown = undefined

unlessMeltdown :: _nm () ->  _nm ()
unlessMeltdown c = do m <- isMeltdown
                      if m then return () else c



monoLoc :: forall a. a -> ((a, String), (a, String))
monoLoc x = (g True , g 'v')
  where
    -- g :: b -> (a, String) -- #1
    g :: b -> (a, _) -- #2
    g y = (x, "foo")

-- For #2, we should infer the same type as in #1.

foo :: (_a, b) -> (a, _b)
foo (x, y) = (x, y)


f :: (_) => a -> a -> Bool
f x y = x == y


foo :: _
Just foo = Just id


foo :: Bool -> _
Just foo = Just id

bar :: Bool -> Bool
bar (x :: _) = True


orr :: a -> a -> a
orr = undefined

g :: _
g = f `orr` True

f :: _
f = g


test3 :: _
test3 x = const (let x :: _b
                     x = True in False) $
          const (let x :: _b
                     x = 'a' in True) $
          not x


-- The named wildcards aren't scoped as the ScopedTypeVariables extension
-- isn't enabled, of which the behaviour is copied. Thus, the _a annotation of
-- x, which must be Bool, isn't the same as the _a in g, which is now
-- generalised over.
foo :: _a -> _
foo x = let v = not x
            g :: _a -> _a
            g x = x
        in (g 'x')

showTwo :: Show _a => _a -> String
showTwo x = show x


bar :: _ -> Bool
bar _ = True


data GenParser tok st a = GenParser tok st a

skipMany' :: GenParser tok st a -> GenParser tok st ()
skipMany' = undefined

skipMany :: _ -> _ ()
skipMany = skipMany'

somethingShowable :: Show _x => _x -> _
somethingShowable x = show (not x)
-- Inferred type: Bool -> String


data I a = I a
instance Functor I where
    fmap f (I a) = I (f a)

newtype B t a = B a
instance Functor (B t) where
    fmap f (B a) = B (f a)

newtype H f = H (f ())

h1 :: _ => _
-- h :: Functor m => (a -> b) -> m a -> H m
h1 f b = (H . fmap (const ())) (fmap f b)

h2 :: _
-- h2 :: Functor m => (a -> b) -> m a -> H m
h2 f b = (H . fmap (const ())) (fmap f b)

app1 :: H (B t)
app1 = h1 (H . I) (B ())

app2 :: H (B t)
app2 = h2 (H . I) (B ())


foo f = g
  where g r = x
          where x :: _
                x = r


unc :: (_ -> _ -> _) -> (_, _) -> _
unc = uncurry

unc :: (_a -> _b -> _c) -> (_a, _b) -> _c
unc = uncurry


foo :: (Show _a, _) => _a -> _
foo x = show (succ x)

bar :: _ -> _ -> _
bar x y = y x
