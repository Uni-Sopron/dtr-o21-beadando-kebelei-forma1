# Default data
param number_of_laps;
set race_length := 1..number_of_laps;
set tyre_compounds;

param tyre_change_time;
param minimum_number_of_different_tyre_compounds;
param tyre_compounds_degradation{tyre_compounds};
param tyre_compounds_life_time{tyre_compounds};
param tyre_compounds_base_lap_time{tyre_compounds};

# Variable
var use{race_length, tyre_compounds} binary;
var tyre_change{race_length} binary;
var used_compound{tyre_compounds} binary;

# Constraints
s.t. One_tyre_compound_in_each_lap{lap in race_length}:
    sum{tyre in tyre_compounds} use[lap, tyre] = 1;

s.t. Tyre_compound_change{
    lap in race_length, tyre1 in tyre_compounds, tyre2 in tyre_compounds: 
    lap != number_of_laps && tyre1 != tyre2
}:
# If use[lap, tyre1] == 1 && use[lap+1, tyre2] == 1, then tyre_change[lap] = 1;
# If use[lap, tyre1] && use[lap+1, tyre2], then tyre_change[lap] = 1;
    tyre_change[lap] 
    >= 
    -1 + use[lap, tyre1] + use[lap+1, tyre2];

s.t. Max_tyre_compound_life_time{
    lap1 in race_length, lap2 in race_length, tyre in tyre_compounds: 
    lap2 == lap1 + tyre_compounds_life_time[tyre]
}:
# If use[lap1, tyre] == 1 and use[lap2, tyre] == 1, then lap2=1 ∑ lap1 tyre_change[lap] >= 1 
# If use[lap1, tyre] && use[lap2, tyre], then sum{lap in Laps : lap >= lap1 && lap < lap2} tyre_change[lap] >= 1
    sum{lap in race_length: lap >= lap1 && lap < lap2} tyre_change[lap] 
    >=  
    -1 + use[lap1, tyre] + use[lap2, tyre];
    
#
s.t. Giving_value_to_used_compound{
    lap in race_length, tyre1 in tyre_compounds, tyre2 in tyre_compounds:
    lap != number_of_laps && tyre1 != tyre2
}:
## If use[lap, tyre1] == 1 && use[lap+1, tyre2] == 1, then tyre_change[lap] = 1;
## If use[lap, tyre1] && use[lap+1, tyre2], then tyre_change[lap] = 1;
    used_compound[tyre2] 
    >= 
    -1 + use[lap, tyre2] + use[lap+1, tyre2];

s.t. Minimum_tyre_compounds:
    sum{tyre in tyre_compounds} used_compound[tyre] >= minimum_number_of_different_tyre_compounds;

# Objective function
minimize Total_time: 
    sum{lap in race_length, tyre in tyre_compounds} use[lap, tyre] * tyre_compounds_base_lap_time[tyre]
    + sum{lap in race_length}tyre_change[lap] * tyre_change_time;

solve;
printf "\nLaps:\nStart-";
for{lap in race_length, tyre in tyre_compounds: use[lap, tyre] == 1}
{
    printf "%s-", tyre;
}
printf "Finish\n\n";

end;