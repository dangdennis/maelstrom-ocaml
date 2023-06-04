open Maelstrom

let handle_add msg =
  let _delta = Message.get_add_delta msg in
  Node.send ~log:true (Message.get_sender msg) (`Assoc [ "type", `String "add_ok" ]);
  ()
;;

let handle_read msg =
  Node.send (Message.get_sender msg) (`Assoc [ "type", `String "read_ok"; "value", `Int 1234 ]);
  ()
;;

let () =
  Maelstrom.run ~log:true (fun msg ->
    match Message.get_type msg with
    | "add" -> handle_add msg
    | "read" -> handle_read msg
    | _ -> ())
;;
