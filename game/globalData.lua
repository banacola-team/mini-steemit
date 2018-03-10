local M=
{
  GUI_position = 
  {
    loginText = 
    {
      x = 200,
      y = display.contentCenterY,
      font = 36,
    },
    
    loginTextBox = 
    {
      x = display.contentWidth * 0.7,
      y = display.contentCenterY,
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
      x = display.contentWidth * 0.3,
      y = 50,
      width = 300,
      height = 0,
      font = 20,
    },
  
    uiCoins = 
    {
      x = display.contentWidth - 150,
      y = 50,
      width = 100,
      height = 0,
      font = 20,
    },
    
    uiStatistic = 
    {
      x = display.contentCenterX,
      y = 100,
      font = 20,
    },
  }
}

  

return M