-- Define the items with their respective names
local ITEMS = {
   DIGITAL_MINER = "mekanism:machineblock",
   QUANTUM_ENTANGLOPORTER = "mekanism:machineblock3",
   ULTIMATE_LOGISTICAL_CABLE = "mekanism:transmitter",
   RF_CHARGER = "peripheralsplusone:rf_charger"
}

local miner = peripheral.wrap("top")

-- Function to select an item by its name
function utils_select_item(item_name)
   for slot = 1, 16 do
       local item_details = turtle.getItemDetail(slot)
       if item_details and item_details.name == item_name then
           turtle.select(slot)
           print("Selected '" .. item_name .. "' in slot " .. slot)
           return slot
       end
   end
   return nil
end

-- Test Function 1: Preparing placement area
function clearing_stage()
   print("Executing clearing_stage: Clearing the area.")
   turtle.digUp()
   turtle.turnRight()
   turtle.dig()
   turtle.forward()
   turtle.digUp()
   turtle.up()
   turtle.digUp()
   turtle.turnLeft()
   turtle.forward()
   turtle.forward()
   turtle.turnLeft()
   turtle.forward()
   turtle.forward()
   turtle.digUp()
   turtle.turnLeft()
   turtle.forward()
   turtle.forward()
   turtle.down()
   turtle.turnLeft()
   turtle.turnLeft()
   print("clearing_stage completed.")
end

-- Test Function 2: Clearing path
function clearing_path()
   print("Executing clearing_path: Clearing path.")
   for i = 1, 64 do
       if turtle.dig() then
           print("Dug block at step " .. i)
       else
           print("No block to dig at step " .. i)
       end

       if turtle.forward() then
           print("Moved forward to step " .. i)
       else
           print("Failed to move forward at step " .. i)
           break
       end
   end
   print("clearing_path completed.")
end


function digging_a_level_in_room()
   turtle.dig()
   turtle.forward()
   turtle.turnRight()
   turtle.dig()
   turtle.forward()
   turtle.turnRight()
   turtle.dig()
   turtle.forward()
   turtle.dig()
   turtle.forward()
   turtle.turnRight()
   turtle.dig()
   turtle.forward()
   turtle.dig()
   turtle.forward()
   turtle.turnRight()
   turtle.dig()
   turtle.forward()
   turtle.dig()
   turtle.forward()
   turtle.dig()
   turtle.forward()
   turtle.turnRight()
   turtle.dig()
   turtle.forward()
   turtle.dig()
   turtle.forward()
   turtle.dig()
   turtle.forward()
   turtle.turnRight()
   turtle.dig()
   turtle.forward()
   turtle.dig()
   turtle.forward()
   turtle.dig()
   turtle.forward()
   turtle.dig()
   turtle.forward()
   turtle.turnRight()
   turtle.dig()
   turtle.forward()
   turtle.dig()
   turtle.forward()
   turtle.dig()
   turtle.forward()
   turtle.dig()
   turtle.forward()
   turtle.turnRight()
   turtle.dig()
   turtle.forward()
   turtle.dig()
   turtle.forward()
   turtle.dig()
   turtle.forward()
   turtle.dig()
   turtle.forward()
   turtle.turnRight()
   turtle.forward()
   turtle.forward()
   turtle.turnRight()
   turtle.forward()
   turtle.forward()
   turtle.turnRight()
   turtle.turnRight()
end

function clear_a_room()
   digging_a_level_in_room()
   turtle.digUp()
   turtle.up()
   digging_a_level_in_room()
   turtle.digUp()
   turtle.up()
   digging_a_level_in_room()
   turtle.down()
   turtle.down()
end

-- Test Function 3: Placing items in correct order
function block_placements()
   print("Executing block_placements: Placing items.")

   -- Select and place Digital Miner
   local miner_slot = utils_select_item(ITEMS.DIGITAL_MINER)
   if miner_slot then
       if turtle.placeUp() then
           print("Placed Digital Miner.")
       else
           print("Failed to place Digital Miner.")
           return
       end
   else
       print("Cannot place Digital Miner: Item not found.")
       return
   end

   turtle.forward()
   turtle.forward()
   turtle.up()

   local entangloporter_slot = utils_select_item(ITEMS.QUANTUM_ENTANGLOPORTER)
   if entangloporter_slot then
       turtle.placeUp()
   end

   turtle.turnRight()
   turtle.forward()
   turtle.forward()
   turtle.turnRight()
   turtle.forward()

   local entangloporter_slot = utils_select_item(ITEMS.QUANTUM_ENTANGLOPORTER)
   if entangloporter_slot then
       turtle.place()
   end

   turtle.down()

   local charger_slot = utils_select_item(ITEMS.RF_CHARGER)
   if charger_slot then
       turtle.place()
   end

   -- Return to starting position
   turtle.turnRight()
   turtle.forward()
   turtle.turnLeft()
   turtle.forward()
   turtle.turnRight()
   turtle.turnRight()
   print("block_placements completed.")
end
   
-- Main Function: Execute all tests in sequence
function main()
   print("Starting Advanced Mining Turtle script.")
   local mining_speed = 2.5 -- Blocks per second
   local buffer_time = 30   -- Buffer time in seconds

   while true do
       local status, err = pcall(function()
           print("Loop start")
           local miner = peripheral.wrap("top")
           if not miner then
               error("Digital Miner not found on 'top'. Check the side.")
           end

           -- Get the number of blocks left to mine
           local blocksLeft = miner.getToMine()
           print("Blocks left to mine: " .. blocksLeft)

           if blocksLeft > 0 then
               -- Calculate the estimated mining time
               local estimated_time = math.ceil(blocksLeft / mining_speed)
               local total_wait_time = estimated_time + buffer_time

               print("Estimated mining time: " .. estimated_time .. " seconds.")
               print("Waiting for " .. total_wait_time .. " seconds (including buffer).")

               -- Wait for the estimated time plus buffer
               os.sleep(total_wait_time)

               -- Stop and reset the miner
               miner.stop()
               miner.reset()
               print("Miner stopped and reset.")

               -- Start the placement and digging tasks
               clearing_stage()
               clearing_path()
               clear_a_room()
               block_placements()

               -- Drop items that are not part of the ITEMS list
               for slot = 1, 16 do
                   local item_details = turtle.getItemDetail(slot)
                   if item_details then
                       local is_valid_item = false
                       for _, valid_item in pairs(ITEMS) do
                           if item_details.name == valid_item then
                               is_valid_item = true
                               break
                           end
                       end
                       if not is_valid_item then
                           turtle.select(slot)
                           turtle.drop()
                           print("Dropped item: " .. item_details.name .. " from slot " .. slot)
                       end
                   end
               end

               -- Start the miner again
               print("Starting the miner.")
               miner.start()
               os.sleep(5)
           else
               print("No blocks left to mine. Waiting for a while before rechecking...")
               os.sleep(30)
           end
           print("Loop end")
       end)

       if not status then
           print("Error encountered: " .. err)
           os.sleep(5)
       end
   end
end

main()