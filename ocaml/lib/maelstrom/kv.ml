let counter_mvar = Kcas_data.Mvar.create (Some 0)
let read () = Kcas_data.Mvar.peek counter_mvar

let increment value =
  let next_value = read () + value in
  Kcas_data.Mvar.put counter_mvar next_value
;;
