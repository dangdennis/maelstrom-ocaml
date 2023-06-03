let new_node handler =
  let rec loop () =
    let line = input_line stdin in
    Print.print_to_stderr line;
    let () = handler line in
    loop ()
  in
  loop ()
