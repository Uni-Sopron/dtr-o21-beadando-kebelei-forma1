# Default data
param number_of_laps;
set race_length := 1..number_of_laps;
set race_length2 := 1..number_of_laps-1;
set tyre_compounds;

param tyre_change_time;
param minimum_number_of_different_tyre_compounds;
param tyre_compounds_degradation{tyre_compounds};
param tyre_compounds_life_time{tyre_compounds};
param tyre_compounds_base_lap_time{tyre_compounds};

param M := 1000;

# Variable
var use{race_length, tyre_compounds} binary;
var tyre_change{race_length} binary;
var used_compound{tyre_compounds} binary;

# Constraints
s.t. One_tyre_compound_in_each_lap{lap in race_length}:
    sum{tyre in tyre_compounds} use[lap, tyre] = 1;

s.t. Tyre_change{lap in race_length2, tyre1 in tyre_compounds, tyre2 in tyre_compounds}:
# If use[lap, tyre1] == 1 && use[lap+1, tyre2] == 1, then tyre_change[lap] = 1 and used_compound[tyre2] = 1;
# If use[lap, tyre1] && use[lap+1, tyre2], then tyre_change[lap] + used_compound[tyre2] = 2;
    tyre_change[lap] + used_compound[tyre2] <= 2 + M * ( 2 - use[lap, tyre1] - use[lap+1, tyre2]);

s.t. Minimum_tyre_compounds:
    sum{tyre in tyre_compounds} used_compound[tyre] >= minimum_number_of_different_tyre_compounds;

# Objective function
minimize Total_time: 
    sum{lap in race_length, tyre in tyre_compounds} use[lap, tyre] * tyre_compounds_base_lap_time[tyre] + sum{lap in race_length}tyre_change[lap] * tyre_change_time;

solve;
printf "\nLaps:\nStart-";
for{lap in race_length, tyre in tyre_compounds: use[lap, tyre]}
{
    printf "%s-", tyre;
}
printf "Finish\n\n";

end;