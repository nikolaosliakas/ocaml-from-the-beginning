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
## Making Lists
[list-properties][1]<br>



<!-- Links --->
[1]:https://johnwhitington.net/ocamlfromtheverybeginning/split07.html
