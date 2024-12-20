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


<!-- Links --->
[1]:https://johnwhitington.net/ocamlfromtheverybeginning/split07.html
