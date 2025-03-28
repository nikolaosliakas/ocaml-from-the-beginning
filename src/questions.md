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
## When Things Go Wrong
[exceptions][4]

1. Write a function smallest which returns the smallest positive element of a list of integers. If there is no positive element, it should raise the built-in Not_found exception.
```ocaml
(*From answers in book*)
let rec smallest_inner current found l =
match l with
[] ->
    if found then current else raise Not_found
|h::t -> if h > 0 && h < current
            then smallest_inner h true t (*condition found=true*)
            else smallest_inner current found t
let smallest l =
    smallest_inner max_int false l;;

val smallest_inner : int -> bool -> int list -> int = <fun>
val smallest : int list -> int = <fun>
```

2. Write another function smallest_or_zero which uses the smallest function but if Not_found is raised, returns zero.
```ocaml
let smallest_or_zero l =
    try smallest l with
    Not_found -> 0;;
val smallest_or_zero : int list -> int = <fun>
```
3. Write an exception definition and a function which calculates the largest integer smaller than or equal to the square root of a given integer. If the argument is negative, the exception should be raised.
```ocaml
(*largest int <= to sqrt of given int*)
let larg_int_sq i =
    let result =  int_of_float(sqrt(float_of_int i)) in
    if result < 0 then
        raise (Not_found)
    else
        result;;

(*From the textbook*)

let rec sqrt_inner x n =
    if x * x > n
        then x - 1
    else
        sqrt_inner(x + 1) n

exception Complex

let sqrt n =
    if n < 0 then
        raise Complex
    else sqrt_inner 1 n;;

val sqrt_inner : int -> int -> int = <fun>
exception Complex
val sqrt : int -> int = <fun>

sqrt (-20);;
Exception: Complex.
```

4. Write another function which uses the previous one, but handles the exception, and simply returns zero when a suitable integer cannot be found.
```ocaml
let prev_one n =
    try sqrt n with
    Complex -> 0;;
prev_one (-20);;
- : int = 0
```
5. Comment on the merits and demerits of exceptions as a method for dealing with exceptional situations, in contrast to returning a special value to indicate an error (such as -1 for a function normally returning a positive number).

Merits of exceptions instead of special value
- clearer for developer interpretation
- explicit handling breaking type system

Demerits of exceptions instead of special value
- keeps same type but is out-of-range
- allow for easier integration of function, as consuming functions do not need to handle exception explicitly.

## Looking things up
[dictionaries][5]

1. Write a function to determine the number of different keys in a dictionary.

Function to search list of keys
```ocaml
(*if item in list return list*)
let rec search_key_list i l =
    match l with
    [] -> false
    |h::t -> if h = i then true else search_key_list i t ;;
val search_key_list : 'a -> 'a list -> bool = <fun>

(*
Keep track of unique keys as list
Keep counter for each unique key
*)

let rec count_dist_keys count kl l =
    match l with
    [] -> count
    |(k, _)::t -> if (search_key_list k kl) 
                    then count_dist_keys count kl t
                  (*Increment count by 1 add key to key list*)
                  else
                    count_dist_keys (count+1) (k::kl) t;; 
val count_dist_keys : int -> 'a list -> ('a * 'b) list -> int = <fun>
count_dist_keys 0 []
  [(1, 4); (2, 2); (3, 2); (4, 3); (6, 1); (6, 2)];;
- : int = 5

count_dist_keys 0 []
  [(1, 4); (2, 2); (3, 2); (4, 3); (5, 1); (6, 2)];;
- : int = 6
(*Book just says use length as keys must be unique...*)
```
2. Define a function `replace` which is like add, but raises Not_found if the key is not already there.
```ocaml
let rec replace k v l =
match l with
[] -> raise (Not_found)
|(k',v')::t -> if k' = k 
    then (k, v)::t
    else (k',v')::replace k v t;;
```
3. Write a function to build a dictionary from two equal length lists, one containing keys and another containing values. Raise the exception `Invalid_argument` if the lists are not equal length.

```ocaml
let rec length l = 
  match l with
    [] -> 0
  | h::t -> 1 + length t

let compare_length keys vals =
length keys = length vals

let rec build_dict keys vals dict =
if compare_length keys vals then
    match keys, vals with
        [], [] -> dict
        (*unpack each list simultaneously and provide to add function*)
     |   hk::tk, hv::tv -> build_dict tk tv (add hk hv dict)
else
    raise (Invalid_argument "lengths of keys and values are unequal!");;
val build_dict : 'a list -> 'b list -> ('a * 'b) list -> ('a * 'b) list = <fun>

(*Much more succinct and pattern matching handles inequality!*)

let rec mkdict keys values =
    match keys, values with
    [], [] -> []
    (* Either keys or values reaches an empty list state before the other thus unequal *)
    |[], _ -> raise (Invalid_argument "mkdict")
    |_, [] -> raise (Invalid_argument "mkdict") 
    (*unpack from each - express pair and cons list constructor*)
    | k::ks, v::vs -> (k,v):: mkdict ks vs
val mkdict : 'a list -> 'b list -> ('a * 'b) list = <fun>
```

4. Now write the inverse function: given a dictionary, return the pair of two lists – the first containing all the keys, and the second containing all the values.

```ocaml
let rec mklists d kl vl =
match d with
[] -> (kl, vl)
|(k,v)::t -> mklists t (k::kl) (v::vl)
val mklists : ('a * 'b) list -> 'a list -> 'b list -> 'a list * 'b list = <fun>

mklists [(1, 4); (2, 2); (3, 2); (4, 3); (5, 1); (6, 2)] [] [];;
- : int list * int list = ([6; 5; 4; 3; 2; 1], [2; 1; 3; 2; 2; 4])

(*Solution from Questions*)

let rec mklists l =
[] -> ([],[])
|(k,v)::more ->
    let (ks, vs) = mklists more in
        (* (ks, kv) -> (k::ks, v::vs) *)
        (* this has only one form so can be re-written as *)
        (k::ks, v::vs)
val mklists : ('a * 'b) list -> 'a list * 'b list 
```
5. Define a function to turn any list of pairs into a dictionary. If duplicate keys are found, the value associated with the first occurrence of the key should be kept.

```ocaml
let rec mkdir_fromlist l  =
match l with
    [] -> []
    |(k,v)::more -> (k,v) :: mkdir_fromlist (remove k more);;
val mkdir_fromlist : ('a * 'b) list -> ('a * 'b) list = <fun>

mkdir_fromlist [(1, 4); (2, 2); (3, 2); (2,9); (5, 1); (6, 2)];;
- : (int * int) list = [(1, 4); (2, 2); (3, 2); (5, 1); (6, 2)]
(* From the book *)

let rec dictionary_of_pairs_inner keys_seen l =
match l with
[] -> []
| (k, v)::t -> 
    if member k keys_seen
        then dictionary_of_pairs_inner keys_seen t
        else (k,v) :: dictionary_of_pairs_inner (k::keys_seen) t;;
val dictionary_of_pairs_inner : 'a list -> ('a * 'b) list -> ('a * 'b) list =
  <fun>

dictionary_of_pairs_inner [] [(1, 4); (2, 2); (3, 2); (2,9); (5, 1); (6, 2)];;
- : (int * int) list = [(1, 4); (2, 2); (3, 2); (5, 1); (6, 2)]
```

6. Write the function union a b which forms the union of two dictionaries. The union of two dictionaries is the dictionary containing all the entries in one or other or both. In the case that a key is contained in both dictionaries, the value in the first should be preferred.

```ocaml
(*From answers*)
(*Add function overrides existing dictionary pair, and adds non-existent pair*)
let rec union a b =
    match a with
    [] -> b
    | (k,v)::t -> add k v (union t b);;
```
## More with functions
[partial-application-functions][6]

1. Rewrite the summary paragraph at the end of this chapter for the three argument function g a b c.

```ocaml
let g = fun a -> fun b -> fun c -> ...;;
'a -> 'b -> 'g -> 'd
'a -> ('b -> ('g -> 'd))
(* This take right-associative
    takes argument of type 'a and returns 'b -> ('g -> 'd)
    which is a function when given 'b gives output 'g -> 'd
    which is a function when given 'g returns something of type 'd.

    We can apply just one or two or three args to function g
*)
```

2. Recall the function member x l which determines if an element x is contained in a list l. What is its type? What is the type of member x? Use partial application to write a function member_all x ls which determines if an element is a member of all the lists in the list of lists ls.

```ocaml
member;;
- : 'a -> 'a list -> bool = <fun>

let member_all x ls =
    let booleans = map (member x) ls in
        not (member false booleans);;
val member_all : 'a -> 'a list list -> bool = <fun>
(* Use member and map
    - this produces booleans (which is a bool list)
    - then reapply member function to find false
    - return the negation of this list of falses *)
(* 
    member_all two args ((x) and (ls))

    booleans declared it contains map (member x) ls
        - map function applies the outcome of (member x) - partial application of member to list provided by map as it iterates through ls

*)

```
3. Why can we not write a function to halve all the elements of a list like this: map (( / ) 2) [10; 20; 30]? Write a suitable division function which can be partially applied in the manner we require.

```ocaml
let f l = map (( / ) 2) [10; 20; 30];;
(* This actually is:
[2/10; 2/20; 2/30] 
The partial application applies 2 in this case as the first number!*)

let rdiv x y = y/x;;
val rdiv : int -> int -> int = <fun>

let f l = map (rdiv  2) l;;
val f : int list -> int list = <fun>

let f = map (rdiv  2);;
val f : int list -> int list = <fun>
f [20;30;40];;
- : int list = [10; 15; 20]
```

4. Write a function mapll which maps a function over lists of lists of lists. You must not use the let rec construct. Is it possible to write a function which works like map, mapl, or mapll depending upon the list given to it?

```ocaml
let mapll f = map (map (map f));;
val mapll : ('a -> 'b) -> 'a list list list -> 'b list list list = <fun>


 mapll ( ( * ) 2) [[[2;3;4];[5;6;7]];
                    [[2;3;4]];
                    [[5;6;7]]];;
- : int list list list =
[[[4; 6; 8]; [10; 12; 14]]; [[4; 6; 8]]; [[10; 12; 14]]]
```
_From the book_
It is not possible to write a function which would map a function f over a list, or list of lists, or list of lists of lists depending upon its argument, because every function in OCaml must have a single type. If a function could map f over an α list list it must inspect its argument enough to know it is a list of lists, thus it could not be used on a β list unless β = α list.

5. Write a function `truncate` which takes an integer and a list of lists, and returns a list of lists, each of which has been truncated to the given length. If a list is shorter than the given length, it is unchanged. Make use of partial application.

```ocaml

let rec truncate_inner n l =

match l with
[] -> []
|h::t -> if n=0 then []
        else h:: truncate_inner (n-1) t;;

truncate_inner 3 [1;2;3;4;5];;
- : int list = [1; 2; 3]

(* Create the truncate function with map *)
let truncate n ls = map (truncate_inner n) ls;;
val truncate : int -> 'a list list -> 'a list list = <fun>
let truncate n = map (truncate_inner n);;

truncate 3 [[1;2;3;4;5];[17;24;35;4;5]];;
- : int list list = [[1; 2; 3]; [17; 24; 35]]
(* From text book *)
let rec take n l = 
    if n = 0 then [] else
    match l with 
    h::t -> h :: take (n-1) t

let truncate_l n l =
    if length l >=n then take n l else l;;

let truncate n ll =
    map (truncate_l n) ll
```

6. Write a function which takes a list of lists of integers and returns the list composed of all the first elements of the lists. If a list is empty, a given number should be used in place of its first element.

```ocaml
let first_num default_n l =

    match l with
    [] -> default_n
    |h::t -> h;;
val first_num : 'a -> 'a list -> 'a = <fun>

let find_first default_n =
    map (first_num default_n);;
val find_first : 'a -> 'a list list -> 'a list = <fun>/'|

find_first [[1;2;3];[];[23;45;6];[74;44]];;
```

## Intro to types
[New Kinds of Data][7]

1. Design a new type rect for representing rectangles. Treat squares as a special case.

```ocaml
type rect = Rectangle of int * int | Square of int;;
```
2. Now write a function of type rect → int to calculate the area of a given rect.
```ocaml
let calc_rect shape =
    match shape with
        Rectangle (x,y) -> x * y
        |Square (x) -> x * x;;
val calc_rect : rect -> int = <fun>

let my_shape = Rectangle (4,5);;
val my_shape : rect = Rectangle (4, 5)
calc_rect my_shape;;
- : int = 20

let my_square = Square 4;;
val my_square : rect = Square 4

calc_rect my_square;;
 : int = 16
```
3. Write a function which rotates a rect such that it is at least as tall as it is wide

```ocaml
let rotate_rect shape = 
match shape with
    Square _ -> shape
    | Rectangle (w,h) -> if w > h then Rectangle (h, w) else shape;;

(*If we have a rectangle with a Bigger width than height, rotate by 90degrees*)
val rotate_rect : rect -> rect = <fun>
```
4. Use the function of (3) which, given a rect list, returns another such list which has the smallest total width and whose members are sorted narrowest first.

```ocaml
(*From textbook answers*)
(*map to perform rotation on any rects that need it, we will then use a sorting function from previous chapter which takes a comparison function and uses it to 'sort'*)
let width_of_rect r =
    match r with
    Square s -> s
    | Rectangle (w, _) -> w;;
val width_of_rect : rect -> int = <fun>

let rect_compare a b =
width_of_rect a < width_of_rect b;;
val rect_compare : rect -> rect -> bool = <fun>

let pack rects =
    sort rect_compare (map rotate_rect rects);;
val pack : rect list -> rect list = <fun>

pack [Square 6; Rectangle (4, 3); Rectangle (5, 6); Square 2];;
- : rect list = [Square 2; Rectangle (3, 4); Rectangle (5, 6); Square 6]
```

5. Write a `take`, `drop`, and `map` functions for seqence type.
Original map
```ocaml
let rec map f l =
    match l with
    [] -> []
    (* f is a function in the initial call a parameter 
    that is 'called' to each h recursively until list is exhausted*)
    | h::t -> f h :: map f t;;
val map : ('a -> 'b) -> 'a list -> 'b list = <fun>
```
sequence type map:
```ocaml
# type 'a sequence = Nil | Cons of 'a * 'a sequence;;
type 'a sequence = Nil | Cons of 'a * 'a sequence

 let rec map f l =
    match l with
        Nil -> Nil
        |Cons (h, t) ->  Cons (f h, map f t);;
val map : ('a -> 'b) -> 'a sequence -> 'b sequence = <fun>
```

Original take and drop:
```ocaml
let rec take n l = 
    if n = 0 then [] else
    match l with 
[] -> []
|    h::t -> h :: take (n-1) t;;
val take : int -> 'a list -> 'a list = <fun>

let rec drop n l = 
if n = 0 then l else
match l with
    [] -> []
    |_::t -> drop (n-1) t;;
val drop : int -> 'a list -> 'b list = <fun>
```
sequence versions:
```ocaml
let rec take n l =
if n = 0 then Nil else
    match l with
    Nil -> Nil
    |Cons(h, t) -> Cons(h, take (n-1) t);;

let rec drop n l =
if n = 0 then l else
match l with
Nil -> Nil
|Cons(_, t) -> drop (n-1) t;;]

(*From the textbook*)
let rec take n l =
if n = 0 then Nil else
    match l with
    Nil -> raise (Invalid_argument "take")
    |Cons(h, t) -> Cons(h, take (n-1) t);;
val take : int -> 'a sequence -> 'a sequence = <fun>

let rec drop n l =
if n = 0 then l else
    match l with
    Nil -> raise (Invalid_argument "drop")
    | Cons(_,l) -> drop (n-1) l;;
val drop : int -> 'a sequence -> 'a sequence = <fun>
```
6. Extend the `expr` and the `evaluate` function to allow raising a number to a power


```ocaml
type expr =
    Num of int
    | Add of expr * expr
    | Subtract of expr * expr
    | Multiply of expr * expr
    | Divide of expr * expr
    | Power of expr * expr;;

let rec power x n =
match n with
0 -> 1
|_ -> x * power x (n-1);;
let rec evaluate expr =
match expr with
    Num x -> x
    | Add(e, e') -> evaluate e + evaluate e'
    | Subtract(e, e') -> evaluate e - evaluate e'
    | Multiply(e, e') -> evaluate e * evaluate e'
    | Divide(e, e') -> evaluate e / evaluate e'
    | Power(e, e') -> power (evaluate e) (evaluate e');;
val evaluate : expr -> int = <fun>
```
7. Use the option type to deal with the problem that Division_by_zero may be raised from the evaluate function.

```ocaml
type 'a option = None | Some of 'a;;

let my_division = Divide(Num 4,Num 0);;
val my_division : expr = Divide (Num 4, Num 0)
(*Super important option that allows for native optional return*)
try Some (evaluate my_division) with Division_by_zero -> None;;
- : int option = None
```

## Growing Trees
[Trees][8]
1. Write function `'a -> 'a tree -> bool` to determine if a given element is a tree. 

Write a search if Lf comes up pattern match false else true

```ocaml
# let rec search_for_elem e tr =
    match tr with
        Lf -> false
        |Br(e', l, r) -> 
            if e' = e then true
            else search_for_elem e l || search_for_elem e r;;
        (*From textbook without test if*)
        |Br(e', l, r) -> e' = e || search_for_elem e l  || search_for_elem e r;; 
val search_for_elem : 'a -> 'a tree -> bool = <fun>

# search_for_elem 21 my_tree;;
- : bool = false

# search_for_elem 20 my_tree;;
- : bool = true
```
2. Write a function which flips a tree left to right such that, if it were drawn on paper, it would appear to be a mirror image.

```ocaml
let rec flip_tree tr =
    match tr with
        Br(x, l, r) -> Br(x, flip_tree r, flip_tree l)
        | Lf -> Lf;;
val flip_tree : 'a tree -> 'a tree = <fun>
(*Before flip*)
# my_tree;;
- : int tree = Br (2, Br (11, Lf, Lf), Br (5, Lf, Br (20, Lf, Lf)))
        2
    11      5
                20
(*After flip*)
# flip_tree my_tree;;
- : int tree = Br (2, Br (5, Br (20, Lf, Lf), Lf), Br (11, Lf, Lf))

        2
    5      11
20         
```

3. Write a function to determine if two trees have the same shape, irrespective of the actual values of the elements.

```ocaml
let rec compare_tree_shape x y =
    match x, y with
    Br(_, xl, xr), Br(_, yl, yr) -> compare_tree_shape xl yl && compare_tree_shape xr yr
    | Lf , Lf -> true
    | _, _ -> false;;
val compare_tree_shape : 'a tree -> 'b tree -> bool = <fun>
```

4. Write a function `tree_of_list` which builds a tree representation of a dictionary from a list representation of a dictionary.

```ocaml
(*Use int keys to build tree*)

# let tree_of_list empty_tree d  =
match d with
    [] -> Lf
  | (k, v)::t -> tree_of_list (insert empty_tree k  v) t;;
val tree_of_list : ('a * 'b) tree -> ('a * 'b) list -> ('a * 'b) tree = <fun>

# tree_of_list Lf [(1, "one"); (2, "two"); (3, "three"); (4, "four"); (5, "five"); (6, "six")];;
- : (int * string) tree = Br ((1, "one"), Lf, Br ((2, "two"), Lf, Lf))
(*My solution above - coun't figureit out...
From the textbook*)

# let rec tree_of_list d =
    match d with
        [] -> Lf
        | (k,v)::t -> insert (tree_of_list t) k v;;
val tree_of_list : ('a * 'b) list -> ('a * 'b) tree = <fun>

# tree_of_list [(1, "one"); (2, "two"); (3, "three"); (4, "four"); (5, "five"); (6, "six")];;
- : (int * string) tree =
Br ((6, "six"),
 Br ((5, "five"),
  Br ((4, "four"),
   Br ((3, "three"), Br ((2, "two"), Br ((1, "one"), Lf, Lf), Lf), Lf), Lf),
  Lf),
 Lf)
```
5. Write a function to combine two dictionaries represented as trees into one. In the case of clashing keys, prefer the value from the first dictionary.

```ocaml
(*Notes try using a dict list as an intermediary
- Use Add and Union from list pairs above 
*)
# let combine_tree_dicts x y =

tree_of_list (
    (union (list_of_tree x) (list_of_tree y))
);;
val combine_tree_dicts : ('a * 'b) tree -> ('a * 'b) tree -> ('a * 'b) tree =
  <fun>
# combine_tree_dicts (Br ((6, "thebestplaceintheworld"),
 Br ((5, "five"),
  Br ((4, "four"),
   Br ((3, "three"), Br ((2, "two"), Br ((1, "one"), Lf, Lf), Lf), Lf), Lf),
  Lf),
 Lf)) (Br ((6, "six"),
 Br ((5, "five"),
  Br ((4, "four"),
   Br ((3, "three"), Br ((2, "two"), Br ((1, "one"), Lf, Lf), Lf), Lf), Lf),
  Lf),
 Lf));;
- : (int * string) tree =
Br ((6, "thebestplaceintheworld"),
 Br ((5, "five"),
  Br ((4, "four"),
   Br ((3, "three"), Br ((2, "two"), Br ((1, "one"), Lf, Lf), Lf), Lf), Lf),
  Lf),
 Lf)

 (*The text-website does not guarantee uniqueness!*)
 # let tree_union t t' =
 tree_of_list( (list_of_tree t) @ (list_of_tree t'));;
 val tree_union : ('a * 'b) tree -> ('a * 'b) tree -> ('a * 'b) tree =
  <fun>
  (*From website: tree_of_list will prefer keys placed earlier so we appended t' to t rather than the reverse (preference for t' keys!*)
```

6. Can you define a type for trees which, instead of branching exactly two ways each time, can branch zero or more ways, possibly different at each branch? Write simple functions like `size`, `total`, and `map` using your new type of tree.

```ocaml
type 'a tree = Lf | Br of 'a option;;
(*Completely wrong
From answers:
We will use a list for the sub-trees of each branch, with the empty list signifying 
there are no more i.e. that this is the bottom of the tree. 
Thus, we only need a single constructor.
*)
type 'a mtree = Branch of 'a * 'a mtree list;;
```

Size
```ocaml
(*With binary tree*)
let rec size tr =
    match tr with
    Br (_, l, r) -> 1 + size l + size r
    | Lf -> 0;;
(*With multi sort tree*)
let rec size tr =
    match tr with
    Br (e, l) -> 1 + sum(map size l));;
    

```
total
```ocaml
(*With binary tree*)
# let rec total tr =
    match tr with
    Branch (x, l, r) -> x + total l + total r
    | Lf -> 0;;
val total : int tree -> int = <fun>
(*With multi sort tree*)
let rec total tr =
    match tr with
    Branch (e, l) -> e + sum(map total l));;
```
map
```ocaml
(*With binary tree*)
let rec tree_map f tr =
    match tr with
        Br(x, l, r) -> Br (f x, tree_map f l, tree_map f r)
        |Lf -> Lf;;
val tree_map : ('a -> 'b) -> 'a tree -> 'b tree = <fun>
(*With multi sort tree*)

let rec map_mtree f tr =
    match tr with
    (*Partial application of map_mtree*)
    Branch(e, l) -> Branch(f e, map (map_mtree f) l);;
val map_mtree : ('a -> 'b) -> 'a mtree -> 'b mtree = <fun>

```

## In and Out
[IO-stuff][9]
1. Write a function to print a list of integers to the screen in the same format OCaml uses – i.e. with square brackets and semicolons.
```ocaml
let rec iter_print_list f l =
    match l with
    [] -> ()
    | [x] -> f x; print_char ']'
    | h::t -> f h; print_string "; "; iter_print_list f t;;
val iter : ('a -> 'b) -> 'a list -> unit = <fun>

let print_list_items l =
    match l with 
    [] -> ()
    |_ -> print_char '['; iter_print_list print_int l;;
val print_list_items : int list -> unit = <fun>

print_list_items [1;2;3;4;5;6];;
[1; 2; 3; 4; 5; 6]- : unit = ()
```
2. Write a function to read three integers from the user, and return them as a tuple. 
What exceptions could be raised in the process? Handle them appropriately.
```ocaml
# type output_type = (int * int * int);;
# let rec read_three_ints () =
    print_string "Type three integers and get a tuple!";
    print_newline ();
    try
        (*Brute force from the text!*)
        let x = read_int () in
            let y = read_int () in
                let z = read_int () in
                (x, y, z)
                
    with
        Failure _ ->
        print_string "This is not a valid integer. Please try again.";
        print_newline ();
        read_three_ints ();;
val read_three_ints : unit -> int * int * int = <fun>
read_three_ints ();;

Type three integers and get a tuple!
3
45
66
```
3. In our `read_dict` function, we waited for the user to type 0 to indicate no more data. This is clumsy. Implement a new read_dict function with a nicer system. Be careful to deal with possible exceptions which may be raised.
```ocaml

# let rec new_read_dict () =

    try
        let x = read_int ()
            let name = read_line () in
                (i, name) :: new_read_dict ()
    
    with 
        Failure _ -> 
            print_string "This is not a valid integer. Please try again.";
            print_newline ();
            new_read_dict ();;
val new_read_dict : unit -> (int * string) list = <fun>
```
4. Write a function which, given a number `x`, prints the `x`-times table to a given file name.

```ocaml
let rec create_list i j =
if i = j then
    [j]
else
    (j :: create_list i (j+1));;
val create_list : int -> int -> int list = <fun>
```
```ocaml
let rec map f l =
    match l with
    [] -> []
    (* f is a function in the initial call a parameter 
    that is 'called' to each h recursively until list is exhausted*)
    | h::t -> f h :: map f t;;
```
Solution from the site. Couldn't quite wrestle with this.

Reminder: pattern matching with creating lists needs append `@` instead of cons `::`.

```ocaml
(*Create a num list*)

let rec numlist n =

match n with
0 -> []
|_ -> numlist(n-1) @ [n];;
val numlist : int -> int list = <fun>
let rec map f l =
    match l with
        [] -> []
        |h::t -> f h :: map f t;;
val iter : ('a -> 'b) -> 'a list -> unit = <fun>

let rec iter f l =
    match l with
    [] -> ()
    | h::t -> f h; iter f t;;
val iter : ('a -> 'b) -> 'a list -> unit = <fun>

(*Very important*)
let write_table_channel ch n =
    (*Outer iter function call*)
    iter 
        (*OUTER ITER- arg1*)
        ((*arg1 - anonymous function provided as value for iter 'f'*)
        fun x ->
            (*arg1 - INNER ITER*)
            iter
                    (*arg1 - INNER ITER - arg1*)
                    (*anon-fun output i using channel instead of console*)
                    (fun i -> 
                    output_string ch (string_of_int i);
                    output_string ch "\t")
                (*This provides the INNER iteration to 5 of columns
                The outer reference to the anonymous function providing a fixed x for each row to pcreate muliples.*)
                (map (( * ) x ) (numlist n));
                output_string ch "\n")
        (*Outer iter- arg2
        This provides the outer iteration to 5 of rows!*)
        (numlist n);;
val write_table_channel : out_channel -> int -> unit = <fun>
```
```shell
utop # write_table_channel stdout 5;;
    1       2       3       4       5
    2       4       6       8       10
    3       6       9       12      15
    4       8       12      16      20
    5       10      15      20      25
    - : unit = ()
```
Then we write to the 'output handler'. 
```ocaml
exception FileProblem

let table filename n =
    if n < 0 then
        raise (Invalid_argument "table") 
    else
        (*Exceptions are thrown in the smallest point.*)
        try
            let ch = open_out filename in 
            write_table_channel ch n;
            close_out ch
        with
            _ -> raise FileProblem;;
val table : string -> int -> unit = <fun>
```

## Putting things in Boxes AKA References and Arrays
[arrays][10]<br>
1. Consider the expression
```ocaml

let x = ref 1 in
let y = ref 2 in
x := !x + !x;
y := !x + !y;
!x + !y

(*
step1 - [x=1; y=2]
step2 - [x=2; y=2]
step3 - [x=2; y=4]
step4 - 6
- : int = 6
type () -> int if it were a function with no args.
*)
```
2. What is the difference between `[ref 5; ref 5]` and `let x = ref 5 in [x;x]`?<br>
```ocaml
# [ref 5; ref 5];;
- : int ref list = [{contents = 5}; {contents = 5}]
# let x = ref 5 in [x;x];;
- : int ref list = [{contents = 5}; {contents = 5}]
```

Both produce int ref list with two references with contents of 5. The difference is how this is expressed.

3. Imagine that the `for … = … to … do … done` construct did not exist. How might we create the same behaviour?
Recursively increment an outer function????

<br> From the book.<br>
function of type __int -> 'a__ alpha instead of unit
Include start and end numbers
```ocaml
let rec forloop f n m =
    if n <= m then
        (*apply function to each integer*)
        begin
            f n;
            (*increment n in recursive inner call*)
            forloop f (n + 1) m
        end

```

4. Whare the types of these expressions?
```ocaml
[|1;2;3|]
val a : int array = [|1; 2; 3|]
[|true; false; true|]
- : bool array
[|[|1|]|]
- : int array array AKA (int array) array
[|[1; 2; 3]; [4; 5; 6]|]
- : int list array (*Key here: inner structure is a pair of lists rather than arrays!*)
[|1; 2; 3|].(2)
- : int 3
(*Assign int 4 to position 2 index from 0
[|1;2;4|]
*)
[|1; 2; 3|].(2) <- 4
- : unit = ()
```
5. Write a function to compute the sum of the elements in an integer array.

```ocaml
let sum_array arr = 
  let sum = ref 0 in
    for x = 0 to Array.length arr - 1 do
      sum := !sum + arr.(x)
    done;
    !sum
val sum_array : int array -> int = <fun>
```

6. Write a function to reverse the elements of an array (no new array)

```ocaml
let reverse_array arr =
(*Author included base case where array has length 1
This is needed for out of bounds exception:
# reverse_array [||];;
Exception: Invalid_argument "index out of bounds".*)
if Array.length arr > 1 then
    let le = Array.length arr - 1 in
        for x = 0 to (le/2) do
            let i = arr.(x) in
            arr.(x) <- arr.(le-x);
            arr.(le-x) <- i;
        done;
    arr;;
val reverse_array : 'a array -> 'a array = <fun>
```
7. Write a function table which, given an integer, builds the int array array representing the multiplication table up to that number. For example, `table 5` should yield:

```ocaml
let table n = 
    (*two dimensional array with size n and initvalue 0*)
    let a = Array.make n [||] in
        for x = 0 to n - 1 do
            a.(x) <- Array.make n 0
        done;
        for i = 0 to n-1 do
            for j = 0 to n-1 do
                a.(i).(j) <- (i+1) * (j+1);
            done;
        done;
    a;;
val table : int -> int array array = <fun>
```
8. The ASCII codes for the lower case letters ’a’…’z’ are 97…122, and for the upper case letters ’A’…’Z’ they are 65…90. Use the built-in functions int_of_char and char_of_int to write functions to uppercase and lowercase a character. Non-alphabetic characters should remain unaltered.

```ocaml
let switch_case c =

    let i = ref (int_of_char c) in
        if !i > 96 && !i < 123 then
            i := !i - 32
        else if !i > 64  && !i < 91 then
            i := !i + 32
    ; char_of_int !i;;
```
From the author - no need to use references!
```ocaml
let uppercase x =
    if int_of_char x >= 97 && int_of_char x <=122
        then char_of_int(int_of_char x - 32)
    else x
let lowercase x =
    if int_of_char x >= 65 && int_of_char x <=90
        then char_of_int(int_of_char x + 32)
    else x
```
How I would write it after seeing author:
```ocaml
let switch_case c =
    let i = int_of_char c in
        if i >= 97 && i <=122 
            then char_of_int(i - 32)
        else if i >= 65 && i <=90 
            then char_of_int(i + 32)
        else c
val switch_case : char -> char = <fun>
```
9. Commentary from author on text example use for string parsing!<br>
Periods, exclamation marks and question marks may appear in multiples, leading to a wrong answer. The number of characters does not include newlines. It is not clear how quotations would be handled. Counting the words by counting spaces is inaccurate – a line with ten words will count only nine.

## The Other Numbers AKA Floats

1. Give a function which rounds a positive floating-point number to the nearest whole number, returning another floating-point number.

```ocaml
let round_float n = 

    let c = ceil n in
      let f = floor n in
        if c -. n <= n -. f then f else c;;
val round_float : float -> float = <fun>
```
2. Write a function to find the point equidistant from two given points in two dimensions.
```ocaml
let find_midpoint (x0, y0) (x1, y1) =

    ((x0 +. x1) /. 2. , (y0 +. y1) /. 2.)

val find_midpoint : float * float -> float * float -> float * float = <fun>
```
3. Write a function to separate a floating-point number into its whole and fractional parts. Return them as a tuple of type __float × float__.
```ocaml
let separate_whole_fract x =
    (floor x, x -. floor x)
val seperate_whole_fract : float -> float * float = <fun>
```
4. Write a function `star` of type __float → unit__ which, given a floating-point number between zero and one, draws an asterisk to indicate the position. An argument of zero will result in an asterisk in column one, and an argument of one an asterisk in column fifty.
```ocaml
let array_string_concat a =
    let b = Buffer.create(Array.length a) in
        Array.iter (Buffer.add_string b) a; print_string (Buffer.contents b)
val array_string_concat : string array -> unit = <fun>
let star x =
    let a = Array.make 50 " " in
        if x > 1. || x < 0. then
            print_string "Arg not between 0 and 1!" 
        else
            (let position = int_of_float (floor (x /. 2. *. 100.)) in
            a.(position) <- "*");
    let str_output = array_string_concat a;
    print_string str_output;
    print_newline ();;
val star : float -> unit = <fun>
```
5. Now write a function plot which, given a function of type float → float, a range, and a step size, uses `star` to draw a graph. 
```ocaml
(*atan - arctangent of an angle given in radians.*)
let pi = 4.0 *. atan 1.0;;
val pi : float = 3.14159265358979312

let plot f r_start r_end step =

    let total_steps = int_of_float ((r_end -. r_start) /. step) in
    print_int total_steps ;
        for i=0 to total_steps-1 do
            star (
                f (
                    (float_of_int i *. step) +. r_start
                    )
                )
        done
```
From the author:
```ocaml
let star x =
    let i = int_of_float (floor (x *. 50.)) in
        let i' = if i = 50 then 49 else i in
            for x = 1 to i' -1 do print_char ' ' done;
            print_char '*';
            print_newline ()

let plot f a b dy =
    let pos = ref a in
        while !pos <= b do
            star (f !pos);
            pos := !pos +. dy
        done
# plot sin 0. pi (pi /. 20.);;
*
      *
              *
                     *
                            *
                                  *
                                       *
                                           *
                                              *
                                                *
                                                *
                                                *
                                              *
                                           *
                                       *
                                  *
                            *
                     *
              *
      *
*
- : unit = ()
```


<!-- Links --->
[1]:https://johnwhitington.net/ocamlfromtheverybeginning/split07.html
[2]:https://johnwhitington.net/ocamlfromtheverybeginning/split09.html
[3]:https://johnwhitington.net/ocamlfromtheverybeginning/split11.html
[4]:https://johnwhitington.net/ocamlfromtheverybeginning/split12.html
[5]:https://johnwhitington.net/ocamlfromtheverybeginning/split13.html
[6]:https://johnwhitington.net/ocamlfromtheverybeginning/split14.html
[7]:https://johnwhitington.net/ocamlfromtheverybeginning/split15.html
[8]:https://johnwhitington.net/ocamlfromtheverybeginning/split16.html
[9]:https://johnwhitington.net/ocamlfromtheverybeginning/split17.html
[10]:https://johnwhitington.net/ocamlfromtheverybeginning/split18.html