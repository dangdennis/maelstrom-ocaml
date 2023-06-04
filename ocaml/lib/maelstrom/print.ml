let print_stderr message =
  output_string stderr message;
  output_string stderr "\n";
  flush stderr
;;

let print_stdout message = print_endline message
