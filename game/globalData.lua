local M=
{
  language = nil,
  
  GUI_position = 
  {
    loginText = 
    {
      x = display.contentWidth * 0.3,
      y = display.contentCenterY,
      font = 36,
    },
    
    loginTextBox = 
    {
      x = display.contentWidth * 0.32,
      y = display.contentHeight * 0.25,
      width = 320,
      height = 36,
    },
    
    loginErrMsg = 
    {
      x = display.contentCenterX,
      y= display.contentCenterY + 100,
      font = 36,
    },  
    
    loginSubmitBtn = 
    {
      x = display.contentCenterX,
      y = display.contentCenterY + 100,
      width = 100,
      height = 40,
    },
    
    uiUsername = 
    {
      x = display.contentWidth * 0.25,
      y = display.contentHeight * 0.1,
      width = display.contentWidth *0.2,
      height = 0,
      font = 20,
    },
  
    uiCoins = 
    {
      x = display.contentWidth - 150,
      y = display.contentHeight * 0.1,
      width = 200,
      height = 0,
      font = 20,
    },
    
    uiStatistic = 
    {
      x = display.contentCenterX,
      y = display.contentHeight * 0.1,
      font = 20,
    },
    
    uiRewards = 
    {
      x = display.contentCenterX,
      y = display.contentCenterY - 150,
      font = 24
    },
    
    uiTimer = 
    {
      x = display.contentCenterX,
      y = 50,
      font = 24
    },
    
    uiPlayAgainBtn = 
    {
        x = display.contentWidth * 0.4,
        y = display.contentCenterY + 150,
        width = 150,
        height = 40,
    },
    
    uiShareBtn = 
    {
        x = display.contentWidth * 0.6,
        y = display.contentCenterY + 150,
        width = 150,
        height = 40,
    },
    
    uiShareHint =
    {
        x = display.contentCenterX,
        y = display.contentCenterY + 110,
        font = 18,
    },
    
    uiTag = 
    {},
    
    uiTitle = 
    {},
    
    uiContent = 
    {}
  },
  
  GameTime = 1,
  GameLanguage = "en",
  BGM = nil,
  
  GameRewards = 
  {
    "images/in-game/rewards/dolphin.png",
    "images/in-game/rewards/minnow.png",
    "images/in-game/rewards/orca.png",
    "images/in-game/rewards/redfish.png",
    "images/in-game/rewards/whale.png",
    "images/in-game/rewards/crab.png",
    "images/in-game/rewards/children-day.png",
    "images/in-game/rewards/ninja.png",
    "images/in-game/rewards/sumo.png",
    "images/in-game/rewards/starfish.png",
    "images/in-game/rewards/eos-cat.png",
    "images/in-game/rewards/bitcoin-hacker.png",
    "images/in-game/rewards/steem-magic.png",
  }
}

  

return M