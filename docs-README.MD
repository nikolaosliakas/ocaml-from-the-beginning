# Documentation that may move

One of the packages installed from `opam` the package manager was `utop`

Here is its use in the shell:
```shell
nl@Ns-MacBook-Air-2 ~ % utop
──────┬──────────────────────────────────────────────────────────────────┬──────
      │ Welcome to utop version %%VERSION%% (using OCaml version 5.2.0)! │      
      └──────────────────────────────────────────────────────────────────┘      

Type #utop_help for help about using utop.

─( 23:12:18 )─< command 0 >──────────────────────────────────────{ counter: 0 }─
utop # 4 + 5 ;;
- : int = 9
─( 23:12:18 )─< command 1 >──────────────────────────────────────{ counter: 0 }─
utop # let mySize n = n * 4;;
val mySize : int -> int = <fun>
─( 23:12:39 )─< command 2 >──────────────────────────────────────{ counter: 0 }─
utop # mySize 4;;
- : int = 16
─( 23:13:17 )─< command 3 >──────────────────────────────────────{ counter: 0 }─
utop # #quit;;
```