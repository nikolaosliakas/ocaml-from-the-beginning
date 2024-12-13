# Notes from Book

## Lists
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

TODO: write down functions for take and drop on list page.

<!-- Links --->
[1]:https://johnwhitington.net/ocamlfromtheverybeginning/split07.html