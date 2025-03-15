let channel_statistics in_channel = 
  let lines = ref 0 in
  (*Add and initialise variables*)
  let characters = ref 0 in
  let words = ref 0 in
  let sentences = ref 0 in

    try
      while true do
        let line = input_line in_channel in
          lines := !lines + 1;
        (* apply String.length to line string*)
        characters := !characters + String.length line;
        (*Iterate over each char using String.iter
            apply anonymous function to each c 
            - anon_func increment sentences or words with naive definition of words/sentences*)
        String.iter
            (fun c ->
              match c with
                '.' | '?' | '!' -> sentences := !sentences + 1
                | ' ' -> words := !words + 1
                | _ -> ())
            line
      done
    with
      End_of_file ->
        print_string "There were ";
        print_int !lines;
        print_string " lines, making up ";
        print_int !characters;
        print_string " characters with ";
        print_int !words;
        print_string " words in ";
        print_int !sentences;
        print_string " sentences.";
        print_newline ()

(* Read in name of txt file and execute function
Then close channel*)

let file_statistics name =
  let channel = open_in name in
    try
      channel_statistics channel;
      close_in channel
    with
      _ -> close_in channel
