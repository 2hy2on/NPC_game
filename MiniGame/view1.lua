-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view

		--JSON 파싱--
	local json = require('json') --include와 같음

	local Data, pos, msg

	local function parse()
		local filename = system.pathForFile("instruction.json")
		Data, pos, msg = json.decodeFile(filename)

		--디버그
		if Data then 
			print(Data[1].title)
		else
			print(pos)
			print(msg)
		end

	end
parse()

	---배경소환---
	local background = display.newRect(display.contentWidth/2,display.contentHeight/2,display.contentWidth,display.contentHeight)
	background:setFillColor(0.2,0.2,0.2,0.5)
	
	--깃발 그룹화--
	local flagGroup = display.newGroup()
	
	--청기 소환--
	local blueF = display.newImageRect(flagGroup,"img/blue.png", display.contentWidth* 0.3,display.contentHeight*0.4)
	blueF.x, blueF.y = display.contentWidth * 0.3, display.contentHeight*0.4
	
	--백기 소환--
	local whiteF = display.newImageRect(flagGroup,"img/white.png", display.contentWidth* 0.33,display.contentHeight*0.45)
	whiteF.x, whiteF.y = display.contentWidth * 0.7, display.contentHeight*0.4
	
	--점수 소환--
	local score = 0
	local showScore = display.newText(score, display.contentWidth*0.08, display.contentHeight*0.15)
	showScore:setFillColor(1)
	showScore.size = 100

	--게임 지시 박스--
	local section = display.newRect(display.contentWidth/2, display.contentHeight*0.8, display.contentWidth, display.contentHeight*0.2)
	section:setFillColor(0.25, 0.25, 0.25, 0.25)

	local script = display.newText("시작하려면 enter를 누르세요", section.x+100, section.y+30, display.contentWidth*0.7, 120)
	script.width = display.contentWidth*0.6
	script.size = 30
	script:setFillColor(1,0.8,0, 0.5)


	--시작--
	local function start(event)
		local start = 0
		if(event.keyName == "enter") then 
			if (start == 0) then 
			play()
			start = 1
			else
			end
		end
	end
	
	--랜덤 지시--
	function play()
		index = math.random(1,12) --전역 변수 사용함--
		script.text=Data[index].info
		return index 
	end

	--청기 마우스 이벤트--
	local function blue(event)
		if(event.type =="down") then
			if(event.isPrimaryButtonDown) then
				if( Data[index].type =="bUp") then 
				score = score + 1
				showScore.text = score
				index = play()
				else
					local options =
					{
						effect = "slideLeft",
						time = 500,
					}
					composer.setVariable("complete", false)
					composer.setVariable("finalScore", score)
					composer.gotoScene("view2", options)
				end
			elseif(event.isSecondaryButtonDown) then
				if( Data[index].type =="bDown") then
				score = score + 1
				showScore.text = score
				index = play()
				else
					local options =
				{
					effect = "slideLeft",
					time = 500,
				}
				composer.setVariable("complete", false)
				composer.setVariable("finalScore", score)
				composer.gotoScene("view2", options)
				end
			else
				local options =
			{
				effect = "slideLeft",
				time = 500,
			}
			composer.setVariable("complete", false)
			composer.setVariable("finalScore", score)
			composer.gotoScene("view2", options)
			end
		end
	end

	--백기 마우스 이벤트--
	local function white(event)
		if(event.type =="down") then
			if(event.isPrimaryButtonDown) then
				if( Data[index].type =="wUp") then 
				score = score + 1
				showScore.text = score
				play()
			else
				local options =
				{
					effect = "slideLeft",
					time = 500,
				}
				composer.setVariable("complete", false)
				composer.setVariable("finalScore", score)
				composer.gotoScene("view2", options)
			end
			elseif(event.isSecondaryButtonDown) then
				if( Data[index].type =="wDown") then
				score = score + 1
				showScore.text = score
				play()
				else
					local options =
					{
						effect = "slideLeft",
						time = 500,
					}
					composer.setVariable("complete", false)
					composer.setVariable("finalScore", score)
					composer.gotoScene("view2", options)
					end
				else
					local options =
				{
					effect = "slideLeft",
					time = 500,
				}
				composer.setVariable("complete", false)
				composer.setVariable("finalScore", score)
				composer.gotoScene("view2", options)
			end
		end
	end

	blueF:addEventListener( "mouse", blue)
	whiteF:addEventListener( "mouse", white)
	Runtime:addEventListener("key", start)

	--시간 제한--
	--[[local limit = 3
	local showLimit = display.newText(limit, display.contentWidth*0.9, display.contentHeight*0.1)
	showLimit:setFillColor(0)
	showLimit.size = 80
	--sceneGroup:insert(showLimit)--]]

	--[[function timeAttack(event)
		limit = limit - 1
		showLimit.text = limit

		if(limit == 0) then
			composer.setVariable("complete", false)
			composer.setVariable("finalScore", score)
			composer.gotoScene("view2")
		end
	end]]
	--timer.performWithDelay(1000, timeAttack, 0) --이 실행창이 뜬후 timeAttack함수를 무한번 반복해라--

		---레이어 정라---
	sceneGroup:insert(background)
	sceneGroup:insert(flagGroup)
	sceneGroup:insert(section)
	sceneGroup:insert(script)
	sceneGroup:insert(showScore)
	--sceneGroup:insert(roundedRec)

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene