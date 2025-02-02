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
fun <named arg> -> <function definition>)

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








<!-- Links --->
[1]:https://johnwhitington.net/ocamlfromtheverybeginning/split07.html
[2]:https://johnwhitington.net/ocamlfromtheverybeginning/split09.html
[3]:https://johnwhitington.net/ocamlfromtheverybeginning/split10.html
[4]:https://johnwhitington.net/ocamlfromtheverybeginning/split11.html
[5]:https://johnwhitington.net/ocamlfromtheverybeginning/split12.html
[6]:https://johnwhitington.net/ocamlfromtheverybeginning/split13.html
