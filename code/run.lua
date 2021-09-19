
import("calibration")

dt = DataFrame{
    meat_prince_increase = {},
    current_year = {},
    current_week = {},
    current_day = {},
    prob_eat_meat_t0 = {},
    prob_eat_meat_day = {},
    std_meat_day = {},
    tax_meat_day = {},
    low_eat_meat_t0 = {},
    low_prob_eat_meat_day = {},
    low_std_meat_day = {},
    low_tax_meat_day = {},
    hight_eat_meat_t0 = {},
    hight_prob_eat_meat_day = {},
    hight_std_meat_day = {},
    hight_tax_meat_day = {},
    young_eat_meat_t0 = {},
    young_prob_eat_meat_day = {},
    young_std_meat_day = {},
    young_tax_meat_day = {},
    adult_eat_meat_t0 = {},
    adult_prob_eat_meat_day = {},
    adult_std_meat_day = {},
    adult_tax_meat_day = {},
    elder_eat_meat_t0 = {},
    elder_prob_eat_meat_day = {},
    elder_std_meat_day = {},
    elder_tax_meat_day = {}
}
require "EMC_model"
mr = MultipleRuns{
    model = EMC,
    repetition = 50,
    parameters = {
        meat_price_increase = Choice{1.0,1.05,1.10,1.15,1.20},
    },
    save = function(model)
        name = 'file' .. model.meat_price_increase .. '.csv'
        file = File(name)
        file:write(dt, ",")

        dt = DataFrame{
            meat_prince_increase = {},
            current_year = {},
            current_week = {},
            current_day = {},
            prob_eat_meat_t0 = {},
            prob_eat_meat_day = {},
            std_meat_day = {},
            tax_meat_day = {},
            low_eat_meat_t0 = {},
            low_prob_eat_meat_day = {},
            low_std_meat_day = {},
            low_tax_meat_day = {},
            hight_eat_meat_t0 = {},
            hight_prob_eat_meat_day = {},
            hight_std_meat_day = {},
            hight_tax_meat_day = {},
            young_eat_meat_t0 = {},
            young_prob_eat_meat_day = {},
            young_std_meat_day = {},
            young_tax_meat_day = {},
            adult_eat_meat_t0 = {},
            adult_prob_eat_meat_day = {},
            adult_std_meat_day = {},
            adult_tax_meat_day = {},
            elder_eat_meat_t0 = {},
            elder_prob_eat_meat_day = {},
            elder_std_meat_day = {},
            elder_tax_meat_day = {}
        }
    end
}


mr.output:save("result.csv")
