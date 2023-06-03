module Protocol = Protocol

let node_id = ref ""
let node_ids = ref []

module MessageProcessor = struct
  open Yojson.Safe

  let reply _dest _body = ()

  let handle_init message =
    try
      let init_msg = Protocol.init_message_of_yojson message in
      node_id := init_msg.body.node_id;
      node_ids := init_msg.body.nodes |> Array.to_list;
      Print.print_stderr ("Node " ^ !node_id ^ " initialized\n");
      let reply_msg : Protocol.init_ok_message =
        { src = !node_id
        ; dest = init_msg.src
        ; body = { typ = "init_ok"; in_reply_to = init_msg.body.msg_id }
        }
      in
      Print.print_stdout
        (Protocol.yojson_of_init_ok_message reply_msg |> Yojson.Safe.to_string)
    with
    | exn -> Printexc.to_string exn |> print_endline
  ;;

  let handle message handler =
    match Util.member "body" message |> Util.member "type" |> Util.to_string with
    | "init" -> handle_init message
    | _ -> handler message
  ;;
end

let run handler =
  Print.print_stderr "Node running...\n";
  let rec loop () =
    let line = input_line stdin in
    let message = Yojson.Safe.from_string line in
    Print.print_stderr ("Received: " ^ line);
    MessageProcessor.handle message handler;
    loop ()
  in
  loop ()
;;
