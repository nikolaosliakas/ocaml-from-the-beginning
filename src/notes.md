# Notes from Book
## Table of Conntents

## Making Lists
[list-properties][1]<br>
### head and tail
each list has a head and tail - _except the empty list_
A single element list ex. `[5]` has:
- head = `5` <--The element
- tail = `[]` <--The empty list

A multi-element list delimited by `;`:<br>
`[1;3;4;5]`
- head = `1` <--The first element, OCaml is left-associative.
- tail = `[3;4;5]` <--The list remaining

`::` __cons__ operator used to construct and deconstruct lists.

(construct) Add an element to a list 
```ocaml
# 1 :: [2;3;4;5];;
- : int list = [1; 2; 3; 4; 5]
```
(deconstruct) - remove head from tail.
```ocaml
let rec sum l = 
match l with
[] -> 0
| h::t -> h + sum t;;
val sum : int list -> int = <fun>
```

`@` appends a list to another list:
```ocaml
# [1;2;3] @ [4;5;6];;
- : int list = [1; 2; 3; 4; 5; 6]
```

### lists returning lists
In each `match...with` AKA `switch` in Java we return list types.
```ocaml
# let rec odd_elements l =
match l with
[] -> []
| [a] -> [a]
| a::_::t -> a :: odd_elements t;;

val odd_elements : 'a list -> 'a list = <fun>
```
An `'a` list is a α - the greek letters. This is an `any` type. 
This is why you can run the same function above with differently typed lists

```ocaml
# odd_elements ['a'; 'b'; 'c';'d';'e';'f';'g'];;
- : char list = ['a'; 'c'; 'e'; 'g']
# odd_elements [1;2;3;4;5;1;2;3;4;5];;
- : int list = [1; 3; 5; 2; 4]
```
### Appending a list without `@`
```ocaml
# let rec append a b = 
match a with
[] -> b
| h::t -> h :: append t b;;
val append : 'a list -> 'a list -> 'a list = <fun>

append [1;2;3] [3;4;5;6;7];;
- : int list = [1; 2; 3; 3; 4; 5; 6; 7]
```
Evaluation is proprotional the length first list `a` as it is being added element-by-element using the cons operator `::`

### Reversing a list
```ocaml
let rec rev l = 
    match l with
    [] -> []
    | h::t -> rev t @ [h];;
val rev : 'a list -> 'a list = <fun>

rev [1; 2; 3; 3; 4; 5; 6; 7];;
- : int list = [7; 6; 5; 4; 3; 3; 2; 1]
```

### Take and Drop
The above isn't very efficient, here is a view of the intermediate state during each recurcive call:
```shell
-> rev [1;2;3;4]
-> rev [2;3;4] @ [1]
-> (rev [3;4] @ [2]) @ [1]
-> ((rev [4] @ [3]) @ [2]) @ [1]
-> (((rev [] @ [4]) @ [3]) @ [2]) @ [1]
-> ((([] @ [4]) @ [3]) @ [2]) @ [1]
->* [4;3;2;1]
```
Takes time proportional to the list length.

__Take__
```ocaml
(*Take n number of items from l as a cons to the head of list for n-1 numbers*)
let rec take n l = 
    if n = 0 then [] else
    match l with 
    h::t -> h :: take (n-1) t;;
val take : int -> 'a list -> 'a list = <fun>
take 2 [2;4;6;8;10];;
- : int list = [2; 4]
```
__Drop__
```ocaml
(*returns tail for number of items n to drop from l*)
let rec drop n l = 
    if n = 0 then l else
    match l with
    h::t -> drop (n-1) t;;

val drop : int -> 'a list -> 'a list = <fun>

drop 2 [2;4;6;8;10];;
- : int list = [6; 8; 10]
```
## Sorting Things
[sorting-things][2]<br>

### Insertion Sort
If list is not empty, we have a head and a tail.
Sort tail - then insert head into sorted tail.
```ocaml
let rec sort l =
    match l with
        [] -> []
    |   h::t -> insert h (sort t);;    
```
Write the `insert` function

```ocaml
let rec insert x l =

    match l with
    [] -> [x]
    | h::t ->
        (*evaluate h if in correct place return the deconstructed l otherwise continue beyond h::t deconstructing recursively until you find correct place*)
        if x <= h
        then x :: h :: t
        else h :: insert x t;;
```
Combine the two above for the _inserstion sort_ algo.

```ocaml
let rec insert x l =
    match l with
        [] -> [x]
        | h::t ->
            if x <= h
            then x :: h :: t
            else h :: insert x t

let rec sort l =
    match l with
        [] -> []
        |h::t -> insert h (sort t);;

val insert : 'a -> 'a list -> 'a list = <fun>
val sort : 'a list -> 'a list = <fun>
```

__Time Complexity of Insertion Sort__
Each element may need to be inserted at the end of entire tail this means it takes time proportional to _n_. The `insert` function must be called as many times as there are elements. So _n_ * _n_ = _n^2_.

### Merge Sort

Merging two lists that are already sorted.
```ocaml
let rec merge x y =
    match x, y with
        [], l -> l
    |   l, [] -> l
    | hx::tx, hy::ty ->
        if hx < hy
            (*put hx first because it is smaller otherwise put hy first
            -- *)
            then hx :: merge tx (hy :: ty)
            else hy :: merge (hx :: tx) ty;;
val merge : 'a list -> 'a list -> 'a list = <fun>
```
Example from book on two sorted lists:
```shell
merge [9;53] [2;6;19]
->  2 :: (merge [9;53] [6;19])
->  2 :: 6 :: (merge [9;53] [19])
->  2 :: 6 :: 9 :: (merge [53] [19])
->  2 :: 6 :: 9 :: 19 :: (merge [53] [])
->  2 :: 6 :: 9 :: 19 :: [53]
->* [2; 6; 9; 19; 53]
```
How to get to Merge Sort:
Use `length` , `take` and `drop` from previous chapter to split list into two halves.

```ocaml
 let rec msort l = 
    match l with
        [] -> []
        | [x] -> [x]
        (*get right elements and left elements and sort*)
        | _ ->
            let left = take (length l/2) l in
            let right = drop (length l/2) l in
            merge (msort left) (msort right);;
val msort : 'a list -> 'a list = <fun>

msort [53; 9; 2; 6; 19];;
- : int list = [2; 6; 9; 19; 53]
```
```shell
# Top half takes logn and same for bottom 2 * logn
[6; 4; 5; 7; 2; 5; 3; 4] 
[6; 4; 5; 7][2; 5; 3; 4] # msort continues to divide with take and drop
[6; 4][5; 7][2; 5][3; 4]
[6][4][5][7][2][5][3][4]
#Merge works on each element so n
[4; 6][5; 7][2; 5][3; 4] # merge takes the head of each single element list and merges them in the cortect sorting using inequality merge function.
[4; 5; 6; 7][2; 3; 4; 5]
[2; 3; 4; 4; 5; 5; 6; 7]

# Total time complexity n * logn 
```
## Loading program from file
[running in top-level from file][3]<br>

```shell

─( 08:26:54 )─< command 0 >─────────────────────{ counter: 0 }─
utop # length [1;2;3;4];;
Error: Unbound value length
─( 08:26:54 )─< command 1 >─────────────────────{ counter: 0 }─
utop # #use "lists.ml";;
val length : 'a list -> int = <fun>
val append : 'a list -> 'a list -> 'a list = <fun>
─( 08:27:05 )─< command 2 >─────────────────────{ counter: 0 }─
utop # length [1;2;3;4];;
- : int = 4
```
## Functions upon Functions upon Functions
[anon-function][4]
### Map directly
How to apply a function to every element of a list.

```ocaml
let rec map f l =
    match l with
    [] -> []
    (* f is a function in the initial call a parameter 
    that is 'called' to each h recursively until list is exhausted*)
    | h::t -> f h :: map f t;;
val map : ('a -> 'b) -> 'a list -> 'b list = <fun>
```

Evens without map
```ocaml
let rec evensw l =
match l with
[] -> []
(*new list with bools for if modulo produces 0 or not*)
|h::t -> (h mod 2 = 0):: evensw t;;
val evensw : int list -> bool list = <fun>
```
Evens with map.
```ocaml
let rec is_even i =
    i mod 2 = 0;;
val is_even : int -> bool = <fun>
let rec map f l =
    match l with
    [] -> []
    |h::t -> f h :: map f t;;
val map : ('a -> 'b) -> 'a list -> 'b list = <fun>
(* Calling the function with a function and a list as args*)
let l = [1;2;3;4;5;6;7;8];;
val l : int list = [1; 2; 3; 4; 5; 6; 7; 8]

map is_even l;;
- : bool list = [false; true; false; true; false; true; false; true]
```
### Anonymous function

```ocaml
let evens l =
    map (fun x -> x mod 2 = 0) l;;
val evens : int list -> bool list = <fun>
```
syntax of anonymous function
```ocaml
fun <named arg> -> <function definition>

map (fun x -> x /2) [10;20;30];;
- : int list = [5; 10; 15]
```
## When Things Go Wrong
[exceptions][5]

Signalling bad arguments to user we cn use: `Invalid_argument` with a message in double-quotes.
Ex. `else raise (Invlid_argument "take")`

We can write our own exceptions using __`exception`__
```ocaml
(*Exceptions are capitalised *)
# exception Problem;;
exception Problem
(*of with exception includes type information*)
# exception NotPrime of int;;
exception NotPrime of int
(*Exceptions can be used with raise in our functions after definition*)
let f x = if x < 0 then raise Problem else 100 /x;;
val f : int -> int = <fun>

# f 20;;
- : int = 5

# f (-4);;
Exception: Problem.
```

Exceptions cn be _handled_.
```ocaml
let safe_divide x y = 
    try x/y with
    Division_by_zero -> 0;;
val safe_divide : int -> int -> int = <fun>
```
Structure is `try` {something to try} `with` {user defined or built-in exception} `->` {output on failure}

NB - the entire exception-handler must contain one and only one type.

### Handling pattern-match failures

```ocaml
let rec last l =
    match l with
        [] -> raise Not_found
    |   [x] -> x
    |   _::t -> last t;;
val last : 'a list -> 'a = <fun>
```
## Looking Things Up
[dictionaries][6]

Dictionaries and pairs
```ocaml

let p = (1,4);;
val p : int * int = (1, 4)
(*p is a pair because of the 'cross' x sign shown as an asterisk
    pronounce "int cross int" *)

 (*pairs can have mixed key and val types*)   
let q = (1, '1')
val q : int * char
(*You can extract first and second elements from the pair with simple pattern matching*)
let fst p = match p with (x, _) -> x;;
val fst : 'a * 'b -> 'a = <fun>
let snd p = match p with (_,y) -> y;;
val snd : 'a * 'b -> 'b = <fun>

(*Actually since pairs can only come in one form 'a * 'b then the pattern can be applied directly*)

let fst (x,_) = x;;
val fst : 'a * 'b -> 'a = <fun>
let snd (_,y) = y;;
val snd : 'a * 'b -> 'b = <fun>

```

### Storing a dictionary

a _list of pairs_
```ocaml
let census = [(1,4); (2,2); (3, 2); (4, 3); (5,1); (6, 2)];;
(*paranthesis around int x int*)
val census : (int * int) list =
  [(1, 4); (2, 2); (3, 2); (4, 3); (5, 1); (6, 2)]
(* if not parantheses you would have time int x int list - ie one pair*)
val y : int * int list = (1, [2;3;4]);;

```

### Operations on Dictionaries

#### Lookup a value given a key
```ocaml
let rec lookup x l =
    match l with
        [] -> raise Not_found
        (*unpacking each pair from head *)
    |   (k, v):: t -> 
        if k = x then v else lookup x t;;
val lookup : 'a -> ('a * 'b) list -> 'b = <fun>
```
#### Adding an entry
```ocaml
let rec add k v d =
match d with
    [] -> [(k,v)]
|   (k',v')::t -> 
    (* unpack k' and v' from h  ->  
    if keys are the same overwrite v' with v 
        else retain and cons pair, continuing down the tail *)
    if k = k' 
        then (k, v):: t
        else (k', v') :: add k v t;;
val add : 'a -> 'b -> ('a * 'b) list -> ('a * 'b) list = <fun>

(*Replaced value*)
add 6 2 [(4, 5); (6, 3)];;
- : (int * int) list = [(4, 5); (6, 2)]

(*Add to dict*)
add 6 2 [(4, 5); (3, 6)];;
- : (int * int) list = [(4, 5); (3, 6); (6, 2)]
```
### Removing an entry
```ocaml
let rec remove k d =
    match d with
        [] -> []
    | (k', v')::t ->
        if k = k'
            then t
            else (k', v'):: remove k t;;
(*if k exists then return t without h otherwise retain and continue*)
val remove : 'a -> ('a * 'b) list -> ('a * 'b) list = <fun>
```

### Lookup checker 
a `key exists bool checker`
```ocaml
let key_exists k d =
    try
        let _ = lookup k d in true
    with
        Not_found -> false;;
val key_exists : 'a -> ('a * 'b) list -> bool = <fun>
```

### Tuple
Pairs are actually a particular instance of a general construct the _tuple_.
Ex. `(1, false 'a')` has type __int x bool x char__

## More with functions
[in-depth-function][7]

```ocaml
let add x y = x + y
add : int -> int -> int
```
`->` is right associative so `add : int -> int -> int` can be written `add : int -> (int -> int)`

That is: 
    _In truth, the function `add` is a function which, when you give it an integer, gives you a function which, when you give it an integer, gives the sum_

__We can give a function with two arguments just one argument at a time__

```ocaml
let add x y = x + y
val add : int -> int -> int = <fun>
(*the function add has 2 parameters and one is already provided*)
let f = add 6
val f : int -> int = <fun>
(*the function f passes any arg to add*)
f 5
- : int = 11
```
__partial application__
- When defining `f` we used partial mapping
    - `f` is a function that calls `add` with 6 as an arg. The partial application is explicit in the function type `int->int`.

This is an instance of it
`map (add 6) [10;20;30]`

### Functions from operators
`( * )`

So:

    `map (fun x -> x * 2) [10;20;30]`
Can be:

    `map (( x ) 2) [10;20;30]`

```ocaml
(* Without partial app *)
let rec mapl f l =
    match l with 
    [] -> []
    | h::t -> map f h :: mapl f t;;
val mapl : ('a -> 'b) -> 'a list list -> 'b list list = <fun>
(* With partial application *)

let mapl f l = map (map f) l
(* function is provided as the partial application mapping a map*)
val mapl : ('a -> 'b) -> 'a list list -> 'b list list = <fun>

(* 3 - you can go further! as //map f// already is 'a list -> 'b list which can be supplied AGAIN to map for a lists of lists *)
let mapl f = map (map f)
val mapl : ('a -> 'b) -> 'a list list -> 'b list list = <fun>
```
### Real structure of Multiple-argument functions
```ocaml
let add x y = x + y
val add : int -> int -> int = <fun>

(* Structure visible with anonymous functions *)
let add = fun x -> fun y -> x + y
val add : int -> int -> int = <fun>
```
## Intro to types
[New Kinds of Data][8]

Use `type` to introduce new types.
Ex: `type colour = Red | Green | Blue | Yellow;`
- Four _constructors_ possible forms a value of type colour can make.

col : colour
cols : colour __list__
colpair : char x colour
```ocaml
type colour = Red | Green | Blue | Yellow;;

let col = Blue
val col : colour = Blue

let cols = [Red; Red; Green; Yellow]
val cols : colour list = [Red; Red; Green; Yellow]

let colpair = ('R', Red)
val colpair : char * colour = ('R', Red)
```

Expand colour for all RGB 255 colours
```ocaml
type colour =
  Red
| Green
| Blue
| Yellow
| RGB of int * int * int
type colour = Red | Green | Blue | Yellow | RGB of int * int * int
```
The RGB of int x int x int is still type `colour`.

We can write functions that pattern match our type:
```ocaml
let components c =
    match c with
      Red -> (255, 0, 0)
    | Green -> (0, 255, 0)
    | Blue -> (0, 0,255)
    | Yellow -> (255, 255, 0)
    | RGB (r, g, b) -> (r, g, b)
val components : colour -> int * int * int = <fun>
```

### Some type variable 'a- Polymorphism

```ocaml
# type 'a option = None | Some of 'a
type 'a option = None | Some of 'a
```
A value of type 'a option is either nothing or something of type a.

Examples:
```ocaml
let nothing = None;;
val nothing : 'a option = None

let number = Some 50;;
val number : int option = Some 50

let numbers = [Some 12; None; None; Some 2];;
val numbers : int option list = [Some 12; None; None; Some 2]

let word = Some ['c'; 'a'; 'k'; 'e'];;
val word : char list option = Some ['c'; 'a'; 'k'; 'e']
```

__The option type is useful as a more manageable alternative to exceptions where the lack of an answer is a common occurence (rather than actually exceptional)__ Like looking up a word in a dictionary me return `None`.

```ocaml
let rec lookup_opt x l =
  match l with
    [] -> None
    | (k,v)::t -> if x = k then Some v else lookup_opt x t;;
val lookup_opt : 'a -> ('a * 'b) list -> 'b option = <fun>
```

### Types defined recursively

```ocaml
type 'a sequence = Nil | Cons of 'a * 'a sequence;;
```
Two constructors:
`Nil` which is equivalent to `[]`
`Cons` which is equivalent to `::` operator.
    - Cons _carries_ two pieces of data with it 
        - the head `'a` and the tail `'a sequence`.
        - the head is a single element the tail is a seqence of `'a`.


| Built-in | Ours | Our Type |
|----------|---------------|-------|
| `[]`     | `Nil`                          |   'a sequence|
| `[1]`     | `Cons (1, Nil)`               |   int sequence|
| `['a'; 'x'; 'e']`     | `Cons ('a', Cons( 'x', Cons ('e', Nil)))` | char sequence |
| `[Red; RGB (20, 20, 20)]`     | `Cons (Red, Cons (RDG(20,20,20), Nil))`                          |   colour sequence|

The last element of a list is costly to get because it is deeper in the structure in OCaml.

```ocaml
(*Is as complete as OCaml native notation *)
let rec length_native l =
match l with
    [] -> 0
    | _::t -> 1 + length_native l;;

let rec length_func s =
match s with
    Nil -> 0
| Cons (_,t) -> 1 + length t;;

val length_native : 'a list -> int = <fun>
val length_func : 'a sequence -> int = <fun>

let rec append_native a b =
match a with
    [] -> b
    | h::t -> h :: append_native t b;;
let rec append_func a b =
match a with
Nil -> b
| Cons (h, t) -> Cons (h, append_func t b);;
val append_func : 'a sequence -> 'a sequence -> 'a sequence = <fun>
val append_native : 'a list -> 'a list -> 'a list = <fun>
```
### Typing for mathematical expression

Expression __1 + 2 x 3__
```ocaml
type expr =
Num of int
| Add of expr * expr
| Subtract of expr * expr
| Multiply of expr * expr
| Divide of expr * expr;;

Add (Num 1, Multiply (Num 2, Num 3)) (*Expresses the tree reductions *)

let rec evaluate e =
    match e with
          Num -> x
        | Add (e, e') -> evaluate e + evaluate e'
        | Subtract (e, e') -> evaluate e - evaluate e'
        | Multiply (e, e') -> evaluate e * evaluate e'
        | Divide (e, e') -> evaluate e / evaluate e';;
let rec evaluate e =
    match e with
          Num x -> x
        | Add (e, e') -> evaluate e + evaluate e'
        | Subtract (e, e') -> evaluate e - evaluate e'
        | Multiply (e, e') -> evaluate e * evaluate e'
        | Divide (e, e') -> evaluate e / evaluate e';;
val evaluate : expr -> int = <fun>
evaluate (Add (Num 1, Multiply (Num 2, Num 3))) ;;
- : int = 7
```

## Growing Trees
[Growing Trees][9]

Tree polymorphic<br>
     Br - branches hold three things in tuple:
    1. element
    2. left sub-tree 
    3. right-subtree
    OR Lf-leaf

```ocaml
type 'a tree = Br of 'a * 'a tree * 'a tree | Lf;;
```

__Calc num of elemtns in tree__
```ocaml
let rec size tr =
    match tr with
    Br (_, l, r) -> 1 + size l + size r
    | Lf -> 0;;
val size : 'a tree -> int = <fun>
```
__Add all ints in tree__
```ocaml
# let rec total tr =
    match tr with
    Br (x, l, r) -> x + total l + total r
    | Lf -> 0;;
val total : int tree -> int = <fun>

# let  my_tree = Br(2, Br(11, Lf, Lf), Br(5,Lf, Br(20, Lf, Lf)));;
val my_tree : int tree = Br (2, Br (11, Lf, Lf), Br (5, Lf, Br (20, Lf, Lf)))

# total my_tree;;
- : int = 38
```

__Calc depth of tree__
- longest path from root to leaf
```ocaml
# let max x y =
    if x > y then x else y;;
val max : 'a -> 'a -> 'a = <fun>

(*Lf = 0, When reaching a branch count 1 and add to the max of each Br we meet will add one. At each exit max will select the higher output of the function with the final branch 
looking like: -> 1 + max(Lf=0 , Lf=0)
    -> 1 + 0 *)
# let rec maxdepth tr =
    match tr with
    Br (_, l, r) -> 1 + max (maxdepth l) (maxdepth r)
    | Lf -> 0;;
val maxdepth : 'a tree -> int = <fun>

# maxdepth my_tree;;
- : int = 3
```
___Tree to List__
```ocaml
# let rec list_of_tree tr =
    match tr with
    Br(x, l, r) -> list_of_tree l @ [x] @ list_of_tree r
    | Lf -> [];;
val list_of_tree : 'a tree -> 'a list = <fun>
```
We put all elements from the left branch before x and vise versa for the right branch. Tree can be flattened other ways.

__Mapping over trees__

```ocaml
let rec tree_map f tr =
    match tr with
        (*Apply f to central branch value and then left and right branches recursion with function to each sub-branch*)
        Br(x, l, r) -> Br (f x, tree_map f l, tree_map f r)
        |Lf -> Lf;;
val tree_map : ('a -> 'b) -> 'a tree -> 'b tree = <fun>
```

### Binary Search Tree
Definiting dictionaries with trees rather than lists

Search time in dictionaries defined as list pairs
 - O(n) - proportionate to number of elements in list.
Search time in dictionaries defined as trees
 - O(logn) - log base 2 of the number of elements in the dict

 __Setup Binary Tree__
 Each branch
    - Left branches have keys less than Branch key
    - Right branches have keys greater than Branch Key
```ocaml
# let my_tree_dict = Br ((3, "three"), Br ((1, "one"), Lf, Br ((2, "two"), Lf, Lf)), Br ((4, "four"), Lf, Lf));;
(*Key int - Val string*)
val my_tree_dict : (int * string) tree =
  Br ((3, "three"), Br ((1, "one"), Lf, Br ((2, "two"), Lf, Lf)),
   Br ((4, "four"), Lf, Lf))
```
__Search when tree is balanced__
1. Start at top
2. If key is not there, go left and right based on inequality of integers (ie - go left if integer is smaller, go right if it is larger)
3. Lf = key is not in tree - raise exception.

```ocaml
let rec lookup tr k =
match tr with
Lf -> raise Not_found
| Br ( (k', v), l, r) ->
    if k = k' then v
    else if k < k' then lookup l k
    else lookup r k;;
val lookup : ('a * 'b) tree -> 'a -> 'b = <fun>
```
Same but with Option type
```ocaml
let rec lookup tr k =
match tr with
Lf -> None
| Br ( (k', v), l, r) ->
    if k = k' then Some v
    else if k < k' then lookup l k
    else lookup r k;;
val lookup : ('a * 'b) tree -> 'a -> 'b option = <fun>
(* type 'a option = Some of 'a | None; *)
```

#### Inserting into tree
```ocaml
let rec insert tr k v =
    match tr with
        Lf -> Br ((k, v), Lf, Lf)
      | Br((k', v'), l, r) -> 
            if k' = k then Br ((k, v), l, r)
            else if k < k' then Br ((k', v'), insert l k v, r)
            else Br ((k', v'), l, insert r k v);;

val insert : ('a * 'b) tree -> 'a -> 'b -> ('a * 'b) tree = <fun>

(*Before insertion*)
# let my_tree_dict = Br ((3, "three"), Br ((1, "one"), Lf, Br ((2, "two"), Lf, Lf)), Br ((4, "four"), Lf, Lf));;

(*After insertion*)
# insert my_tree_dict 30 "thirty";;
- : (int * string) tree =
Br ((3, "three"), Br ((1, "one"), Lf, Br ((2, "two"), Lf, Lf)),
 Br ((4, "four"), 
        Lf, 
        Br ((30, "thirty"), Lf, Lf)
    ))
```

## In and Out
[IO stuff][10]

"Interactivity turns out to be suprisingly hard to reason about, since the result of a function may not longer depend only on its initial argument."

### Writing to the screen

```ocaml
# print_int 100;;
100- : unit = ()
``` 
Prints an integer to the screen.
Returns nothing called a __unit__ `()`
Type of the function about is __int -> unit__
`print_string` has type __string ->  unit__
`print_newline` has type __unit -> unit__ It takes no value UNIT and produces not useful result. AKA side-effect!

__Side Effects__
- multiple side effects can be produced with `;`
- `;` evaluates everything to the left and throws the result (usually a unit) then evaluating everything on the right
- `;` is a bit like an operator.

```ocaml
let print_dict_entry (k, v) =
    print_int k ; print_newline () ; print_string v ; print_newline ()
val print_dict_entry : int * string -> unit = <fun>

print_dict_entry (1, "one");;
1
one
- : unit = ()
```

__Printing a dict__
```ocaml
let rec iter f l =
    match l with
    [] -> ()
    | h::t -> f h; iter f t;;
val iter : ('a -> 'b) -> 'a list -> unit = <fun>
(*'b will be unit!
    do this then move on discarding the result
*)

# let print_dict = 
iter print_dict_entry;;
val print_dict : (int * string) list -> unit = <fun>
```

```ocaml
print_dict [(1, "one");(2,"two");(3, "three")];;
1
one
2
two
3
three
- : unit = ()
```

### Reading from the keyboard
`read_int` type __unit -> int__
`read_line` type __unit -> string__

Wait for typing then `Enter` key to read in.
```ocaml
# read_line ();;
    Hello World from utop!
- : string = "Hello World from utop!"
```

A series of integers and strings 1 per line
```ocaml
# let rec read_dict () =
    let i = read_int () in
        if i = 0 then [] else
            let name = read_line () in
             (i, name) :: read_dict ();;
val read_dict : unit -> (int * string) list = <fun>

(*Execution *)
# read_dict ();;
1
Germany
2
Japan
3
France
4
Uzbekistan
0
- : (int * string) list =
[(1, "Germany"); (2, "Japan"); (3, "France"); (4, "Uzbekistan")]

read_dict ();;
f
Exception: Failure "int_of_string".
```

Handling failure
```ocaml
# let rec read_dict () =
  try
    let i = read_int () in
        if i = 0 then [] else
            let name = read_line () in
             (i, name) :: read_dict ()
  with
    Failure _ ->
    print_string "This is not a valid integer. Please try again." ;
    print_newline ();
    read_dict ();;
```
### Using files
__in_channel__ - places to read from
__out_channel__ - places to write to

```ocaml
(* Function to writing a dictionary of type (int*string) *)
let entry_to_channel ch (k, v) =
    output_string ch (string_of_int k); (*There is no output_int function*)
    output_char ch '\n';(*No output_newline so using line escape char*)
    output_string ch v;
    output_char ch '\n';;
val entry_to_channel : out_channel -> int * string -> unit = <fun>

let dictionary_to_channel ch d =
    iter (entry_to_channel ch) d;;
val dictionary_to_channel : out_channel -> (int * string) list -> unit = <fun>

dictionary_to_file "file.txt" (read_dict ());;
1
hello
2
goodbye
0
- : unit = ()
```

2-stage file write. First file open with `open_out` and then file close with `close_out` after contents is written.

```ocaml
let dictionary_to_file filename dict =
    let ch = open_out filename in
        dictionary_to_channel ch dict;
        close_out ch;;
val dictionary_to_file : string -> (int * string) list -> unit = <fun>
```

__Reading Files__
```ocaml
let entry_of_channel ch =
    let number = input_line ch in
        let name = input_line ch in
            (int_of_string number, name);;
val entry_of_channel : in_channel -> int * string = <fun>

let rec dictionary_of_channel ch =
    try
        let e = entry_of_channel ch in
            e :: dictionary_of_channel ch
    with
        End_of_file -> [];;
val dictionary_of_channel : in_channel -> (int * string) list = <fun>

let dictionary_of_file filename =
    let ch = open_in filename in
        let dict = dictionary_of_channel ch in
            close_in ch;
            dict;;
val dictionary_of_file : string -> (int * string) list = <fun>

# dictionary_of_file "file.txt";;
- : (int * string) list = [(1, "hello"); (2, "goodbye")]
```
List of all the functions used at end of file.

## Putting Things in Boxes
[Boxed Types][11]

"When we assigned a value to a name, that value could never change. Sometimes, it is convenient to allow the value of a name to be changed - some algorithms are more naturally expressed that way.
OCaml provides a construct known as a _reference_ which is a box in which we can store a value.

```ocaml
(*ref - built-in function to build references*)
ref has type  'a -> 'a ref;;

(*Example reference with inital contents 0 and type int ref*)
# let x = ref 0;;
val x : int ref = {contents = 0}
(*EXTRACTING the current contents of a 
reference uses ! *)
let p = !x;;
val p : int = 0
(*UPDATING the current contents of the 
reference uses := *)
x := 50;;
- : unit = ()
# x;;
- : int ref = {contents = 50}
```
The `:=` oprator has type __'a ref -> 'a -> unit__.
It takes a reference and a new value to put into it, buts the value in. It returns nothing. _Only useful for its side-effect_.

```ocaml
# p;;
- : int = 0
(*p is unchanged even as the value was extracted from x, and x has changed*)

(*function to swap the contents of two references*)
let swap a b =
    (*extract the CONTENTS of a not the reference type of a*)
    let t = !a in
        (*t is needed as an intermediary as after this point
        a == b, so how would b receive a's content without t storage?*)
        a := !b; b := t;;
val swap : 'a ref -> 'a ref -> unit = <fun>
```

### Ternary Operations
`if x = 0 then a := 0 else ()`<br>
can be<br>
`if x = 0 then a := 0`

if there is an `else` statement we put brackets around the `if ... then` imperative like so:

```ocaml
if x = y then
    (a := !a + 1;
     b := !b - 1)
else
    c := !c + 1;;
```

This is equivalent to:
```ocaml
if x = y then
    begin
        a := !a + 1;
        b := !b - 1
    end
else
    c := !c + 1;;
```
### For Loop

`for ... = ... to ... do ... done;;`
`for x = 1 to 5 do print_int x ; print_newline () done;;`
<br>This whole expression of the for loop is __unit__ irrespective of the expression(s) within it. This is the same with while loops.

### While Loop
`while ... do ... done`
```ocaml
let smallest_pow2 x =
    let t = ref 1 in
        while !t < x do
            t := !t * 2
        done;
        !t;;
val smallest_pow2 : int -> int = <fun>

# smallest_pow2 10;;
- : int = 16
```

### Example: text file statistics

Count the number of words, sentences and lines in a text file. 

Opening paragraph of 'Metamorphosis'.

The below is saved in `~/data/gregor.txt`.

```text
One morning, when Gregor Samsa woke from troubled dreams, he found\n himself transformed in his bed into a horrible vermin. He lay on\n his armour-like back, and if he lifted his head a little he could\n see his brown bellw, slightly domed and divided by arches into stiff\n sections. The bedding was hardly able to cover it and seemed ready\n to slide off any moment. His many legs, pitifully thin compared\n with the size of the rest of him, waved about helplessly as he \nlooked.
```
1. Write function that counts lines.

```ocaml
let channel_statistics in_channel = 
    (*value of 0 to lines*)
  let lines = ref 0 in
    try
      (*true as while loop will run forever. Most txt files
      end, so the end_of_file exception will eventually be thrown.*)
      while true do
        (*increment by 1 each line variable is not exception End_of_file*)
        let line = input_line in_channel in
          lines := !lines + 1
      done
    with
      End_of_file ->
        print_string "There were ";
        print_int !lines;
        print_string " lines.";
        print_newline ();;
val channel_statistics : in_channel -> unit = <fun>
```
2. Write a function to read in name of channel and execute channel stat function.
```ocaml
let file_statistics name =
  let channel = open_in name in
    try
      channel_statistics channel;
      close_in channel
    with
      _ -> close_in channel
val file_statistics : string -> unit = <fun>
```
3. Counting number of words, characters, and sentences. Naive approach: n of words == n of spaces, n of sentences are match char with '.' | '!' | '?'. 

```ocaml
let channel_statistics in_channel = 
  let lines = ref 0 in
  (*Add and initialise variables*)
  let characters = ref 0 in
  let words = ref 0 in
  let sentences = ref 0 in

    try
      while true do
        let line = input_line in_channel in
          lines := !lines + 1;
        (* apply String.length to line string*)
        characters := !characters + String.length line;
        (*Iterate over each char using String.iter
            apply anonymous function to each c 
            - anon_func increment sentences or words with naive definition of words/sentences*)
        String.iter
            (fun c ->
              match c with
                '.' | '?' | '!' -> sentences := !sentences + 1
                | ' ' -> words := !words + 1
                | _ -> ())
            line
      done
    with
      End_of_file ->
        print_string "There were ";
        print_int !lines;
        print_string " lines, making up ";
        print_int !characters;
        print_string " characters with ";
        print_int !words;
        print_string " words in ";
        print_int !sentences;
        print_string " sentences.";
        print_newline ();;
val channel_statistics : in_channel -> unit = <fun>
```
```shell
file_statistics "data/gregor.txt";;
There were 8 lines, making up 461 characters with 78 words in 4 sentences.
- : unit = ()
```

### OCaml Arrays
Array definition: place to store a fixed number of elements of like type.<br>
Arrays are introduced with `[|` and `|]`, elements seperated by semicolons.<br>

```ocaml
let a = [|1;2;3;4;5|];;
val a : int array = [|1; 2; 3; 4; 5|]
```
Accessing elements in _constant time_ can use subscript with position.

```ocaml
# a.(3);;
- : int = 4
```
Updating Array:

```ocaml
# a.(3) <- 123;;
- : unit = ()
# a;;
- : int array = [|1; 2; 3; 123; 5|]
```
Index out of bounds if access or update index not in bounds
```ocaml
# a.(6) <-123;;
Exception: Invalid_argument "index out of bounds".
```
#### Functions of Arrays
```ocaml
# Array.length a;;
- : int = 5
```
Making an array
```ocaml
(*2 args for Array.make
    arg1 - integer array len
    arg2 - 'a polymorphic value to copy across*)
    - : int -> 'a -> 'a array = <fun>

# Array.make 10 false;;
- : bool array =
[|false; false; false; false; false; false; false; false; false; false|]

# Array.make 3 (Array.make 5 'F');;
- : char array array =
[|[|'F'; 'F'; 'F'; 'F'; 'F'|]; [|'F'; 'F'; 'F'; 'F'; 'F'|];
  [|'F'; 'F'; 'F'; 'F'; 'F'|]|]
```
### Example: histogram with Arrays!

Build a histogram count number of each sort of character.<br>
ASCII code char -> int encoding
<br> `int_of_char` or `char_of_int` to convert between.
0 to 255

<br> We will store our histogram as integer array of len 256.


## The Other Numbers
[Non-Integer Numbers][12]

```ocaml
# 1.5;;
- : float = 1.5
# 6.;;
- : float = 6.
# -.2.3452;;
- : float = -2.3452
# -2.34;;
- : float = -2.34
# 1.0 +. 2.5 *. 3.0;;
- : float = 8.5
# 1.0 + 2.5 *. 3.0;;
(*Error: This expression has type float but an expression was expected of type
         intd*)
# 1.0 /. 1000.0;;
- : float = 0.001
# 1. /. 100000.;;
- : float = 1e-05
# 3000. ** 10.;;
- : float = 5.9049e+34
# 3.123 -. 3.;;
- : float = 0.12300000000000022
# max_float;;
- : float = 1.79769313486231571e+308
# min_float;;
- : float = 2.22507385850720138e-308
```

### standard funcs for floats

|Function|Type|Description|
|---------|-----|-----------|
|`sqrt` | __float -> float__| Square root.|
|`log` | __float -> float__| Natural log.|
|`log10` | __float -> float__| log based ten.|
|`sin` | __float -> float__| sin of an angle given in radians.|
|`cos` | __float -> float__| cos of an angle given in radians.|
|`tan` | __float -> float__| tan of an angle given in radians.|
|`atan` | __float -> float__| arctangent of an angle given in radians.|
|`ceil` | __float -> float__| calc nearest whole number at least as big as a floating-point number.|
|`floor` | __float -> float__| calc nearest whole number at least as small as a floating-point number.|
|`float_of_int` | __int -> float__| convert integer to float.|
|`int_of_float` | __float -> int__| convert float to integer.|
|`print_float` | __float -> unit__| print.|

<br>

### Functions with floating points
Operations on vectors in two dimensions.
<br> Each point as a pair of floating-point numbers of type __float x float__ such as `(2.0, 3.0)`. Vectors will be represented as points as well.

1. Func to build vector from one point to another
```ocaml
let make_vector (x0, y0) (x1, y1) =
    (x1 -. x0, y1 - y0)
```
2. Func to find the length of a vector
```ocaml
let vector_length (x,y) =
    sqrt (x *. x +. y *. y)
```
3. Func to offset a point by a vector
```ocaml
let offset_point (x, y) (px, py)=
    (px +. x, py +. y)
```
4. Func to scale a vector a vector to a given length
```ocaml
let scale_to_length l (a, b)=
    let currentlength = vector_length (a, b) in
        if currentlength = 0 then (a, b) else
            let factor = l /. currentlength in
                (a *. factor, b *. factor)
```



<!-- Links --->
[1]:https://johnwhitington.net/ocamlfromtheverybeginning/split07.html
[2]:https://johnwhitington.net/ocamlfromtheverybeginning/split09.html
[3]:https://johnwhitington.net/ocamlfromtheverybeginning/split10.html
[4]:https://johnwhitington.net/ocamlfromtheverybeginning/split11.html
[5]:https://johnwhitington.net/ocamlfromtheverybeginning/split12.html
[6]:https://johnwhitington.net/ocamlfromtheverybeginning/split13.html
[7]:https://johnwhitington.net/ocamlfromtheverybeginning/split14.html
[8]:https://johnwhitington.net/ocamlfromtheverybeginning/split15.html
[9]:https://johnwhitington.net/ocamlfromtheverybeginning/split16.html
[10]:https://johnwhitington.net/ocamlfromtheverybeginning/split17.html
[11]:https://johnwhitington.net/ocamlfromtheverybeginning/split18.html
[12]:https://johnwhitington.net/ocamlfromtheverybeginning/split19.html