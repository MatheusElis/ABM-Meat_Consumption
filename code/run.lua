require "EMC_model"
import("calibration")

mr = MultipleRuns{
    model = EMC,
    -- repetition = 10,
    parameters = {
         meat_price_increase = Choice{min = 1., max = 1.2, step = 0.05},
    },
}
    

mr.output:save("result.csv")
file = File("run.csv")
file:write(dt, ",") 