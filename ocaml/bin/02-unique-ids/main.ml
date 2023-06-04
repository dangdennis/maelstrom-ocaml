open Maelstrom

let handle_generate msg =
  Node.send
    (Message.get_sender msg)
    (`Assoc
      [ "type", `String "generate_ok"
      ; "msg_id", `Int (Message.get_msg_id msg)
      ; "in_reply_to", `Int (Message.get_msg_id msg)
      ; "id", `String (Node.generate_node_id ())
      ]);
  ()
;;

let () =
  Maelstrom.run (fun msg ->
    match Message.get_type msg with
    | "generate" -> handle_generate msg
    | _ -> ())
;;
