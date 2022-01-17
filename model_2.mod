# Default data
param number_of_laps;
set laps := 1..number_of_laps;
set tyre_compounds;

param tyre_change_time;
param minimum_number_of_different_tyre_compounds;
param time_loss_from_tyre_compounds_degradation{tyre_compounds};
param tyre_compounds_life_time{tyre_compounds};
param tyre_compounds_base_lap_time{tyre_compounds};

param M := 1000;

# Variable
var use{laps, tyre_compounds} binary;
var tyre_change{laps} binary;
var used_compound{tyre_compounds} binary;
var lap_time{laps} >= 0; # float

# Constraints
s.t. One_tyre_compound_in_each_lap{lap in laps}:
    sum{tyre in tyre_compounds} use[lap, tyre] = 1;

s.t. Tyre_compound_change{
    lap in laps, tyre1 in tyre_compounds, tyre2 in tyre_compounds: 
    lap != number_of_laps && tyre1 != tyre2
}:
# If use[lap, tyre1] && use[lap+1, tyre2], then tyre_change[lap] = 1;
    tyre_change[lap] 
    >= 
    -1 + use[lap, tyre1] + use[lap+1, tyre2];

s.t. Max_tyre_compound_life_time{
    lap1 in laps, lap2 in laps, tyre in tyre_compounds: 
    lap2 == lap1 + tyre_compounds_life_time[tyre]
}:
# If use[lap1, tyre] && use[lap2, tyre], 
# then sum{lap in Laps : lap >= lap1 && lap < lap2} tyre_change[lap] >= 1
    sum{lap in laps: lap >= lap1 && lap < lap2} tyre_change[lap] 
    >=  
    -1 + use[lap1, tyre] + use[lap2, tyre];

s.t. Add_value_to_used_compound_1{tyre in tyre_compounds}:
# If sum{lap in laps} use[lap, tyre] == 0, then used_compound[tyre] = 0
    used_compound[tyre] <= sum{lap in laps} use[lap, tyre]; 

s.t. Add_value_to_used_compound_2{tyre in tyre_compounds}:
# If sum{lap in laps} use[lap, tyre] / laps >= 0, then used_compound[tyre] = 1
    used_compound[tyre] >= sum{lap in laps} use[lap, tyre] / number_of_laps;

s.t. Minimum_tyre_compounds:
    sum{tyre in tyre_compounds} used_compound[tyre] >= minimum_number_of_different_tyre_compounds;

s.t. First_lap_time_1{lap in laps, tyre in tyre_compounds: lap == 1}:
# If use[lap, tyre], then lap_time[lap] >= tyre_compounds_base_lap_time[tyre]
    lap_time[lap] >= tyre_compounds_base_lap_time[tyre] - M * (1 - use[lap, tyre]);

s.t. Add_base_lap_and_tyre_change_time_to_lap_time{lap in laps, tyre in tyre_compounds: lap != 1}:
# If use[lap, tyre] && tyre_change[lap-1], then lap_time[lap] >= tyre_compounds_base_lap_time[tyre]
    lap_time[lap] 
    >= 
    tyre_compounds_base_lap_time[tyre] + tyre_change_time
    - M * (2 - use[lap, tyre] - tyre_change[lap-1]);

s.t. Add_calculated_time_to_lap_time{lap in laps, tyre in tyre_compounds: lap != 1}:
# If use[lap, tyre], then lap_time[lap] >= tyre_compounds_base_lap_time[tyre] + time_loss_from_tyre_compounds_degradation[tyre]
    lap_time[lap] 
    >= 
    lap_time[lap-1] + time_loss_from_tyre_compounds_degradation[tyre]
    - M * (1 - use[lap, tyre]);

# Objective function
minimize Total_time: 
    sum{lap in laps} lap_time[lap];

solve;
printf "\nLap tyres:\nStart-";
for{lap in laps, tyre in tyre_compounds: use[lap, tyre]}
{
    printf "%s-", tyre;
}
printf "Finish\n\n";
printf "Lap times:\nStart-";
for{lap in laps}
{
    printf "%.3f-", lap_time[lap];
}
printf "Finish\n\n";

end;