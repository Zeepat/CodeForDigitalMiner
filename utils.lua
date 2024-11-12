function utils_get_peripheral_wrap(name)
    local list = peripheral.getNames()
    
        for _, side in pairs(list) do
            local type = peripheral.getType(side)
            
            if type == name then
               return peripheral.wrap(side)
            end
        end   
    return nil
end

function utils_is_chunky_turtle()
    local list = peripheral.getNames()
    
    for _, side in pairs(list) do
        local type = peripheral.getType(side)
    
        if string.find(type, "chunky") then
            return true
        end
    end
    return false
end

function utils_get_time(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local remaining_seconds = seconds % 60
      
    return string.format("%02d:%02d:%02d", hours, minutes, remaining_seconds)
end

function utils_go_one_chunk()
    -- Turn and move to the next miner position in the grid
    turtle.turnRight()

    for j = 1, 64 do
        turtle.forward() -- Move 16 blocks (1 chunk)
    end

    -- Adjust direction for next row
    turtle.turnLeft()
    turtle.forward()
    turtle.turnLeft()
end


function utils_select_item(item_name)
	for i = 1, 16 do
		local item_details = turtle.getItemDetail(i)

		if item_details and item_details.name == item_name then
		   return true, i
		end
	end

	return false, -1
end

function utils_place_blocks(Blocks, GlobalVars)
    -- Select and place the Digital Miner
    local has_miner, miner_block_index = utils_select_item(Blocks.BLOCK_MINER)
    if has_miner then
        turtle.select(miner_block_index)
        turtle.placeUp() -- Place Digital Miner
        turtle.turnRight()
        turtle.forward()
        turtle.forward()
        turtle.turnLeft()

        -- Select and place the Quantum Entangloporter (QEP)
        local has_energy_block, energy_block_index = utils_select_item(Blocks.BLOCK_ENERGY)
        if has_energy_block then
            turtle.select(energy_block_index)
            turtle.placeUp() -- Place QEP

            -- Move up to place the elevated cables
            turtle.up()
            local has_cable, cable_index = utils_select_item("mekanism:ultimate_universal_cable")

            if has_cable then
                turtle.select(cable_index)
                turtle.placeDown() -- Place the cable directly above QEP

                -- Place the remaining elevated cables
                for _ = 1, 4 do
                    turtle.forward()
                    turtle.placeDown() -- Place elevated cable
                end
            end

            -- Return to the level of the QEP
            turtle.back()
            turtle.back()
            turtle.back()
            turtle.back()
            turtle.down()

            -- Place the storage block
            local has_storage_block, storage_block_index = utils_select_item(Blocks.BLOCK_STORAGE)
            if has_storage_block then
                turtle.select(storage_block_index)
                turtle.placeUp() -- Place storage block

                

                -- Place the Chat Box if available
                local has_chatbox_block, chatbox_block_index = utils_select_item(Blocks.BLOCK_CHATBOX)
                if has_chatbox_block then
                    GlobalVars.m_bHasChatBox = true
                    turtle.select(chatbox_block_index)
                    turtle.placeUp() -- Place chat box
                end
            end

            os.sleep(0.3)

            -- Wrap peripherals for interaction
            GlobalVars.m_pChatBox = utils_get_peripheral_wrap("chatBox")
            GlobalVars.m_pMiner = utils_get_peripheral_wrap("digitalMiner")
        end
    end
end



function utils_destroy_blocks(GlobalVars)
    if GlobalVars.m_bHasChatBox then
        turtle.digUp() -- Remove the chat box
    end

    if not GlobalVars.m_bIsChunkyTurtle then
        turtle.turnLeft()
    end

    -- Remove Digital Miner
    turtle.dig()
    turtle.forward()
    turtle.forward()
    turtle.forward()

    -- Remove Quantum Entangloporter
    turtle.dig()

    -- Move up to remove the cables (including the one above the QEP)
    turtle.up()
    for _ = 1, 5 do
        turtle.digDown() -- Remove cable
        turtle.forward()
    end

    -- Move back to the starting position
    turtle.back()
    turtle.back()
    turtle.back()
    turtle.back()
    turtle.turnLeft()
    turtle.forward()
    turtle.forward()
    turtle.up()
    turtle.turnLeft()
    turtle.dig() -- Remove storage block

    

    turtle.down()
    turtle.down()
end
