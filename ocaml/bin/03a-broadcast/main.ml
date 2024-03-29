open Maelstrom

let handle_broadcast msg =
  Node.set_state [ Message.get_broadcasted_value msg ];
  Node.send
    (Message.get_sender msg)
    (`Assoc
      [ "type", `String "broadcast_ok"
      ; "msg_id", `Int (Message.get_msg_id msg)
      ; "in_reply_to", `Int (Message.get_msg_id msg)
      ]);
  ()
;;

let handle_topology msg =
  (* @todo msg should update node's known topology *)
  Node.send
    (Message.get_sender msg)
    (`Assoc
      [ "type", `String "topology_ok"
      ; "msg_id", `Int (Message.get_msg_id msg)
      ; "in_reply_to", `Int (Message.get_msg_id msg)
      ]);
  ()
;;

let handle_read msg =
  Node.send
    (Message.get_sender msg)
    (`Assoc
      [ "type", `String "read_ok"
      ; "msg_id", `Int (Message.get_msg_id msg)
      ; "in_reply_to", `Int (Message.get_msg_id msg)
      ; "messages", `List (Node.read_state () |> List.map (fun v -> `Int v))
      ]);
  ()
;;

let () =
  Maelstrom.run (fun msg ->
    match Message.get_type msg with
    | "broadcast" -> handle_broadcast msg
    | "read" -> handle_read msg
    | "topology" -> handle_topology msg
    | _ -> ())
;;
