type 'a message =
  { src : string
  ; dest : string
  ; body : 'a
  }
[@@deriving yojson]

type init_message_body =
  { typ : string [@key "type"]
  ; node_id : string
  ; nodes : string array [@key "node_ids"]
  ; msg_id : int
  }
[@@deriving yojson]

type init_message = init_message_body message [@@deriving yojson]

type init_ok_message_body =
  { typ : string [@key "type"]
  ; in_reply_to : int
  }
[@@deriving yojson]

type init_ok_message = init_ok_message_body message [@@deriving yojson]

type error_message_body =
  { typ : string [@key "type"]
  ; code : int
  ; text : string
  }
[@@deriving yojson]

type error_message = error_message_body message [@@deriving yojson]

let get_type msg =
  msg
  |> Yojson.Safe.Util.member "body"
  |> Yojson.Safe.Util.member "type"
  |> Yojson.Safe.Util.to_string
;;
