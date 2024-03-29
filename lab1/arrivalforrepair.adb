with Ada.Calendar, Ada.Calendar.Formatting, Ada.Calendar.Time_Zones;
use Ada.Calendar, Ada.Calendar.Formatting, Ada.Calendar.Time_Zones;
with RandFloat; use RandFloat; -- change to use a parameter of the user defined seed
with dual_stack;    --generic stack package
with Ada.Text_Io; use Ada.Text_Io;
with Unchecked_Conversion;

procedure ArrivalForRepair is
   package FloatIO is new Ada.Text_IO.Float_IO(float);
   use FloatIO;
   package IntIO is new Ada.Text_IO.Integer_IO(Integer);
   use IntIO;

  function IntegerToCharacter is new Unchecked_Conversion(Integer, Character);

  Min  : Integer; -- determine the size
  Max  : Integer; -- of stack to create
  FULL : Integer; -- max number of items in stack

  -- time distribution of arrivals and for recording
  Seconds     : constant Duration  := 1.0;
  Period      : constant Duration  := 5.5; -- time each iteration takes
  Store_Time  : Time := Clock; -- StartTime.RepairRecord
  OpenTime    : Time; -- record the time of shop opening
  -- Next_Cycle  : Time; -- Time which function should be ran

  -- variables used to create the Vehicle_Maintence_Record
  type TypeOfVehicle is (Tie_Fighter, Star_Destroyer); -- .VehicleType

  NameOfVehicle : String(1..6); --.VehicleName

  -- naming of the type
  StarName : String(1..5) := "Star_";
  TieName : String(1..5) := "TieF_";
  Star_int_Identity  : Integer := 64;
  Tie_int_Identity   : Integer := 64;
  Star_char_Identity : Character;
  Tie_char_Identity  : Character;

  -- static duration of time invervals required for repairs per vehicle type
  TieFight_RepairTime : constant Duration := Seconds * 3; -- TimeToRepair.RepairRecord for Tie Fighters
  StarDest_RepairTime : constant Duration := Seconds * 7; -- TimeToRepair.RepairRecord for Star Destroyers

  type Vehicle_Maintence_Record is record
    VehicleType  : TypeOfVehicle; -- enum tie fighter / star destroyer
    VehicleName  : String(1..6); -- range A..Z, a..z
    TimeToRepair : Duration; -- 3 units for TieFighter 7 units for StarDestroyer
    StartTime    : Time; -- time from sys clock
  end record;

  RepairRecord   : Vehicle_Maintence_Record;        -- RepairRecord is value to be pushed/popped

  function NumberNewArrivals return Integer is
      rand_num : float; -- generated by discrete_random
      begin
          rand_num := next_float;  -- 0.0 <= rand_numm <= 1.0.
          if rand_num <= 0.25 then
             return 1;
          elsif rand_num <= 0.5 then
             return 2;
          elsif rand_num <= 0.75 then
             return 3;
          else
             return 4;
          end if;

        end NumberNewArrivals;

  numberArrivals : Integer; -- new vehicles for a given iteration

  function Type_of_Arrival return Integer is
    rand_num : float;
    begin
        rand_num := next_float;
        if rand_num <= 0.75 then -- the ship is a tie fighter
            return 1;
        else -- the ship is a star destroyer
            return 2;
        end if;

    end Type_of_Arrival;

  ArrivalType   :   Integer;

  --variables for data/statistical analysis
  TieKnt     : Integer := 0;    -- number of Tie Fighters currently in stack
  StarKnt    : Integer := 0;    -- number of Star Destroyers currently in stack

  Waiting_Repair : Integer := 0;  -- number of vehicles currently in stack
  DagabaKNT  : Integer := 0;         -- number of times that vehicles have been rejected

  FinishTime : Time; -- print to log when vehicle is popped

  TOTAL_Arrived : Integer := 0;
  Serviced_Vehicles : Integer := 0;  -- number of vehicles' repaird that completed



begin
   put("Enter the lower bound for the stack:      ");   get(Min); put(Min); new_line;
   put("Enter the upper bound bound for the stack: ");  get(Max); put(Max); new_line(2);
   FULL := Max + 1;
   put("Seed for the random number generator: "); new_line;
   put("  Numerics.Discrete_Random Package + RandFloat package");
   new_line(2); delay 1.0;

   declare package RepairLog is new dual_stack(Min, Max, Vehicle_Maintence_Record);
   use RepairLog;

    begin   -- begining of prog output

    OpenTime := Clock; new_line;  --program started/ shop opened
    numberArrivals := 3; -- there are three vehicles waiting to be repaired
    put("Facility opens at:  "); Put_Line(Image(OpenTime)); new_line;
    put("3 vehicles are waiting to be repaired:  "); new_line(2);

    -- Next_Cycle := OpenTime;  -Next_Cycle := Next_Cycle + Period;

    Loop -- create records and push them to the stack
        put("Obtaining vehicle information: "); new_line;
        put("Number of Arrivals:       "); put(numberArrivals); new_line(2);
        for j in 1..numberArrivals loop
            Store_Time := Ada.Calendar.Clock;
            ArrivalType := Type_of_Arrival;
            if ArrivalType = 1 then -- part one TIE FIGHTER
                Tie_int_Identity := Tie_int_Identity + 1;
                if Tie_int_Identity = 91 then
                   Tie_int_Identity := 97;
                elsif Tie_int_Identity = 123 then
                   Tie_int_Identity := 65;
                end if;

                -- part 1.2 concatenation to create VehicleName
           Tie_char_Identity := IntegerToCharacter(Tie_int_Identity);
           NameOfVehicle(1..5) := TieName;---### OVERFLOW CHECK ###---
           NameOfVehicle(6) := Tie_char_Identity;

           -- RepairRecord.VehicleType := Tie_Fighter;  --  RepairRecord.VehicleName := TypeOfVehicle'Pos(0);
           -- part 2 store values into record
           RepairRecord.VehicleType := TypeOfVehicle'Val(0);
           RepairRecord.VehicleName(1..6) := NameOfVehicle;
           RepairRecord.StartTime := Store_Time;
           RepairRecord.TimeToRepair := TieFight_RepairTime;    -- fixed duration

           -- part 3 print summaary of information that is to be stored in stack
           put(RepairRecord.VehicleName); put(" Arrived at:   "); Put_Line(Image(RepairRecord.StartTime)); new_line;

       -- part 4 update counters
        TieKnt := TieKnt + 1; -- counter to provide further statistics in the report
        TOTAL_Arrived := TOTAL_Arrived + 1; new_line;
           ---### OVERepairLogRFLOW CHECK ###---
        Waiting_Repair := TieKnt + StarKnt;
        if Waiting_Repair = FULL then
            Put_Line("STACK IS FULL SEND TO DAGABA SYSTEM");
            DagabaKNT := DagabaKNT + 1;
            put("Referred: "); Put(RepairRecord.VehicleName); put(Image(Store_Time));  new_line;
           if DagabaKNT >= 5 then
                   Put_Line("5 Vehicles have been rejected: Simulation is over.");
                   Put("EXIT SIMULATION");new_line(3);
                   Put_Line("   RESULTS     ");
                   put("       Total runtime of the Repair Facility Simulation:   "); Put_Line(Duration'Image(Ada.Calendar.Clock - OpenTime)); new_line; -- at very end
                   Put_Line("   Traffic Analysis:   ");
                   Put_Line("       Number of Tie Fighter still in the facility:  "); put(TieKnt);
                   Put_Line("       Number of Star Destroyers still in the facility:  "); put(StarKnt);
                   Put_Line("       Total Number of Vehicles in/out of the facility:  "); put(TOTAL_Arrived); new_line;
                   Put_Line("Total number of vehicles servied:  ");  put(Integer'Image(Serviced_Vehicles));
                   exit;
               end if;
           else
               put("Number of vehicles in stack:  ");  Put(Integer'Image(Waiting_Repair)); new_line;
        end if;


           else  --star destroyer  -- part 1
               Star_int_Identity := Star_int_Identity + 1;
               if Star_int_Identity = 91 then
                   Star_int_Identity := 97;
                elsif Star_int_Identity = 123 then
                    Star_int_Identity := 65;
                end if;

                -- part 1.2 concatenation to create VehicleName
                Star_char_Identity := IntegerToCharacter(Star_int_Identity);
                NameOfVehicle(1..5) := StarName;
                NameOfVehicle(6) := Star_char_Identity;

                -- part 2 store values into record
                RepairRecord.VehicleType := TypeOfVehicle'Val(1);
                RepairRecord.VehicleName(1..6) := NameOfVehicle;
                RepairRecord.StartTime := Store_Time;
                RepairRecord.TimeToRepair := StarDest_RepairTime;   -- fixed duration

                -- part
               -- else    -- push TIE tp STACK
                   -- Put_Line("Number of vehicles in stack:  ");  Put(Integer'Image(Waiting_Repair)); 3 print summaary of information that is to be stored in stack
                Put(RepairRecord.VehicleName); put(" Arrived at:   "); Put_Line(Image(RepairRecord.StartTime));
                new_line;
                -- part 4 update counters
                StarKnt := StarKnt + 1; -- counter to provide further statistics in the report
                TOTAL_Arrived := TOTAL_Arrived + 1;

                ---### OVERFLOW CHECK ###---
                -- if RepairLog.Space_Available  then
                Waiting_Repair := TieKnt + StarnKnt;
                if Waiting_Repair = FULL then
                    Put_Line("STACK IS FULL SEND TO DAGABA SYSTEM");
                    DagabaKNT := DagabaKNT + 1;
                    put("Referred: "); Put(RepairRecord.VehicleName); put(Image(Store_Time));  new_line;
                    if DagabaKNT >= 5 then
                        Put_Line("5 Vehicles have been rejected: Simulation is over.");
                        Put_Line("EXIT SIMULATION");new_line(3);
                        Put_Line("   RESULTS     ");
                        put("       Total runtime of the Repair Facility Simulation:   "); Put_Line(Duration'Image(Ada.Calendar.Clock - OpenTime)); new_line; -- at very end
                        Put_Line("   Traffic Analysis:   ");
                        Put_Line("       Number of Tie Fighter still in the facility:  "); put(TieKnt);
                        Put_Line("       Number of Star Destroyers still in the facility:  "); put(StarKnt);
                        Put_Line("       Total Number of Vehicles in/out of the facility:  "); put(TOTAL_Arrived); new_line;
                        Put_Line("Total number of vehicles servied:  ");  put(Integer'Image(Serviced_Vehicles));
                        exit;
                    end if;
                    put("Number of vehicles in stack:  ");  Put(Integer'Image(Waiting_Repair)); new_line;
                end if; -- end if type do this

                --- &&&   POP ITEM FROM STACK  &&&---
    if StarKnt >= 1 then  -- pop STAR DESTROYER
        -- FinishTime := RepairRecord.StartTime + RepairRecord.TimeToRepair;
        FinishTime := RepairRecord.StartTime + StarDest_RepairTime;
        RepairLog.Star_Pop(RepairRecord); -- pop values for good

        StarKnt := StarKnt - 1; -- COUNTER - 1, STAR TOP + 1


        new_line;   -- print repair facility log of maintenced vehicles
        Put_Line("***************************************");
        Put_Line("             Completion Log            ");
        Put_Line("***************************************");
        Put(RepairRecord.VehicleName); put(":          repair completed"); new_line;
        put("Vehicle Type:    "); Put_Line(TypeOfVehicle'Val(1)'Image);
        -- put("Vehicle Type:    "); Put_Line(TypeOfVehicle'Val(0)'Image);
        put("Repair Time:     "); Put_Line(Image(RepairRecord.TimeToRepair));
        put("Arrival time:    "); put(Image(RepairRecord.StartTime)); new_line;
        put("Finish Time:     "); Put(Image(FinishTime)); new_line;
        Put_Line("***************************************");
        new_line;
        put("Number of vehicles in stack:  ");  Put(Integer'Image(Waiting_Repair)); new_line;



    elsif StarKnt = 0 then
    -- elsif Starknt = 0 then -- pop TIE FIGHTER
        FinishTime := RepairRecord.StartTime + RepairRecord.TimeToRepair;
        -- finish time for different lab options can be enum types randomly picked
        RepairLog.Tie_Pop(RepairRecord); -- pop values for good

        TieKnt := TieKnt - 1;

        new_line;   -- print repair facility log of maintenced vehicles
        Put_Line("***************************************");
        Put_Line("             Completion Log            ");
        Put_Line("***************************************");
        Put(RepairRecord.VehicleName); put(":          repair completed"); new_line;
        put("Vehicle Type:    "); Put_Line(TypeOfVehicle'Val(0)'Image);
        put("Repair Time:     "); Put_Line(Image(RepairRecord.TimeToRepair));
        put("Arrival time:    "); Put_Line(Image(RepairRecord.StartTime));
        put("Finish Time:     "); Put_Line(Image(FinishTime));
        Put_Line("***************************************");
        new_line;
        put("Number of vehicles in stack:  ");  Put(Integer'Image(Waiting_Repair)); new_line;

    end if; -- end loop for operations on specific type of vehicle
        Serviced_Vehicles := Serviced_Vehicles + 1;
        -- numberArrivals := NumberNewArrivals;
        numberArrivals := NumberNewArrivals;
        delay 2.0; -- delay to prepare the next vehicle

    end if;
end loop; -- for loop:  number of arrivlas



-- end loop;

-- end loop;

end ArrivalForRepair;
