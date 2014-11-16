int[][] slot;
boolean[][] flagSlot; // use for flag
int bombCount; // 共有幾顆炸彈
int clickCount; // 共點了幾格
int flagCount; // 共插了幾支旗
int nSlot; // 分割 nSlot*nSlot格
int totalSlots; // 總格數
final int SLOT_SIZE = 100; //每格大小

int sideLength; // SLOT_SIZE * nSlot
int ix; // (width - sideLength)/2
int iy; // (height - sideLength)/2

int clickBombX;
int clickBombY;

boolean bombExplode;
int [][] Col_Row = new int[9][2];
int [][] checkCol_Row_Bombs = new int[4][4];
int [][] checkCol_Row_Flags = new int[4][4];
int [][] checkCol_Row_Click = new int[4][4];

// game state
final int GAME_START = 1;
final int GAME_RUN = 2;
final int GAME_WIN = 3;
final int GAME_LOSE = 4;
int gameState;

// slot state for each slot
final int SLOT_OFF = 0;
final int SLOT_SAFE = 1;
final int SLOT_BOMB = 2;
final int SLOT_FLAG = 3;
final int SLOT_FLAG_BOMB = 4;
final int SLOT_DEAD = 5;
final int SLOT_EMPTY = 6;
final int SLOT_BOMB_CLICK = 7;

PImage bomb, flag, cross ,bg;

void setup(){
  size (640,480);
  textFont(createFont("font/Square_One.ttf", 20));
  bomb=loadImage("data/bomb.png");
  flag=loadImage("data/flag.png");
  cross=loadImage("data/cross.png");
  bg=loadImage("data/bg.png");

  nSlot = 4;
  totalSlots = nSlot*nSlot;
  // 初始化二維陣列
  slot = new int[nSlot][nSlot];
  
  sideLength = SLOT_SIZE * nSlot;
  ix = (width - sideLength)/2; // initial x
  iy = (height - sideLength)/2; // initial y
  
  gameState = GAME_START;
}

void draw(){
  switch (gameState){
    case GAME_START:
          background(180);
          image(bg,0,0,640,480);
          textFont( createFont("font/Square_One.ttf",16) , 16);
          fill(0);
          text("Choose # of bombs to continue:",10,width/3-24);
          int spacing = width/9;
          for (int i=0; i<9; i++){
            fill(255);
            rect(i*spacing, width/3, spacing, 50);
            fill(0);
            text(i+1, i*spacing, width/3+24);
          }
          // check mouseClicked() to start the game
          break;
    case GAME_RUN:
          //---------------- put you code here ----
          if(clickCount==16-bombCount){
            for(int ix=0;ix<4;ix++){
              for(int iy=0;iy<4;iy++){
                if(checkCol_Row_Flags[ix][iy]==1){
                  showSlot(ix, iy, SLOT_FLAG_BOMB);
                }
                if(checkCol_Row_Bombs[ix][iy]==1&&checkCol_Row_Flags[ix][iy]==0){
                  showSlot(ix, iy, SLOT_BOMB);
                }
                if(checkCol_Row_Bombs[ix][iy]==0){
                  showSlot(ix, iy, SLOT_SAFE);
              }
            }
          }
            gameState = GAME_WIN;
          }
          if(bombExplode){
            
            for (int col=0; col < nSlot; col++){
              for (int row=0; row < nSlot; row++){
                  showSlot(col, row, SLOT_EMPTY);
              }
            }
            
            for(int ix=0;ix<4;ix++){
              for(int iy=0;iy<4;iy++){
                if(checkCol_Row_Bombs[ix][iy]==1&&checkCol_Row_Flags[ix][iy]==1){
                  showSlot(ix, iy, SLOT_FLAG_BOMB);
                }
                if(checkCol_Row_Bombs[ix][iy]==0&&checkCol_Row_Flags[ix][iy]==1){
                  showSlot(ix, iy, SLOT_FLAG);
                }
                if(checkCol_Row_Bombs[ix][iy]==1&&checkCol_Row_Flags[ix][iy]==0){
                  showSlot(ix, iy, SLOT_BOMB);
                }
                if(checkCol_Row_Bombs[ix][iy]==0&&checkCol_Row_Flags[ix][iy]==0){
                  showSlot(ix, iy, SLOT_SAFE);
                }
                if(ix == clickBombX && iy == clickBombY){
                  showSlot(ix, iy, SLOT_BOMB_CLICK);
                }
            }
          }
            gameState = GAME_LOSE;
          }
          
          break;  
          // -----------------------------------

    case GAME_WIN:
          textFont( createFont("font/Square_One.ttf",18) , 18);
          fill(0);
          text("YOU WIN !!",width/3,30);
          break;
    case GAME_LOSE:
          textFont( createFont("font/Square_One.ttf",18) , 18);
          fill(0);
          text("YOU LOSE !!",width/3,30);
          break;
  }
}

int countNeighborBombs(int col,int row){
  // -------------- Requirement B ---------
  int neighborBombs = 0;
  int position = 0;
  
  final int midle = 0;
  final int left = 1;
  final int right = 2;
  final int up = 3;
  final int down = 4;
  final int up_left = 5;
  final int up_right = 6;
  final int down_left = 7;
  final int down_right = 8;

  if(((col==1)||(col==2)) && ((row==1)||(row==2))){
    position = midle;
  }
  
  if(((col==1)||(col==2)) && (row==0)){
    position = up;
  }
  
  if((col==0) && ((row==1)||(row==2))){
    position = left;
  }
  
  if((col==3) && ((row==1)||(row==2))){
    position = right;
  }
  
  if(((col==1)||(col==2)) && (row==3)){
    position = down;
  }
  
  if(col==0 && row==0){
    position = up_left;
  }
  
  if(col==3 && row==0){
    position = up_right;
  }  
  
  if(col==0 && row==3){
    position = down_left;
  }

  if(col==3 && row==3){
    position = down_right;
  }  

  switch (position){
    case midle:
      for(int x = col-1 ; x <= col+1 ; x++){
        for(int y = row-1 ; y <= row+1 ; y++){
          if(checkCol_Row_Bombs[x][y]==1){
            neighborBombs++;
          }
        }
      }
      //println(neighborBombs);
      return neighborBombs;

      
      case up:
      for(int x = col-1 ; x <= col+1 ; x++){
        for(int y = row ; y <= row+1 ; y++){
          if(checkCol_Row_Bombs[x][y]==1){
            neighborBombs++;
          }
        }
      }
      //println(neighborBombs);
      return neighborBombs;

      
      case left:
      for(int x = col ; x <= col+1 ; x++){
        for(int y = row-1 ; y <= row+1 ; y++){
          if(checkCol_Row_Bombs[x][y]==1){
            neighborBombs++;
          }
        }
      }
      //println(neighborBombs);
      return neighborBombs;


      case right:
      for(int x = col-1 ; x <= col ; x++){
        for(int y = row-1 ; y <= row+1 ; y++){
          if(checkCol_Row_Bombs[x][y]==1){
            neighborBombs++;
          }
        }
      }
      //println(neighborBombs);
      return neighborBombs;


      case down:
      for(int x = col-1 ; x <= col+1 ; x++){
        for(int y = row-1 ; y <= row ; y++){
          if(checkCol_Row_Bombs[x][y]==1){
            neighborBombs++;
          }
        }
      }
      //println(neighborBombs);
      return neighborBombs;
    

      case up_left:
      for(int x = col ; x <= col+1 ; x++){
        for(int y = row ; y <= row+1 ; y++){
          if(checkCol_Row_Bombs[x][y]==1){
            neighborBombs++;
          }
        }
      }
      //println(neighborBombs);
      return neighborBombs;
    

      case up_right:
      for(int x = col-1 ; x <= col ; x++){
        for(int y = row ; y <= row+1 ; y++){
          if(checkCol_Row_Bombs[x][y]==1){
            neighborBombs++;
          }
        }
      }
      println(neighborBombs);
      return neighborBombs;
 
      case down_left:
      for(int x = col ; x <= col+1 ; x++){
        for(int y = row-1 ; y <= row ; y++){
          if(checkCol_Row_Bombs[x][y]==1){
            neighborBombs++;
          }
        }
      }
      //println(neighborBombs);
      return neighborBombs;


      case down_right:
      for(int x = col-1 ; x <= col ; x++){
        for(int y = row-1 ; y <= row ; y++){
          if(checkCol_Row_Bombs[x][y]==1){
            neighborBombs++;
          }
        }
      }
      //println(neighborBombs);
      return neighborBombs;

  }
  return 0;
}

void setBombs(){
  // initial slot
  for (int col=0; col < nSlot; col++){
    for (int row=0; row < nSlot; row++){
      slot[col][row] = SLOT_OFF;
    }
  }
  
  
  // -------------- put your code here ---------
  // randomly set bombs
    for(int i = 0;i<bombCount;i++){
      while(true){
        
      int randomCol = ceil(random(0,4))-1;
      int randomRow = ceil(random(0,4))-1;
      //println(randomCol,randomRow);
        if(checkCol_Row_Bombs[randomCol][randomRow]==0){
            Col_Row[i][0]=randomCol;
            Col_Row[i][1]=randomRow;
            checkCol_Row_Bombs[randomCol][randomRow]=1;
            break;
        }
        
      }
    }

}


void drawEmptySlots(){
  background(180);
  image(bg,0,0,640,480);
  for (int col=0; col < nSlot; col++){
    for (int row=0; row < nSlot; row++){
        showSlot(col, row, SLOT_OFF);
    }
  }
}

void showSlot(int col, int row, int slotState){
  int x = ix + col*SLOT_SIZE;
  int y = iy + row*SLOT_SIZE;
  switch (slotState){
    case SLOT_EMPTY:
         fill(255);
         rect(x,y,SLOT_SIZE,SLOT_SIZE);
         break;
    case SLOT_OFF:
         fill(222,119,15);
         stroke(0);
         rect(x, y, SLOT_SIZE, SLOT_SIZE);
         break;
    case SLOT_BOMB:
          fill(255);
          rect(x,y,SLOT_SIZE,SLOT_SIZE);
          image(bomb,x,y,SLOT_SIZE, SLOT_SIZE);
          break;
    case SLOT_BOMB_CLICK:
          fill(246,211,48);
          rect(x,y,SLOT_SIZE,SLOT_SIZE);
          image(bomb,x,y,SLOT_SIZE, SLOT_SIZE);
          break;          
    case SLOT_SAFE:
          fill(255);
          rect(x,y,SLOT_SIZE,SLOT_SIZE);
          int count = countNeighborBombs(col,row);
          if (count != 0){
            fill(0);
            textFont( createFont("font/Square_One.ttf",SLOT_SIZE*3/5) , SLOT_SIZE*3/5);
            text( count, x+15, y+15+SLOT_SIZE*3/5);
          }
          break;
    case SLOT_FLAG:
          image(flag,x,y,SLOT_SIZE,SLOT_SIZE);
          break;
    case SLOT_FLAG_BOMB:
          image(cross,x,y,SLOT_SIZE,SLOT_SIZE);
          break;
    case SLOT_DEAD:
          fill(255,0,0);
          rect(x,y,SLOT_SIZE,SLOT_SIZE);
          image(bomb,x,y,SLOT_SIZE,SLOT_SIZE);
          break;
  }
}

// select num of bombs
void mouseClicked(){
  if ( gameState == GAME_START &&
       mouseY > width/3 && mouseY < width/3+50){
       // select 1~9
       //int num = int(mouseX / (float)width*9) + 1;
       int num = (int)map(mouseX, 0, width, 0, 9) + 1;
       // println (num);
       bombCount = num;
       
       // start the game
       for(int ix=0;ix<4;ix++){
         for(int iy=0;iy<4;iy++){
           checkCol_Row_Bombs[ix][iy]=0;
         }
       }
       
       for(int ix=0;ix<4;ix++){
         for(int iy=0;iy<4;iy++){
           checkCol_Row_Flags[ix][iy]=0;
         }
       }
       
       for(int ix=0;ix<4;ix++){
         for(int iy=0;iy<4;iy++){
           checkCol_Row_Click[ix][iy]=0;
         }
       }
       

       bombExplode = false;
       clickCount = 0;
       flagCount = 0;
       setBombs();
       drawEmptySlots();
       gameState = GAME_RUN;
  }
}

void mousePressed(){
  if ( gameState == GAME_RUN &&
       mouseX >= ix && mouseX <= ix+sideLength && 
       mouseY >= iy && mouseY <= iy+sideLength){
    
    // --------------- put you code here -------     

    int slotpositionX = (int)map(mouseX, ix , ix+sideLength , 0 , 4);
    int slotpositionY = (int)map(mouseY, iy , iy+sideLength , 0 , 4);
    
  if(mouseButton==LEFT){
    if(checkCol_Row_Bombs[slotpositionX][slotpositionY]==1){
      clickBombX = slotpositionX;
      clickBombY = slotpositionY;
      bombExplode = true;

    }
    else if(checkCol_Row_Click[slotpositionX][slotpositionY]==0){
      showSlot(slotpositionX, slotpositionY, SLOT_SAFE);
      countNeighborBombs(slotpositionX,slotpositionY);
      checkCol_Row_Click[slotpositionX][slotpositionY] = 1;
      clickCount++;
    }
  }
  if(mouseButton==RIGHT && checkCol_Row_Click[slotpositionX][slotpositionY]==0){
    if(checkCol_Row_Flags[slotpositionX][slotpositionY]==0){
      if(flagCount < bombCount){
        //println(flagCount);
        showSlot(slotpositionX, slotpositionY, SLOT_FLAG);
        checkCol_Row_Flags[slotpositionX][slotpositionY]=1;
        flagCount++;
        //println(flagCount);
      }
      if(flagCount > bombCount){
      showSlot(slotpositionX, slotpositionY, SLOT_OFF);
      }
    }

    else{
      //println(flagCount);
      showSlot(slotpositionX, slotpositionY, SLOT_OFF);
      checkCol_Row_Flags[slotpositionX][slotpositionY]=0;
      flagCount--;
      //println(flagCount);      
    }
  }
 }
 

}

// press enter to start
void keyPressed(){
  if(key==ENTER && (gameState == GAME_WIN || 
                    gameState == GAME_LOSE)){
     gameState = GAME_START;
  }
}
