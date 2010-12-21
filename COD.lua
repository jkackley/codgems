function isgem(iNme)
			if iNme:match("Transmute: Living Elements") then 
				return true;
--			if iNme:match("Dreadstone") or iNme:match("Ametrine") or iNme:match("Eye of Zul") then 
--				return true;
--			elseif iNme:match("King's Amber") or iNme:match("Majestic Zircon") then 
--				return true;
--			elseif iNme:match("Cardinal Ruby") then 
--				return true;
			end
	return false;
end

function isgemexact(iNme)
			if iNme=="Volatile Air" or iNme=="Volatile Fire" or iNme=="Volatile Earth" or iNme=="Volatile Water" then 
				return true;
--			elseif iNme=="King's Amber" or iNme=="Majestic Zircon" then 
--				return true;
--			elseif iNme=="Cardinal Ruby" then 
--				return true;
			end
	return false;
end

SLASH_TRAINALL1 = '/trainall'
function SlashCmdList.TRAINALL(msg,editbox)
	local numServices = GetNumTrainerServices();
	for x=1,numServices do
		BuyTrainerService(x);
	end
end




-- SLASH_JKBUY1 = '/jkbuy'
-- function SlashCmdList.JKBUY(msg,editbox)
	-- --buy num item
	-- local command, rest = msg:match("^(%S*)%s*(.-)$");
	-- local NI=GetMerchantNumItems();
	-- for x=1,NI do
		-- local name=GetMerchantItemInfo(x);
		-- if name:match(rest) then
			-- local stack=GetMerchantItemMaxStack(x);
			-- while command>=0 do
				-- command=command-stack;
				-- BuyMerchantItem(x,stack);
				-- print("Buying ",stack," ",name);
			-- end
		-- end
	-- end
-- end

SLASH_MAKEGEMS1 = '/makegems'

function SlashCmdList.MAKEGEMS(msg,editbox)
	local numSkills = GetNumTradeSkills();
	local x
	local LowestNAName=""
	local LowestNA=99999
	for x=1,numSkills do
		skillName, skillType, numAvailable, isExpanded, serviceType = GetTradeSkillInfo(x);
		if not skillType:match("header") then	
			if numAvailable >0 then
				if isgem(skillName) then			
					print("Polling number of ",skillName,"available: ",numAvailable);
					if LowestNA>numAvailable then
						LowestNA=numAvailable
						LowestNAName=skillName						
					end		
					local cooldown = GetTradeSkillCooldown(x);
					if not cooldown then
						--print("Making a ",skillName);						
					end
				end
			end
		end
	end
	print("The gem with the fewest mats is ",LowestNAName," with ",LowestNA,"mats.")
	for x=1,numSkills do
		skillName, skillType, numAvailable, isExpanded, serviceType = GetTradeSkillInfo(x);
		if not skillType:match("header") then	
			if numAvailable >0 then
				if isgem(skillName) then
					local cooldown = GetTradeSkillCooldown(x);
					if not cooldown then
						--print("Making a ",skillName);
						if skillName==LowestNAName then
							print("Making a ",skillName," (not on CD, Lowest # mats available.) ");						
							DoTradeSkill(x);
						end
					end
				end
			end
		end
	end
end


function isresearchresult(iNme)
			if iNme=="Elixir of Accuracy" then 
				return true;
			elseif iNme=="Elixir of Armor Piercing" then 
				return true;
			elseif iNme=="Elixir of Deadly Strikes" then 
				return true;
			elseif iNme=="Elixir of Expertise" then 
				return true;
			elseif iNme=="Elixir of Lightning Speed" then 
				return true;
			elseif iNme=="Elixir of Mighty Defense" then 
				return true;
			elseif iNme=="Elixir of Mighty Thoughts" then 
				return true;
			elseif iNme=="Elixir of Mighty Strength" then 
				return true;
			elseif iNme=="Elixir of Protection" then 
				return true;
			elseif iNme=="Elixir of Spirit" then 
				return true;
			elseif iNme=="Guru's Elixir" then 
				return true;
			elseif iNme=="Flask of Endless Rage" then 
				return true;
			elseif iNme=="Flask of Frost Wyrm" then 
				return true;
			elseif iNme=="Flask of Pure Mojo" then 
				return true;
			elseif iNme=="Flask of Stoneblood" then 
				return true;
			end
	return false;
end

SLASH_DEPLOAD1 = '/depload'

function SlashCmdList.DEPLOAD(msg,editbox)
	local loaded=1
	for x=0,4 do
		for y=1, GetContainerNumSlots(x) do
			local link = GetContainerItemLink(x,y);
			if link then
				item_name,link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice =GetItemInfo(link);			
				if isresearchresult(item_name) then
					PickupContainerItem(x,y);
					ClickSendMailItemButton(loaded);
					loaded=loaded+1;
				end
			end
		end
	end
end

SLASH_JKRES1 = '/jkres'

function SlashCmdList.JKRES(msg,editbox)
	local numSkills = GetNumTradeSkills();
	local x
	for x=1,numSkills do
		skillName, skillType, numAvailable, isExpanded, serviceType = GetTradeSkillInfo(x);
		if not skillType:match("header") then	
			if numAvailable >0 then
				if skillName:match("Northrend Alchemy Research") then
					print("Doing ",skillName," if not on CD...");
					local cooldown = GetTradeSkillCooldown(x);
					if not cooldown then
						--print("Making a ",skillName);
						DoTradeSkill(x);
					end
				end
			end
		end
	end
end
-- SLASH_MAILJUNK1 = '/mailjunk'

-- function SlashCmdList.MAILJUNK(msg,editbox)
	-- local default='Ashri'
	-- if msg:match("def") then
		-- targ=default;
		-- print("Target not set, using default of ",default);
	-- else
		-- targ=msg;
		-- print("Target set to, ",targ);
	-- end
	-- local loaded=1
	-- for x=0,4 do
		-- for y=1, GetContainerNumSlots(x) do
			-- local link = GetContainerItemLink(x,y);
			-- if link then
				-- item_name,link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice =GetItemInfo(link);			
				-- if isjunk(class) or ( weaponorarmor(class) and quality>2 ) then
					-- if not gemmats(item_name) and not clothmats(item_name) then
						-- PickupContainerItem(x,y);
						-- ClickSendMailItemButton(loaded);
						-- iNme, t, stCnt, q = GetSendMailItem(slot);
						-- if iNme then
							-- print("Loaded item: ",item_name);
							-- loaded=loaded+1;
						-- else
							-- PutItemInBag(x);
						-- end
					-- end
				-- end
			-- end
		-- end
	-- end
	-- if loaded > 1 then
		-- --print("Mailing ",targ,money-10000000," copper");
		-- print("Mailing bunches of stuff to ",targ);
		-- --SendMail(targ,"Random stuff","");
	-- end
-- end


SLASH_DEPOSIT1 = '/deposit'

function SlashCmdList.DEPOSIT(msg,editbox)
	local default='Ashri'
	local command, rest = msg:match("^(%S*)%s*(.-)$");
	--print("Command: ",command)
	--print("Rest: ",rest)
	if command=="" then
		targ=default;
		print("Target not set, using default of ",default);
	else
		targ=msg;
		print("Target set to, ",targ);
	end
		
	
	local money=GetMoney();
	itemname=GetSendMailItem(1);
	if money > 10000000 then
		SetSendMailMoney(money-10000000);
	end
	if money > 10000000  or itemname~=nil then
		print("Mailing ",targ,money-10000000," copper");
		SendMail(targ,"Deposit!","");
	end
end

function weaponorarmor(class)
	if class=="Weapon" then
		return true;
	end
	if class=="Armor" then
		return true;
	end
	return false;
end

function isjunk(class)
	if class=="Trade Goods" then
		return true;
	end
	if class=="Recipe" then
		return true;
	end
	if class=="Gem" then
		return true;
	end
	if class=="Miscellaneous" then
		return true;
	end
	if class=="Quest" then
		return true;
	end
	return false;
end

function clothmats(itemname)
	if itemname=="Bolt of Imbued Frostweave" then
		return true;
	end
	if itemname=="Eternal Shadow" then
		return true;
	end
	if itemname=="Eternal Life" then
		return true;
	end
	if itemname=="Eternal Fire" then
		return true;
	end
	return false;
end

function gemmats(itemname)
	--kings amber
	if itemname=="Autumn's Glow" or itemname=="Eternal Life" then
		return true;
	end
	--ametrine
	if itemname=="Monarch Topaz" or itemname=="Eternal Shadow" then
		return true;
	end
	--eye of zul
	if itemname=="Forest Emerald" then
		return true;
	end
	--cardinal ruby
	if itemname=="Scarlet Ruby" or itemname=="Eternal Fire" then
		return true;
	end
	--dreadstone
	if itemname=="Twilight Opal" or itemname=="Eternal Shadow" then
		return true;
	end
	--zircon
	if itemname=="Sky Sapphire" or itemname=="Eternal Air" then 
		return true;
	end
	return false;
end

function isintable(atable,astring) 
	for idx,mat in pairs(atable) do
		if astring==mat then
			return true;
		end
	end
	return false;
end

function ismat(itemname)
	if itemname=="Twilight Opal" then
		return true;
	end
	if itemname=="Monarch Topaz" then
		return true;
	end
	if itemname=="Autumn's Glow" then
		return true;
	end
	if itemname=="Forest Emerald" then
		return true;
	end
	if itemname=="Scarlet Ruby" then
		return true;
	end
	if itemname=="Sky Sapphire" then
		return true;
	end
	if itemname=="Eternal Shadow" then
		return true;
	end
	if itemname=="Eternal Life" then
		return true;
	end
	if itemname=="Eternal Fire" then
		return true;
	end
	if itemname=="Eternal Air" then
		return true;
	end
	resmat={"Goldclover","Adder's Tongue","Talandra's Rose"}
	for idx,mat in pairs(resmat) do
		if itemname==mat then
			return true;
		end
	end	
	alchtrainmats={"Peacebloom","Silverleaf","Briarthorn","Bruiseweed","Mageroyal","Stranglekelp","Liferoot","Kingsblood","Goldthorn","Wild Steelbloom","Sungrass","Khadgar's Whisker","Iron Bar","Black Vitriol","Purple Lotus","Firebloom","Arthas' Tears","Blindweed","Golden Sansam","Mountain Silversage","Felweed","Ragveil","Dreaming Glory","Netherbloom","Talandra's Rose","Pygmy Suckerfish","Goldclover","Tiger Lily","Adder's Tongue","Icethorn","Lichbloom","Saronite Bar","Dark Jade","Huge Citrine","Eternal Fire"};	
	for idx,mat in pairs(alchtrainmats) do
		if itemname==mat then
			return true;
		end
	end	

	--if isintable(alchtrainmats,itemname) then
		--return true;
--	end
	return false;
end

sendqueuet={};
sendqueuem={};
sendqueuei={};
JKSendMailState=1;
JKSendMailIIdx=1;

movequeue={}
loadqueue={}
loadqueuei=1;
jkloadqueuestate=1;
jkmovequeuestate=1;

mainqueue={}--temporary.  controls 'order of exeuction'

function ActionButton_OnUpdate()
	if (MyAddon_LastTime == nil) then
	MyAddon_LastTime = GetTime()
	else
	
	--
	--
	--ok heres the idea
	--	state machine, every X seconds we advance the state if there is a target
	--	   State 1:  If item attachment, attach 1 item, remove from queue.
	--				 if no attachment, advance.
	--	   state 2:	 Send Mail.
	--expansion
	--	if mainqueue ==move or load, then we mvoe or load.  otherwise, we check send queue and see if stuff needs to be send.
	--
	--
		if  (GetTime() >= MyAddon_LastTime + 2) then
			--print("checking send queue");
		-- Do stuff here every 5 seconds --
			--if (#(sendqueuet)>0) then 
			if (mainqueue[1]=="move") then
			--if (movequeue[1]~=nil) then
				--domoves (restacking)
				--tinsert(movequeue,{x,y,a,bagputin,slotputin});				
						--SplitContainerItem(x,y,amount);	
							--PutItemInBackpack();
									--PutItemInBag(z);	
				
				local x=movequeue[1][1];
				local y=movequeue[1][2];
				local a=movequeue[1][3];
				local b=movequeue[1][4];
				local s=movequeue[1][5];
				if (jkmovequeuestate==1) then
					AutoEquipCursorItem();--just incase I have something sitting on my fucking cursor.
					print("moving",a,"something from",x,y," to ",b,s);
					SplitContainerItem(x,y,a);
					--jkmovequeuestate=2;
				--else
					print("Putting the FUCKING ITEM IN A FUCKING BAG OMFG!");
					PickupContainerItem(b,s);
					AutoEquipCursorItem();--just incase I have something sitting on my fucking cursor.
					--if b==0 then
--						PutItemInBackpack();
					--else
--						PutItemInBag(b);
					--end
					tinsert(loadqueue,{b,s,a})
					tinsert(mainqueue,'load');
					tremove(movequeue,1);
					tremove(mainqueue,1);
					print("Mainqueue[1]:",mainqueue[1],"movequeue1",unpack(movequeue[1]));
					--jkmovequeuestate=1;
				end
			--elseif loadqueue[1]~=nil then
			elseif (mainqueue[1]=="load") then
				if jkloadqueuestate==1 then			
					local x=loadqueue[1][1];
					local y=loadqueue[1][2];
					local a=loadqueue[1][3];
					print("picking up ",a," whatevers at ",x,y,"and moving it to mail slot",loadqueuei);					
					texture, count, locked, quality,  readable, lootable, link =  GetContainerItemInfo(x, y);
					if count==a then					
						PickupContainerItem(x,y);
						jkloadqueuestate=2;
					else
						target=sendqueuet[1]
						print("Amount of item to be picked up not right, pausing....(next target: ",target,')');
					end
				else
					print("Actually clicking the mail button...");
					ClickSendMailItemButton(loadqueuei);
					loadqueuei=loadqueuei+1;
					tremove(loadqueue,1);
					tremove(mainqueue,1);
					jkloadqueuestate=1;
				end
				--do pickup(adding to mail...)						
			elseif (sendqueuet[1]~=nil) then 
				copper=sendqueuem[1];
				target=sendqueuet[1];		
				SetSendMailMoney(copper);
							
				if sendqueuei[1][JKSendMailIIdx]==nil then
					JKSendMailState=2;
				end
				if JKSendMailState==1 then						
					item=sendqueuei[1][JKSendMailIIdx][1];
					qty=sendqueuei[1][JKSendMailIIdx][2];
					print("trying to load ",qty,item,"for ",target);
					loaditem(item,qty);
					--tremove(sendqueuei[1],1);
					JKSendMailIIdx=JKSendMailIIdx+1;
					--for idx,ingredient in pairs(sendqueuei[1]) do					
						--for item,qty in pairs(ingredient) do
--						print(idx,ingredient);
						--item=ingredient[1];
						--qty=ingredient[2];
						--print("trying to load ",qty,item,"for ",target);
						--loaditem(item,qty);
	--					end
					--end			
				end
				if JKSendMailState==2 then
					JKSendMailState=3;
					JKSendMailIIdx=1;
					loadqueuei=1;
					tremove(sendqueuet,1);
					tremove(sendqueuem,1);
					tremove(sendqueuei,1);
					print("Mailing ",target,copper," copper, ",#(sendqueuet),"more mails to send...");	
				
					SendMail(target,"Material Distribution.","");					
				
					for slot=1,ATTACHMENTS_MAX_SEND do
						iNme, t, stCnt, q = GetSendMailItem(slot);
						if iNme~=nil then
							print("Loaded ",stCnt,iNme);
						end
					end
				end
				if JKSendMailState==3 then
					JKSendMailState=1;--this is because it needs to 'pause' so the email is sent, and inventory is updated, before trying
					--to load the next guys items.  
				end
				--if (#(sendqueuet)==0) then
--					wipe(sendqueuet);
					--wipe(sendqueuem);
					--wipe(sendqueuei);
				--end
			end
                
                MyAddon_LastTime = GetTime()
		end
	end
end

function loaditem(item,amount)
	local loaded=1
	freeslots={}
	for x=0,4 do
		freeslots[x]=GetContainerFreeSlots(x);
	end
	for x=0,4 do
		for y=1, GetContainerNumSlots(x) do
			local link = GetContainerItemLink(x,y);
			if link then
				item_name,link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice =GetItemInfo(link);
				if item_name==item then			
					texture, count, locked, quality,  readable, lootable, link =  GetContainerItemInfo(x, y);
					cursoritem=false;
					if count<=amount then
						tinsert(loadqueue,{x,y,count});
						tinsert(mainqueue,"load");
						--PickupContainerItem(x,y);							
						cursoritem=true;
					elseif count>=amount then					
						--this is where we split the stack...
						bagputin=nil;
						slotputin=nil;
						count=amount;--this is because if count > amount, we are done...
						--SplitContainerItem(x,y,amount);			
						if #(GetContainerFreeSlots(0))>0 then
						--put item in backpack, if slots permit
							--PutItemInBackpack();
							bagputin=0
							slotputin=freeslots[0][1];
							slotputin=GetContainerFreeSlots(0)[1];
							print("Adding to move queue: ",x,y,amount,bagputin,slotputin);
							tinsert(movequeue,{x,y,amount,bagputin,slotputin});
							tinsert(mainqueue,"move");							
							--freeslots[0]=GetContainerFreeSlots(0);
						else
							for z=1,4 do
								if #(GetContainerFreeSlots(z))>0 and bagputin==nil and slotputin==nil then
								--	print("trying to put item in bag ",z);
								--put item in respective bag
									--PutItemInBag(z);	
									bagputin=z;
									slotputin=freeslots[z][1];
									slotputin=GetContainerFreeSlots(z)[1];
									print("Adding to move queue: ",x,y,amount,bagputin,slotputin);
									tinsert(movequeue,{x,y,amount,bagputin,slotputin});
									tinsert(mainqueue,"move");							
									--freeslots[x]=GetContainerFreeSlots(z);
								end
							end
						end
						if (bagputin~=nil and slotputin~=nil) then							
							--PickupContainerItem(bagputin,slotputin);
							cursoritem=true;
						end
					end
					if cursoritem then
						--ClickSendMailItemButton(loaded);
						--loaded=loaded+1;
						amount=amount-count;	
						print("Loaded ",count,"of",item,".",amount,"left to go");
					end				
					if amount<=0 then
						return;
					end
				end
			end
		end
	end
end

function AddAlchTrainMats(recipemats,charlist)
	--
	--	The following lines were generated by python script.  Quite easy to parse
	--	from websites.  Just a FYI.
	--
recipemats["AlchTrainPeacebloom"]={{"Peacebloom"},{59},charlist};
recipemats["AlchTrainSilverleaf"]={{"Silverleaf"},{59},charlist};
recipemats["AlchTrainBriarthorn"]={{"Briarthorn"},{95},charlist};
recipemats["AlchTrainBruiseweed"]={{"Bruiseweed"},{35},charlist};
recipemats["AlchTrainMageroyal"]={{"Mageroyal"},{20},charlist};
recipemats["AlchTrainStranglekelp"]={{"Stranglekelp"},{35},charlist};
recipemats["AlchTrainLiferoot"]={{"Liferoot"},{30},charlist};
recipemats["AlchTrainKingsblood"]={{"Kingsblood"},{30},charlist};
recipemats["AlchTrainGoldthorn"]={{"Goldthorn"},{45},charlist};
recipemats["AlchTrainWild Steelbloom"]={{"Wild Steelbloom"},{10},charlist};
recipemats["AlchTrainSungrass"]={{"Sungrass"},{70},charlist};
recipemats["AlchTrainKhadgar's Whisker"]={{"Khadgar's Whisker"},{15},charlist};
recipemats["AlchTrainIron Bar"]={{"Iron Bar"},{4},charlist};
recipemats["AlchTrainBlack Vitriol"]={{"Black Vitriol"},{1},charlist};--this doesnt seem to work.
recipemats["AlchTrainPurple Lotus"]={{"Purple Lotus"},{4},charlist};
recipemats["AlchTrainFirebloom"]={{"Firebloom"},{4},charlist};
recipemats["AlchTrainArthas' Tears"]={{"Arthas' Tears"},{19},charlist};
recipemats["AlchTrainBlindweed"]={{"Blindweed"},{40},charlist};
recipemats["AlchTrainGolden Sansam"]={{"Golden Sansam"},{75},charlist};
recipemats["AlchTrainMountain Silversage"]={{"Mountain Silversage"},{18},charlist};
recipemats["AlchTrainFelweed"]={{"Felweed"},{35},charlist};
recipemats["AlchTrainRagveil"]={{"Ragveil"},{20},charlist};
recipemats["AlchTrainDreaming Glory"]={{"Dreaming Glory"},{35},charlist};
recipemats["AlchTrainNetherbloom"]={{"Netherbloom"},{10},charlist};
recipemats["AlchTrainTalandra's Rose"]={{"Talandra's Rose"},{20},charlist};
recipemats["AlchTrainPygmy Suckerfish"]={{"Pygmy Suckerfish"},{5},charlist};
recipemats["AlchTrainGoldclover"]={{"Goldclover"},{85},charlist};
recipemats["AlchTrainTiger Lily"]={{"Tiger Lily"},{35},charlist};
recipemats["AlchTrainAdder's Tongue"]={{"Adder's Tongue"},{25},charlist};
recipemats["AlchTrainIcethorn"]={{"Icethorn"},{20},charlist};
recipemats["AlchTrainLichbloom"]={{"Lichbloom"},{40},charlist};
recipemats["AlchTrainSaronite Bar"]={{"Saronite Bar"},{56},charlist};
recipemats["AlchTrainDark Jade"]={{"Dark Jade"},{5},charlist};
recipemats["AlchTrainHuge Citrine"]={{"Huge Citrine"},{5},charlist};
recipemats["AlchTrainEternal Fire"]={{"Eternal Fire"},{5},charlist};
	return recipemats;
end


SLASH_JKCOUNT1 = '/jkcount'

function SlashCmdList.JKCOUNT(msg, editbox) -- 4.	
	local loaded=1	
	local amounts={}
	--local locations={}--track what 'bags'/tabs they are in, and report it?
	for x=-1,NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
		for y=1, GetContainerNumSlots(x) do
			local link = GetContainerItemLink(x,y);
			if link then
				item_name,link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice =GetItemInfo(link);	
				texture, count, locked, quality,  readable, lootable, link =  GetContainerItemInfo(x,y);			
				if amounts[item_name]==nil then					
					amounts[item_name]=count;
					--locations[item_name]={}
				else
					amounts[item_name]=amounts[item_name]+count;
				end
			end
		end
	end
	numTabs = GetNumGuildBankTabs();
	for x=0,numTabs do
		for y=1,MAX_GUILDBANK_SLOTS_PER_TAB do
			local link=GetGuildBankItemLink(x,y);
			if link then
				item_name,link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice =GetItemInfo(link);															
				texture, count, locked =  GetGuildBankItemInfo(x, y);
				if amounts[item_name]==nil then					
					amounts[item_name]=count;
				else
					amounts[item_name]=amounts[item_name]+count;
				end
			end
		end
	end
	--local watchlist={"Goldthorn","Arthas' Tears","Golden Sansam","Mountain Silversage","Felweed","Ragveil","Dreaming Glory","Netherbloom","Talandra's Rose","Goldclover","Tiger Lily","Adder's Tongue","Icethorn","Lichbloom","Saronite Bar","Dark Jade","Huge Citrine","Eternal Fire","Runic Healing Potion","Runic Mana Potion","Primal Earth","Primal Water"};
	local watchlist={"Briarthorn","Stranglekelp","Goldthorn","Sungrass","Iron Bar","Purple Lotus","Arthas' Tears","Blindweed","Golden Sansam","Mountain Silversage","Talandra's Rose","Goldclover","Lichbloom","Saronite Bar","Dark Jade","Huge Citrine","Eternal Fire","Runic Healing Potion","Runic Mana Potion","Primal Earth","Primal Water","Primal Air","Primal Fire","Primal Mana","Primal Might","Frost Lotus","Recipe Super Mana"};
	for idx,item in pairs(watchlist) do
		local qty=0;
		if amounts[item]==nil then
			qty=0
		else
			qty=amounts[item]
		end
		print(" ",idx,": ",item,"|",qty);
	end
	for item,qty in pairs(amounts) do
		--if qty>20 then
			--print (" ",item,":",qty);
		--end
	end
end


SLASH_JKDIST1 = '/jkdist'

function SlashCmdList.JKDIST(msg, editbox) -- 4.	
	local loaded=1
	local bags={}
	local amounts={}
	local slots={}
	for x=0,4 do
		for y=1, GetContainerNumSlots(x) do
			local link = GetContainerItemLink(x,y);
			if link then
				item_name,link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice =GetItemInfo(link);							
				--print(item_name,"\n");
					if amounts[item_name]==nil then					
						amounts[item_name]=GetItemCount(link)
						bags[item_name]={}
						slots[item_name]={}
					end
					tinsert(bags[item_name],x)
					tinsert(slots[item_name],y)
					--print(item_name," : ",amounts[item_name],#(bags[item_name]),#(slots[item_name]));						
					--loaded=loaded+1;				
			end
		end
	end
	--now we have the 'count' of each mat in the inventory, and all the inventory locations.
	local chars={"Ish\àry","Isháry","Ishâry","Ishäry","Isharali","Ishare","Isharati","Isharaci","Isharami","Isharadi","Ishard","Imorta","Isharb","Isharc","Imorty","imortl","imortm","imorti","Arish","Airsh","Sihar","Rihas"};	
	local recipemats={}
	recipemats["Transmute: Living Elements"]={{"Volatile Life"},{15},{"Ish\àry","Isháry","Ishâry","Ishäry","Isharali","Isharati","Isharaci","Isharami","Isharadi","Imorta","Imorty","imortl","imortm","imorti","Arish","Airsh","Sihar","Rihas"}}
	--recipemats["Dreadstone"]={{"Twilight Opal","Eternal Shadow"},{1,1},{"Airsh","imorti","Ishâry","Rihas"}};
	--recipemats["Ametrine"]={{"Monarch Topaz","Eternal Shadow"},{1,1},{"Imorty","imortl","imortm","Isharc","Arish","Ishard","Sihar"}};
	--recipemats["Eye of Zul"]={{"Forest Emerald"},{3},{"Imorta"}};
	--recipemats["King's Amber"]={{"Autumn's Glow","Eternal Life"},{1,1},{"Isharati","Isharaci","Isharami","Isharali","Ishare"}};
	--recipemats["Mystic Zircon"]={{"Sky Sapphire","Eternal Air"},{1,1},{"Ishäry"}};
	--recipemats["Cardinal Ruby"]={{"Scarlet Ruby","Eternal Fire"},{1,1},{"Ish\àry","Isháry","Isharb","Isharadi"}};	
	--recipemats["Alchemy Research"]={{"Goldclover","Adder's Tongue","Talandra's Rose","Enchanted Vial"},{10,10,4,4},{"Ish\àry","Isháry","Ishâry","Ishäry","Isharali","Ishare","Isharati","Isharaci","Isharami","Isharadi","Ishard","Imorta","Isharb","Isharc","Imorty","imortl","imortm","imorti","Arish","Airsh","Sihar","Rihas"}};
	newalchemists={"Isharavi","Ashriadi","Ashriati","Ashriavi","Ishárdecai","Ishärdecai","Ishãrdecai","Ashriaci","Ashriami","Irsah","Ishàrdecai","Ishardecai"};
	--oversight:  doesnt work on partial mats.   
	--	consider rewriting to put each 'type' seperate, then can dispense just peacebloom or silverleaf or whatever...
	--	slightly buggy still.  expect manual corrections.  still, it handles the lion share....
	--	consider slowing down the tic so that its less likly to bug due to lag...eg.  reliable > speed.
	--recipemats["AlchTrain"]={{"Peacebloom","Silverleaf","Briarthorn","Bruiseweed","Mageroyal","Stranglekelp","Liferoot","Kingsblood","Goldthorn","Wild Steelbloom","Sungrass","Khadgar's Whisker","Iron Bar","Black Vitriol","Purple Lotus","Firebloom","Arthas' Tears","Blindweed","Golden Sansam","Mountain Silversage","Felweed","Ragveil","Dreaming Glory","Netherbloom","Talandra's Rose","Pygmy Suckerfish","Goldclover","Tiger Lily","Adder's Tongue","Icethorn","Lichbloom","Saronite Bar","Dark Jade","Huge Citrine","Eternal Fire"},{59,59,95,35,20,35,30,30,45,10,70,15,4,1,4,4,19,40,75,18,35,20,35,10,20,5,85,35,25,20,40,56,5,5,5},newalchemists};
	recipemats=AddAlchTrainMats(recipemats,newalchemists);
	--	I'm tired, but later write this code, so that its relatively convienyent
	--	to distribute the level up crack.
	--		segregate by expansion, maybe.
	for product,mats in pairs(recipemats) do
		producers=mats[3];
		reqamts=mats[2];
		matlist=mats[1];		
		local sufficient_mats=true;
		local mindays=12120
		print("Working on ",product,"(",#(producers)," producers.)");	
		for index,mat in pairs(matlist) do
			--print("Considering mat ",mat);
			local quantity=amounts[mat];
			if quantity==nil then quantity=0 end
			local days=floor(quantity/(#(producers)*reqamts[index]));	
			local per=days*reqamts[index];
			if days<mindays then
				mindays=days
			end
			if per>1 then
				print("   I have ",quantity,mat,". (",per,"each,",days,"days)");				
			else
				sufficient_mats=false;
				print("   Need more for split: ",mat," (have ",quantity,", min:",#(producers)*reqamts[index],")");
			end
		end
		if sufficient_mats then
			local split={}
			for index,mat in pairs(matlist) do
				days=mindays
				per=days*reqamts[index];	
				tinsert(split,{mat,per});
			end
			for index,producer in pairs(producers) do
				--this is where we add it to the sendqueue				
				tinsert(sendqueuet,producer);			
				tinsert(sendqueuem,0);	
				tinsert(sendqueuei,split);				
			end
		end
	end
	--loaditem("Scarlet Ruby",3);
	--for x,y in pairs(chars) do
		--print(x,y);
		--tinsert(sendqueuet,0,y);
		--tinsert(sendqueuem,0,0);
		--tinsert(sendqueuei,0,{});
		
		--print("sendqueue 0!",sendqueue[0]);
		--SetSendMailMoney(1);
		--print("Mailing ",y,1," copper");
		--SendMail(y,"test, dont get happy...!","");
	--end
end


--SLASH_USEALL1 = '/useall'

--function SlashCmdList.USEALL(msg, editbox) -- 4.	
--	local loaded=1
--	for x=0,4 do
		--for y=1, GetContainerNumSlots(x) do
--			local link = GetContainerItemLink(x,y);
			--if link then
--				item_name,link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice =GetItemInfo(link);			
				--if IseUseableItem(link ) and class~="Consumable" then
--					print(item_name," is usable!") 
				--end
			--end
		--end
	--end
--end

SLASH_REFUNDMATS1 = '/refundmats'

function SlashCmdList.REFUNDMATS(msg, editbox) -- 4.	
	local loaded=1
	local allmats={"Twilight Opal","Eternal Shadow","Monarch Topaz","Eternal Shadow","Forest Emerald","Autumn's Glow","Eternal Life","Sky Sapphire","Eternal Air","Scarlet Ruby","Eternal Fire","Goldclover","Adder's Tongue","Talandra's Rose","Enchanted Vial"}
	for x=0,4 do
		for y=1, GetContainerNumSlots(x) do
			local link = GetContainerItemLink(x,y);
			if link then
				for idx,mat in pairs(allmats) do 					
					item_name,link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice =GetItemInfo(link);			
					if item_name==mat then
						PickupContainerItem(x,y);
						ClickSendMailItemButton(loaded);
						loaded=loaded+1;
					end				
				end 
			end
		end
	end
end

SLASH_LOADGEMS1 = '/loadgems'

function SlashCmdList.LOADGEMS(msg, editbox) -- 4.	
	local loaded=1
	for x=0,4 do
		for y=1, GetContainerNumSlots(x) do
			local link = GetContainerItemLink(x,y);
			if link then
				item_name,link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice =GetItemInfo(link);			
				if isgemexact(item_name) then
					PickupContainerItem(x,y);
					ClickSendMailItemButton(loaded);
					loaded=loaded+1;
				end
			end
		end
	end
end

SLASH_CODGEMS1 = '/codgems'

function SlashCmdList.CODGEMS(msg, editbox) -- 4.
	--print("In CODgems, target=",msg);
	--print('Attachments max send',ATTACHMENTS_MAX_SEND);
	local ig=1;
	local default='Xethnyrrow'
	local targ=""
	local command, rest = msg:match("^(%S*)%s*(.-)$");
	--print("Command: ",command)
	--print("Rest: ",rest)
	if command=="" then
		targ=default;
		print("Target not set, using default of ",default);
	else
		targ=msg;
		print("Target set to, ",targ,".");
	end
	local cost=0;
	local gemcount=0
	print("Calculating prices for attachments:")
	for slot=1,ATTACHMENTS_MAX_SEND do
		iNme, t, stCnt, q = GetSendMailItem(slot);
		if iNme then
			if iNme:match("Vol321atile Air") then 			
				ig=2;
				cost=cost+(700000*stCnt); 
				gemcount=gemcount+stCnt;			
			elseif iNme:match("Vo123latile Fire") then			
				ig=2;
				cost=cost+(700000*stCnt); 
				gemcount=gemcount+stCnt;	
			elseif iNme:match("Ametrine") then			
				ig=2;
				cost=cost+(700000*stCnt); 
				gemcount=gemcount+stCnt;
			elseif iNme:match("King's Amber") then 
				ig=2;
				cost=cost+(800000*stCnt);
				gemcount=gemcount+stCnt;
			elseif iNme:match("Majestic Zircon") then 
				ig=2;
				cost=cost+(800000*stCnt);
				gemcount=gemcount+stCnt;
			elseif iNme:match("Cardinal Ruby") then 
				ig=2;
				cost=cost+(850000*stCnt); 
				gemcount=gemcount+stCnt;
			else
				ig=1;
			end
			print("   ",stCnt,iNme,":",cost);
		end
	end
	if ig==2 then 
		print("Mailing ",gemcount," gems to: ",targ," for ",cost);
		SetSendMailCOD(cost);
		--Uncomment this line tonight after a 'live fire test'
		SendMail(targ,"Gemz!","");
	end
	if ig==1 then
		print("No gems in mail slots, or non gems in mail slots.");
	end
	-- if ig==2 then SetSendMailCOD(cost);SendMail(targ,"","");print("Mailed gems to:");print(targ);print("for");print(cost);end
end
