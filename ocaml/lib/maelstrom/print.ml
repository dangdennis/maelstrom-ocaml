let print_stderr message =
  output_string stderr message;
  flush stderr
;;

let print_stdout message =
  output_string stdout message;
  flush stdout
;;
