# Questions from OCaml From the Beginning

## Making Lists
[list-properties][1]<br>

1. Write a function evens which does the opposite to odds, returning the even numbered elements in a list. For example, evens [2; 4; 2; 4; 2] should return [4; 4]. What is the type of your function?
```ocaml
let rec evens l =
match l with
[] -> []
|[a] -> []
| _::a::t -> a :: evens t;;  
val evens : 'a list -> 'a list = <fun>
(*type is above with The greek letters α, β, γ etc. stand for any type. If two types are represented by the same greek letter they must have the same type. If they are not, they may have the same type, but do not have to. Functions like this are known as polymorphic. 
evens has a polymorphic α type list as argument returning the same α type list*)

evens [2;4;2;4;2];;
- : int list = [4; 4]
```

2. Write a function count_true which counts the number of true elements in a list. For example, count_true [true; false; true] should return 2. What is the type of your function? Can you write a tail recursive version?

```ocaml
(*Contains an if for the evaluation of the item in pattern matching deconstruction*)
let rec count_true l n =
match l with
[] -> n
|h::t -> count_true t (if h = true then (n + 1) else n);;
val count_true : bool list -> int -> int = <fun>

count_true [true; false; true; false; false; true; true] 0;;
- : int = 4
```

3. Write a function which, given a list, builds a palindrome from it. A palindrome is a list which equals its own reverse. You can assume the existence of rev and @. Write another function which determines if a list is a palindrome.

```ocaml
(*head and tail of list with cons of head item to reversed list*)
let rec palindrome l = 
    match l with
    [] -> []
    | h::t -> h :: palindrome t @ [h];;

val palindrome : 'a list -> 'a list = <fun>

palindrome [1;2;3;4];;
- : int list = [1; 2; 3; 4; 4; 3; 2; 1]

(*Evaluate if list is palendrome*)
let check_palindrome l = 
    if rev(l) = l then true else false;;
val check_palindrome : 'a list -> bool = <fun>

check_palindrome [1; 2; 3; 4; 4; 3; 2; 1];;
- : bool = true
```
4. Write a function drop_last which returns all but the last element of a list. If the list is empty, it should return the empty list. So, for example, drop_last [1; 2; 4; 8] should return [1; 2; 4]. What about a tail recursive version?

```ocaml
let rec drop_last l = 
match l with
    [] -> []
    (*The key here is to return an empty list when the last tail item is input into argument*)
    |[a] -> []
    |h::t -> h :: drop_last t;;
val drop_last : 'a list -> 'a list = <fun>

drop_last [1; 2; 4; 8];;
- : int list = [1; 2; 4]
```

5. Write a function member of type α → α list → bool which returns true if an element exists in a list, or false if not. For example, member 2 [1; 2; 3] should evaluate to true, but member 3 [1; 2] should evaluate to false.
```ocaml
let rec member n l =
    match l with
    [] -> false
    |h::t -> if h = n then true else member n t;;
val member : 'a -> 'a list -> bool = <fun>

 member 2 [1; 2; 3];;
- : bool = true
(*This triggers false because the function reaches the empty list case and returns false*)
member 3 [1; 2];;
- : bool = false
```

6. Use your member function to write a function make_set which, given a list, returns a list which contains all the elements of the original list, but has no duplicate elements. For example, make_set [1; 2; 3; 3; 1] might return [2; 3; 1]. What is the type of your function?

```ocaml
let rec make_set l =
    match l with
    [] ->[]
    (*if h-element is in t then pop else cons*)
    | h::t -> if member h t then make_set t else h :: make_set t;;
val make_set : 'a list -> 'a list = <fun>

make_set [1; 2; 3; 3; 1];;
- : int list = [2; 3; 1]
```
7. Can you explain why the rev function we defined is inefficient? How does the time it takes to run relate to the size of its argument? Can you write a more efficient version using an accumulating argument? What is its efficiency in terms of time taken and space used?

As in notes, the time is proportional to the length *n* + the number of appends `@` that are performed. This makes it inefficient. Using an accumulator there is no append needed with an empty list accumulator:
```ocaml
let rec acc_reverse l ac =
    match l with
    (*end of list returns accumulator in recursive branch*)
    [] -> ac
    (*arguments are tail and cons of h item no appending!*)
    |h::t -> acc_reverse t (h::ac) ;;
val acc_reverse : 'a list -> 'a list -> 'a list = <fun>

acc_reverse [1;2;3;4] [];;
- : int list = [4; 3; 2; 1]
```

## Sorting Things
[Sorting][2]<br>
1. In msort, we calculate the value of the expression length l / 2 twice. Modify msort to remove this inefficiency.

```ocaml
(*original msort*)
let rec msort l = 
    match l with
        [] -> []
        | [x] -> [x]
        (*get right elements and left elements and sort*)
        | _ ->
            let left = take (length l/2) l in
            let right = drop (length l/2) l in
            merge (msort left) (msort right);;
```
```ocaml
(*new msort*)
let rec msort l = 
    match l with
        [] -> []
        | [x] -> [x]
        (*get right elements and left elements and sort*)
        | _ ->
            let half_len: int = length l/2 in 
            let left = take half_len l in
            let right = drop half_len l in
            merge (msort left) (msort right);;
```
2. We know that `take` and `drop` can fail if called with incorrect arguments. Show that this is never the case in `msort`.

`take` and `drop` take two args an intiger and 'a list. Both functions do not match for an empty list as a second argument. In `msort` an empty list is already matched in the base case of `msort`, thus an empty list will not be passed to take and drop!

3. Write a version of insertion sort which sorts the argument list into reverse order.
```ocaml
(*insertion sorted by ascending*)
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
```
Ascending or descending order is determined by the inequality operator in the conditional output with the cons disconstruction.
```ocaml
let rec insert x l =
    match l with
        [] -> [x]
        | h::t ->
            if x >= h
            then x :: h :: t
            else h :: insert x t
```
4. Write a function to detect if a list is already in sorted order.
```ocaml
match l with
    [] -> true
    |[x] -> true
    |h::x::t -> 
        if h <= x 
        then sort_check (x::t) 
        else false;;
val sort_check : 'a list -> bool = <fun>
```
5. We mentioned that the comparison functions like  <  work for many OCaml types. Can you determine, by experimentation, how they work for lists? For example, what is the result of [1; 2] < [2; 3]? What happens when we sort the following list of type char list list? Why?

List inequality operators (<, >, >=, etc) in OCaml module compare only the first element (h) of either list. From the answers - OCaml then evaluates the second items if the first two items are equal and so on.
```ocaml
[1; 5] < [2; 3];;
- : bool = true
[4; 1] < [2; 3];;
- : bool = false
[4] < [2; 3];;
- : bool = false
[4] > [2; 3];;
- : bool = true
[1; 2] < [1; 3];;
- : bool = true
```

What happens for sorting internal `char list list`?
```ocaml
sort [’o’; ’n’; ’e’];;
    Line 1, characters 6-7:
    Alert deprecated: ISO-Latin1 characters in identifiers
    Line 1, characters 9-11:
    Alert deprecated: ISO-Latin1 characters in identifiers
    Line 1, characters 15-16:
    Alert deprecated: ISO-Latin1 characters in identifiers
    Line 1, characters 18-20:
    Alert deprecated: ISO-Latin1 characters in identifiers
    Line 1, characters 24-25:
    Alert deprecated: ISO-Latin1 characters in identifiers
    Line 1, characters 27-29:
    Alert deprecated: ISO-Latin1 characters in identifiers
    Error: Line 1, characters 7-8:
    Error: Illegal character (\128)
```
6. Combine the sort and insert functions into a single sort function.

```ocaml
(*Uncombined*)
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
(*Combined - I had to look this up in the answers*)

let rec sort l =
    let rec insert x s =
        match s with 
        [] -> [x]
        |h::t ->
            if x <= h
                then x :: h :: t
                else h :: insert x t
    in
        match l with
        [] -> []
        | h::t -> insert h (sort t);;

```
## Functions upon Functions upon Functions
[anon-functions][3]
1. Write a simple recursive function `calm` to replace exclamation marks in a __char list__ with periods.
a. with recursion
```ocaml
let rec calm l =
match l with
[] -> []
|h::t -> (if h = '!' then '.' else h):: calm t;;
val calm : char list -> char list = <fun>

(*From answers - way better!*)
let rec calm l =
match l with
[] -> []
|'!'::t -> '.':: calm t (*The case where h is '!'*)
|h::t -> h :: calm t;;
```
b. with map
```ocaml
let calm l =
map (fun x -> if x = '!' then '.' else x) l;;
val calm : char list -> char list = <fun>

(*From answers - way better!*)
let calm_char x =
match x with '!' -> '.' | _ -> x;;
```

2. a. Write a function clip which, given an integer, clips it to the range 1…10 so that integers bigger than 10 round down to 10, and those smaller than 1 round up to 1. 

```ocaml
let clip i =
if i > 10 then 10
else if i < 1 then 1
else i;;
val clip : int -> int = <fun>

clip (-20);;
- : int = 1
clip 12;;
- : int = 10
clip 5;;
- : int = 5
```

b. Write another function cliplist which uses this first function together with map to apply this clipping to a whole list of integers.
```ocaml
let cliplist l =
map clip l ;;
val cliplist : int list -> int list = <fun>

cliplist [1;(-20);20; 5; 10];;
- : int list = [1; 1; 10; 5; 10]
```
3. Express your function cliplist again, this time using an anonymous function instead of clip.
```ocaml
let cliplist l =
map (fun x -> if x > 10 then 10 else if x < 1 then 1 else x) l ;;
val cliplist : int list -> int list = <fun>
```

4. Write a function `apply` which, given another function, a number of times to apply it, and an initial argument for the function, will return the cumulative effect of repeatedly applying the function. For instance, apply f 6 4 should return f (f (f (f (f (f 4)))))). What is the type of your function?

`let apply f <number of times> <initial arg>`
```ocaml
(*f - function, n - number of times to apply, a - init arg
    From answers*)
let rec apply f n a = 
    if n = 0
    then x (*base case 0 n *)
    else f (apply f (n-1) x);; (* reduce problem size but return result of 0 n number of times*)
val apply : ('a -> 'a) -> int -> 'a -> 'a = <fun>

let power a b =
apply (fun x -> x * a) b 1;;
val power : int -> int -> int = <fun>

(* power a b calculates a**b *)
power 2 4;;
- : int = 16
```
5. Modify the insertion sort function from the preceding chapter to take a comparison function, in the same way that we modified merge sort in this chapter. What is its type?

```ocaml
let rec sort cmp l =
    let rec insert cmp x s =
        match s with 
        [] -> [x]
        |h::t ->
            if cmp x h
                then x :: h :: t
                else h :: insert cmp x t
    in
        match l with
        [] -> []
        | h::t -> insert cmp h (sort cmp  t);;
val sort : ('a -> 'a -> bool) -> 'a list -> 'a list = <fun>
```

6. Write a function `filter` which takes a function of type α → bool and an α list and returns a list of just those elements of the argument list for which the given function returns true.

```ocaml
let rec filter f l =

match l with 
    [] -> []
    |h::t -> if (f h) 
        then h :: filter f t
        else  filter f t;;
val filter : ('a -> bool) -> 'a list -> 'a list = <fun>
```

7. Write the function `for_all` which, given a function of type α → bool and an argument list of type α list evaluates to true if and only if the function returns true for every element of the list. Give examples of its use.
```ocaml
let rec for_all f l=
match l with
    [] -> true
    |h::t -> if (f h) then for_all f t else false;;
val for_all : ('a -> bool) -> 'a list -> bool = <fun>

(*From the questions, differs using && operator*)
let rec for_all f l=
match l with
    [] -> true
    |h::t -> f h && for_all f t;; 

for_all (fun x -> x mod 2 = 0) [2;3;4;6;8];;
- : bool = false
for_all (fun x -> x mod 2 = 0) [2;4;6;8];;
- : bool = true
```

8. Write a function `mapl` which maps a function of type α → β over a list of type α list list to produce a list of type β list list.

```ocaml
let rec mapl f l =
match l with
    [] -> []
    |h::t -> 
        map f h :: mapl f t;;
val mapl : ('a -> 'b) -> 'a list list -> 'b list list = <fun>
```



<!-- Links --->
[1]:https://johnwhitington.net/ocamlfromtheverybeginning/split07.html
[2]:https://johnwhitington.net/ocamlfromtheverybeginning/split09.html
[3]:https://johnwhitington.net/ocamlfromtheverybeginning/split11.html
