open Maelstrom

let handle_broadcast msg =
  let value = Message.get_broadcasted_value msg in
  Node.set_state [ value ];
  Node.send
    (Message.get_sender msg)
    (`Assoc
      [ "type", `String "broadcast_ok"
      ; "msg_id", `Int (Message.get_msg_id msg)
      ; "in_reply_to", `Int (Message.get_msg_id msg)
      ]);
  let broadcast () =
    let state = Node.read_state () in
    let peer_nodes = Node.get_node_ids () in
    peer_nodes
    |> List.iter (fun node ->
         Node.send
           node
           (`Assoc
             [ "type", `String "update_state"
             ; "messages", `List (List.map (fun v -> `Int v) state)
             ]))
  in
  broadcast ();
  ()
;;

let handle_topology msg =
  msg |> Message.get_topology |> Node.update_topology;
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

let handle_update_vals msg =
  Message.get_broadcasted_state msg |> Node.set_state;
  ()
;;

let () =
  Maelstrom.run (fun msg ->
    match Message.get_type msg with
    | "broadcast" -> handle_broadcast msg
    | "read" -> handle_read msg
    | "topology" -> handle_topology msg
    | "update_state" -> handle_update_vals msg
    | _ -> ())
;;
