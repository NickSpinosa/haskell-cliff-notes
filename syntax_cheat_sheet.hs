--full cheat sheet https://fldit-www.cs.uni-dortmund.de/~peter/HaskellCheatSheet2.pdf

--this is a type signature and a function
examp :: String -> String
examp exampleString = exampleString

--this is the main function chain all functions to be run with do here
main = do examp "this is the main function"

--all functions are partially applied
add :: Int -> Int -> Int
add firstNumber secondNumber = firstNumber + secondNumber

addTwo :: Int -> Int
addTwo = add 2

addTwo 4 --returns 6 

--make a function infix
2 `add` 4 --returns 6

--we can make a function infix by default by using only special characters in its name 
--for example this is an implementation of the exponentiation operator
(^^) :: Int -> Int -> Int
base ^^ exponent = foldr (*) 1 (replicate exponent base) --foldr is basically reduce and replicate just makes a list of the same value
3 ^^ 2 -- 9

--LIST
--lists can only be of one type
listLiteral = [1,2,3,4]

--retrieval by index
--list are 0 indexed
two = listLiteral !! 1

--head is the first element of a list
one = head listLiteral

--tail is the subList from index 1 on
startingAtTwo = tail listLiteral --[2,3,4]

--last is the last element
four = last listLiteral

--init is the reverse tail
endingAtThree = init listLiteral --[1,2,3]

--LIST COMPREHENSIONS
doubleList = [x*2 | x <- [1..10]] --[2,4,6,8,10,12,14,16,18,20]

--with predicate
doubledGreaterThanTwelve = [x*2 | x <- [1..10], x*2 >= 12] --[12,14,16,18,20]

--multiple predicates
doubleBetweenTwelveAndSixteen = [x*2 | x <- [1..10], x*2 >= 12, x*2 <= 18]

--multiple source lists
[ x*y | x <- [2,5,10], y <- [8,10,11]]  --[16,20,22,40,50,55,80,100,110] 

--PATTERN MATCHING
--patterns are matched in order
lucky :: (Integral a) => a -> String  
lucky 7 = "LUCKY NUMBER SEVEN!"  
lucky x = "Sorry, you're out of luck, pal!"   

--nifty factorial with pattern matching
factorial :: (Integral a) => a -> a  
factorial 0 = 1  
factorial n = n * factorial (n - 1)

--guards are basically switch statements
--otherwise is the catch all
bmiTell :: (RealFloat a) => a -> String  
bmiTell bmi  
    | bmi <= 18.5 = "You're underweight, you emo, you!"  
    | bmi <= 25.0 = "You're supposedly normal. Pffft, I bet you're ugly!"  
    | bmi <= 30.0 = "You're fat! Lose some weight, fatty!"  
    | otherwise   = "You're a whale, congratulations!"  

--use where after guards to abstract an expression
bmiTell :: (RealFloat a) => a -> a -> String  
bmiTell weight height  
    | bmi <= 18.5 = "You're underweight, you emo, you!"  
    | bmi <= 25.0 = "You're supposedly normal. Pffft, I bet you're ugly!"  
    | bmi <= 30.0 = "You're fat! Lose some weight, fatty!"  
    | otherwise   = "You're a whale, congratulations!"  
    where bmi = weight / height ^ 2 

--let expression, similar to where but defined at the top of the function
--and is treated as an expression not a syntactical construct
cylinder :: (RealFloat a) => a -> a -> a  
cylinder r h = 
    let sideArea = 2 * pi * r * h  
        topArea = pi * r ^2  
    in  sideArea + 2 * topArea 

--let expressions are good for locally scoped functions 
let square x = x * x in (square 5, square 3, square 2)]  --[(25,9,4)]

--can use let expressions in list COMPREHENSIONS
calcBmis :: (RealFloat a) => [(a, a)] -> [a]  
calcBmis xs = [bmi | (w, h) <- xs, let bmi = w / h ^ 2] 

--case expressions are switch statements but can be used anywhere since they are just expressions
--basic syntax
-- case expression of pattern -> result  
--                    pattern -> result  
--                    pattern -> result  
--                    ...  

--example in the middle of an expressions
describeList :: [a] -> String  
describeList xs = "The list is " ++ case xs of [] -> "empty."  
                                               [x] -> "a singleton list."   
                                               xs -> "a longer list." 

--lamda functions
\x -> x + 3

--import syntax http://learnyouahaskell.com/modules#loading-modules
--export syntax http://learnyouahaskell.com/modules#making-our-own-modules

--FUNCTIONS APPLICATION AND COMPOSITION
--functions applied with $ are right-associative
sum (map sqrt [1..130]) == sum $ map sqrt [1..130]

--function composition is denoted with the . operator
-- . is defined as
(.) :: (b -> c) -> (a -> b) -> a -> c  
f . g = \x -> f (g x)  

--example
 map (\x -> negate (abs x)) [5,-3,-6,7,-3,2,-19,24] == map (negate . abs) [5,-3,-6,7,-3,2,-19,24]

--ADVANCED TYPES

--data keyword is for defining new types
-- the | is read as "or" and makes union types 
data Bool = True | False

--value constructors are denoted by capitalized words in a type definition
--they are functions which are used to construct a type
data Shape = Circle Float Float Float | Rectangle Float Float Float Float
--Circle and Rectangle are the value constuctors here   

--this allows you to do things like 
surface :: Shape -> Float  
surface (Circle _ _ r) = pi * r ^ 2  
surface (Rectangle x1 y1 x2 y2) = (abs $ x2 - x1) * (abs $ y2 - y1)

--we would create an instance of this type like this
circle = Circle 10 10 20
rectangle = Rectangle 0 0 5 5

--value constructors are just functions so we can partially apply them and map them etc.
map (Circle 10 20) [4,5,6,6] --[Circle 10.0 20.0 4.0,Circle 10.0 20.0 5.0,Circle 10.0 20.0 6.0,Circle 10.0 20.0 6.0]

--record are like interfaces from typescript/java
data Person = Person 
    { firstName :: String
    , lastName :: String
    , age :: Integral
    , height :: Float
    , phoneNumber :: String
    , flavor :: String
    }

--when we use record syntax to define a type haskell automagically creates functions
--  with the name of each key to retrieve their value
--this is how we use them
nick = Person {
    firstName = "Nick", 
    lastName = "Spinosa", 
    age = 22, 
    height = 5.70,
    phoneNumber = "555 555 5555"
    flavor = "coffee"
}

nickLastName = lastName nick

--type constructors are abstract types that take a type to return a new concrete type
-- (our first monad :') )
data Maybe a = Nothing | Just a

--here Maybe is a type constructor and Just is a value constructor
--for example there is no such type as Maybe but there is a Maybe Int type etc.


--Type Classes are abstractions over types that encapsulate certain common behaviors
--for example the Eq typeclass (which is part of the standard haskell library)
--defines the == and /= operators that work with any type that is an instance of the Eq typeclass
--we can use the deriving  keyword to make our custom types an instance of any typeclass that ships with Haskell
--ex
data Person = Person { firstName :: String
    , lastName :: String
    , age :: Int
    } deriving(Eq)

mike = Person { firstName = "Mike"
    , lastName = "Jones"
    , age = 25
    }

john = Person { firstName = "john"
    , lastName = "Jones"
    , age = 22
    }

mike /= john --True
--the catch is that all of the field of our custom type must also be instances of the Eq typeclass for this to work


--Type Synonyms are useful for giving more specific names to types, we usually use this to make our code more readable
--for example the String type is just a synonym for the type [Char] (list of chars)
--here is the syntax
type String = [Char]

--example
--if we define a phonebook like this, it isn't super clear what each index of the tuple represents 
phoneBook :: [(String,String)]  --the type would be a list of tuple pairs
phoneBook =      
    [("betty","555-2938")     
    ,("bonnie","452-2928")     
    ,("patsy","493-2928")     
    ,("lucille","205-2928")     
    ,("wendy","939-8282")     
    ,("penny","853-2492")     
    ]
--to make it more clear we would do this
type PhoneNumber = String  
type Name = String  
type PhoneBook = [(Name,PhoneNumber)]

--we can also parametize type synonyms to make them more general
--like this:
type AssociativeList k v = [(k,v)]

--Custom Type Classes 
--when we create a typeclass we must define the functions (or operators) that our typeclass implements
--for example here is how the Eq typeclass is defined
class Eq equatable where --don't let the class keyword fool you this isn't at all similar to an OOP class
    (==) :: equatable -> equatable -> Bool
    (/=) :: equatable -> equatable -> Bool
    x == y = not (x /= y)
    x /= y = not (x == y)

--we define the functions in terms of each other so that we only have to implement one
--when we make a type an instance of this typeclass
--like so:
data TrafficLight = Red | Yellow | Green  

instance Eq TrafficLight where  
    Red == Red = True  
    Green == Green = True  
    Yellow == Yellow = True  
    _ == _ = False --we can use a 'catch all' here because we implemented the methods in terms of each other above

--we can also make typeclasses subclasses of other typeclasses
--for example here is how Maybe is subclassed from Eq
--we use the class constraint (=>) because the type passed to Maybe must be an instance of Eq
instance (Eq m) => Eq (Maybe m) where
    Just x == Just y = x == y1
    Nothing == Nothing = True
    _ == _ = False

--all standard haskell types and type classes https://www.haskell.org/onlinereport/basic.html

