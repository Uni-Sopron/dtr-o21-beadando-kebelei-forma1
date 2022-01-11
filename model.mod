# Default data
param number_of_laps;
set race_length := 1..number_of_laps;
set lap_options;
set tyre_compounds;

param base_lap_time;
param tyre_change_time;
param minimum_number_of_different_tyre_compounds;
param tyre_compounds_degradation{tyre_compounds};
param tyre_compounds_life_time{tyre_compounds};
