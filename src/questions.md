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

et rec count_dist_keys count kl l =
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


<!-- Links --->
[1]:https://johnwhitington.net/ocamlfromtheverybeginning/split07.html
[2]:https://johnwhitington.net/ocamlfromtheverybeginning/split09.html
[3]:https://johnwhitington.net/ocamlfromtheverybeginning/split11.html
[4]:https://johnwhitington.net/ocamlfromtheverybeginning/split12.html
[5]:https://johnwhitington.net/ocamlfromtheverybeginning/split13.html
[6]:https://johnwhitington.net/ocamlfromtheverybeginning/split14.html