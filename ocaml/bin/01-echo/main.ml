open Maelstrom

let handle_echo msg =
  let open Yojson.Safe.Util in
  Node.reply
    msg
    (`Assoc
      [ "type", `String "echo_ok"
      ; "msg_id", `Int (Message.get_msg_id msg)
      ; "in_reply_to", `Int (Message.get_msg_id msg)
      ; "echo", `String (msg |> member "body" |> member "echo" |> to_string)
      ]);
  ()
;;

let () =
  Maelstrom.run (fun msg ->
    match Message.get_type msg with
    | "echo" -> handle_echo msg
    | _ -> ())
;;
