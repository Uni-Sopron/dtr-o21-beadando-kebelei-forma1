# Default data
param number_of_tyre_changes;
param number_of_stages := number_of_tyre_changes + 1;
set stages := 1..number_of_stages;
set tyre_compounds;

param number_of_laps;
param tyre_change_time;
param minimum_number_of_different_tyre_compounds;
param tyre_compounds_life_time{tyre_compounds};
param tyre_compounds_base_lap_time{tyre_compounds};

param M := 10000;

# Variables
var use{stages, tyre_compounds} binary;
var stage_length{stages} integer >= 1;
var used_compound{tyre_compounds} binary;
var stage_time{stages} >= 0;

# Constraints
s.t. One_tyre_compound_in_each_stage{stage in stages}:
    sum{tyre in tyre_compounds} use[stage, tyre] = 1;

s.t. Race_length:
    sum{stage in stages} stage_length[stage] = number_of_laps;

s.t. Max_tyre_compound_life_time{stage in stages, tyre in tyre_compounds}:
# If use[stage, tyre], then stage_length[stage] <= tyre_compounds_life_time[tyre]
    stage_length[stage] <= tyre_compounds_life_time[tyre] + number_of_laps * (1 - use[stage, tyre]); # M = number_of_laps
    
s.t. Add_value_to_used_compound_1{tyre in tyre_compounds}:
# If sum{stage in stages} use[stage, tyre] == 0, then used_compound[tyre] = 0
    used_compound[tyre] <= sum{stage in stages} use[stage, tyre]; 

s.t. Add_value_to_used_compound_2{tyre in tyre_compounds}:
# If sum{stage in stages} use[stage, tyre] / number_of_stages >= 0, then used_compound[tyre] = 1
    used_compound[tyre] >= sum{stage in stages} use[stage, tyre] / number_of_stages;

s.t. Minimum_tyre_compounds:
    sum{tyre in tyre_compounds} used_compound[tyre] >= minimum_number_of_different_tyre_compounds;

s.t. Calculate_lap_time{stage in stages, tyre in tyre_compounds}:
# If use[stage, tyre], then stage_time[stage] >= stage_length[stage] * tyre_compounds_base_lap_time[tyre]
    stage_time[stage] >= stage_length[stage] * tyre_compounds_base_lap_time[tyre] - M * (1 - use[stage, tyre]);

minimize Total_time: 
    sum{stage in stages} stage_time[stage];

solve;
printf "Lap tyres:\nStart-";
for{stage in stages, tyre in tyre_compounds: use[stage, tyre]}
{
    for {lap in 1..stage_length[stage]}
    {
        printf "%s-", tyre;
    }
}
printf "Finish\n\nLaps where there is a tyre change:\n";
for{stage1 in stages: stage1 != number_of_stages}
{
    printf "%s\n", sum{stage2 in stages: stage2 <= stage1} stage_length[stage2];
}
printf "\nTotal time: %g second", Total_time + (number_of_stages - 1) * tyre_change_time;

end;