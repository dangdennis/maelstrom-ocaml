module Protocol = Protocol
module Message = Message
module Print = Print

let node_id = ref ""
let node_ids : string list ref = ref []

module Node = struct
  let get_node_id () = !node_id
  let get_node_ids () = !node_ids
end

module MessageProcessor = struct
  let handle_init message =
    try
      node_id := Message.get_node_id message;
      node_ids := Message.get_node_ids message;
      Print.print_stderr ("Node " ^ !node_id ^ " initialized");
      let reply_msg : Protocol.init_ok_message =
        { src = !node_id
        ; dest = Message.get_sender message
        ; body = { typ = "init_ok"; in_reply_to = Message.get_msg_id message }
        }
      in
      Print.print_stdout
        (Protocol.yojson_of_init_ok_message reply_msg |> Yojson.Safe.to_string);
      ()
    with
    | exn -> Printexc.to_string exn |> print_endline
  ;;

  let handle message handler =
    match Message.get_type message with
    | "init" -> handle_init message
    | _ -> handler message
  ;;
end

let run handler =
  Print.print_stderr "Node running...";
  let rec loop () =
    let line = input_line stdin in
    let message = Yojson.Safe.from_string line in
    Print.print_stderr ("Received: " ^ line);
    MessageProcessor.handle message handler;
    loop ()
  in
  loop ()
;;
