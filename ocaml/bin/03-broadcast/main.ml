open Maelstrom

(* let handle_echo msg =
  let open Yojson.Safe.Util in
  let get_echo msg = msg |> member "body" |> member "echo" |> to_string in
  let reply =
    `Assoc
      [ "src", `String (Node.get_node_id ())
      ; "dest", `String (Message.get_sender msg)
      ; ( "body"
        , `Assoc
            [ "type", `String "echo_ok"
            ; "msg_id", `Int (Message.get_msg_id msg)
            ; "in_reply_to", `Int (Message.get_msg_id msg)
            ; "echo", `String (get_echo msg)
            ] )
      ]
  in
  Print.print_stderr (Yojson.to_string reply);
  Print.print_stdout (Yojson.to_string reply);
  ()
;; *)

let handle_broadcast _msg = ()
let handle_topology _msg = ()
let handle_read _msg = ()

let () =
  Maelstrom.run (fun msg ->
    match Message.get_type msg with
    | "broadcast" -> handle_broadcast msg
    | "read" -> handle_read msg
    | "topology" -> handle_topology msg
    | _ -> ())
;;