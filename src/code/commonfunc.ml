let rec map f l =
  match l with
  [] -> []
  (* f is a function in the initial call a parameter 
  that is 'called' to each h recursively until list is exhausted*)
  | h::t -> f h :: map f t

let rec lookup x l =
  match l with
    [] -> raise Not_found
    (*unpacking each pair from head *)
|   (k, v):: t -> 
    if k = x then v else lookup x t

let rec add k v d =
  match d with
      [] -> [(k,v)]
  |   (k',v')::t -> 
      (* unpack k' and v' from h  ->  
      if keys are the same overwrite v' with v 
          else retain and cons pair, continuing down the tail *)
      if k = k' 
          then (k, v):: t
          else (k', v') :: add k v t

let key_exists k d =
  try
      let _ = lookup k d in true
  with
      Not_found -> false

let rec mapl f l =
  match l with 
  [] -> []
  | h::t -> map f h :: mapl f t;;
let mapl f l = map (map f) l