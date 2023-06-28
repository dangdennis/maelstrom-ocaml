module Protocol = Protocol
module Message = Message
module Print = Print
module Node = Node
module Crdt = Crdt

module MessageProcessor = struct
  let handle_init message =
    try
      Message.get_node_id message |> Node.set_node_id;
      Message.get_node_ids message |> Node.update_topology;
      let node_id = Node.get_node_id () in
      Print.print_stderr ("Node " ^ node_id ^ " initialized");
      Protocol.yojson_of_init_ok_message
        { src = node_id
        ; dest = Message.get_sender message
        ; body = { typ = "init_ok"; in_reply_to = Message.get_msg_id message }
        }
      |> Yojson.Safe.to_string
      |> Print.print_stdout;
      ()
    with
    | exn -> Printexc.to_string exn |> print_endline
  ;;

  let handle message handler =
    match Message.get_type message with
    | "init" ->
      handle_init message;
      handler message
    | _ -> handler message
  ;;
end

let run ?(log = false) handler =
  Print.print_stderr "Node running...";
  let rec loop () =
    let line = input_line stdin in
    let message = Yojson.Safe.from_string line in
    if log then Print.print_stderr ("Received: " ^ line);
    MessageProcessor.handle message handler;
    loop ()
  in
  loop ()
;;
