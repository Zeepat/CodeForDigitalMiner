-- User Settings Area --
Settings = {}
Settings.MAX_CHUNKS = 16 -- The amount of chunks this script will run. (Default 16)
Settings.SEND_TO_CHAT = true -- Set this to false if you don't wish for the chatbox to send serverwide messages about the mining status.

Blocks = {}
Blocks.BLOCK_MINER = "mekanism:digital_miner"
Blocks.BLOCK_ENERGY = "mekanism:quantum_entangloporter" -- Edit this to match your desired block.
Blocks.BLOCK_STORAGE = "mekanism:quantum_entangloporter" -- Edit this to match your desired block.
Blocks.BLOCK_CHATBOX = "advancedperipherals:chat_box" -- Edit this only if you are porting to newer/older versions.
-- User Settings Area --

-- Initialization Area --
GlobalVars = {}
GlobalVars.m_pMiner = nil
GlobalVars.m_pChatBox = nil
GlobalVars.m_bIsChunkyTurtle = utils_is_chunky_turtle() or peripheral.getType("right") == "advancedMiningTurtle" or peripheral.getType("left") == "advancedMiningTurtle"
GlobalVars.m_bHasChatBox = false

function main(i)
   -- Load utils.lua
   dofile("utils.lua")

   -- Check if the Turtle is a Chunky Turtle or Advanced Mining Turtle
   GlobalVars.m_bIsChunkyTurtle = utils_is_chunky_turtle() or peripheral.getType("right") == "advancedMiningTurtle" or peripheral.getType("left") == "advancedMiningTurtle"

   utils_place_blocks(Blocks, GlobalVars)

   os.sleep(0.15)

   if GlobalVars.m_pMiner then
      GlobalVars.m_pMiner.start()

      local to_mine_cached = GlobalVars.m_pMiner.getToMine()

      while GlobalVars.m_pMiner.isRunning() do
         local to_mine = GlobalVars.m_pMiner.getToMine()
         local seconds = (to_mine * 0.5)

         if GlobalVars.m_pChatBox and Settings.SEND_TO_CHAT then
            local percentage = (to_mine / to_mine_cached) * 100
            percentage = math.floor(percentage)

            if utils_percentage_in_range(percentage, 80, 1) then
               local text = string.format("20%% of Blocks Mined (%d/%d)", to_mine, to_mine_cached)
               GlobalVars.m_pChatBox.sendMessage(text, "Miner")
               os.sleep(2)
            end

            if utils_percentage_in_range(percentage, 50, 1) then
               local text = string.format("50%% of Blocks Mined (%d/%d)", to_mine, to_mine_cached)
               GlobalVars.m_pChatBox.sendMessage(text, "Miner")
               os.sleep(2)
            end

            if utils_percentage_in_range(percentage, 30, 1) then
               local text = string.format("70%% of Blocks Mined (%d/%d)", to_mine, to_mine_cached)
               GlobalVars.m_pChatBox.sendMessage(text, "Miner")
               os.sleep(2)
            end
         end

         if to_mine % 5 == 0 then
            local text = string.format("To mine: %d, ETA: %s", to_mine, utils_get_time(seconds))
            print(text)
         end

         if (to_mine == 0) then
            if GlobalVars.m_pChatBox and Settings.SEND_TO_CHAT then
               local text = string.format("Done (%d/%d) rounds", i, Settings.MAX_CHUNKS)
               GlobalVars.m_pChatBox.sendMessage(text, "Miner")
               os.sleep(1)
            end

            if i == Settings.MAX_CHUNKS and GlobalVars.m_pChatBox and Settings.SEND_TO_CHAT then
               local text = string.format("Pick me up! I am finished!")
               GlobalVars.m_pChatBox.sendMessage(text, "Miner")
               os.sleep(1)
            end

            utils_destroy_blocks(GlobalVars)
            os.sleep(2)
            utils_go_one_chunk()
         end

         os.sleep(0.5)
      end
   end
end

function setup()
   if fs.exists("utils.lua") then
      fs.delete("utils.lua")
      sleep(1)
   end

   shell.run("wget https://raw.githubusercontent.com/Zeepat/CodeForDigitalMiner/refs/heads/main/utils.lua")
   print("utils.lua downloaded successfully.")
   dofile("utils.lua")
end

-- Main Execution Loop
done = false

for i = 1, Settings.MAX_CHUNKS do
   if not done then
      setup()
      done = true
   end

   -- Do not overwrite `GlobalVars.m_bIsChunkyTurtle` here
   GlobalVars.m_bHasChunkLoader = false
   GlobalVars.m_bHasChatBox = false

   print("Starting main function for chunk " .. i)
   main(i)
end
