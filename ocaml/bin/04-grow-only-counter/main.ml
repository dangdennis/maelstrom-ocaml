open Maelstrom

let handle_add msg =
  let delta = Message.get_add_delta msg in
  Print.print_stderr ("delta " ^ string_of_int delta);
  Kv.increment delta;
  Node.send ~log:true (Message.get_sender msg) (`Assoc [ "type", `String "add_ok" ]);
  ()
;;

let handle_read msg =
  let count = Kv.read () in
  Print.print_stderr ("count " ^ string_of_int count);
  Node.send
    (Message.get_sender msg)
    (`Assoc [ "type", `String "read_ok"; "value", `Int count ]);
  ()
;;

let () =
  Maelstrom.run ~log:true (fun msg ->
    match Message.get_type msg with
    | "add" -> handle_add msg
    | "read" -> handle_read msg
    | _ -> ())
;;
