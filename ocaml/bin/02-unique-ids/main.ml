open Maelstrom

let handle_generate msg =
  let reply =
    `Assoc
      [ "src", `String (Node.get_node_id ())
      ; "dest", `String (Message.get_sender msg)
      ; ( "body"
        , `Assoc
            [ "type", `String "generate_ok"
            ; "msg_id", `Int (Message.get_msg_id msg)
            ; "in_reply_to", `Int (Message.get_msg_id msg)
            ; "id", `String (Node.generate_node_id ())
            ] )
      ]
  in
  Print.print_stderr (Yojson.to_string reply);
  Print.print_stdout (Yojson.to_string reply);
  ()
;;

let () =
  Maelstrom.run (fun msg ->
    match Message.get_type msg with
    | "generate" -> handle_generate msg
    | _ -> ())
;;
