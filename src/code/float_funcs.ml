
(*vector functions*)
(*1. Func to build vector from one point to another*)

let make_vector (x0, y0) (x1, y1) =
    (x1 -. x0, y1 - y0)

(*2. Func to find the length of a vector*)

let vector_length (x,y) =
    sqrt (x *. x +. y *. y)

(*3. Func to offset a point by a vector*)

let offset_point (x, y) (px, py)=
    (px +. x, py +. y)

(*4. Func to scale a vector a vector to a given length*)

let scale_to_length l (a, b)=
    let currentlength = vector_length (a, b) in
        if currentlength = 0. then (a, b) else
            let factor = l /. currentlength in
                (a *. factor, b *. factor)
