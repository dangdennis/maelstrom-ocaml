let counter_acc = Kcas_data.Accumulator.make 0
let read () = Kcas_data.Accumulator.get counter_acc
let increment value = Kcas_data.Accumulator.add counter_acc value
