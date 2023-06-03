let print_to_stderr message =
  output_string stderr message;
  flush stderr