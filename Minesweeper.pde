import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 10;
public final static int NUM_COLS = 10;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mines
private boolean firstClick = true;
void setup ()
{
    size(400, 450);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0;r<NUM_ROWS;r++){
      for(int c = 0; c<NUM_COLS; c++){
        buttons[r][c] = new MSButton(r,c);
      }
    }
    
    int amountOfMines = (int)(Math.random()*15)+15;
    for(int i = 0; i<amountOfMines;i++)
      setMines();
    //check whats in mines
    
    for(int i = 0; i<mines.size();i++){
      System.out.println(mines.get(i).getmyCol()+", " +mines.get(i).getmyRow());     
    }
    
}
public void setMines()
{
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if(!mines.contains(buttons[r][c])){
      mines.add(buttons[r][c]);
    }
}

public void draw ()
{
if(!isWon()&&!isLost()){
  background(0);
}
    if(isWon() == true){
       displayWinningMessage();
    }
  //  if(isLost()==true){
   //   displayLosingMessage();
   // }
}
public boolean isWon()
{
    for(int r = 0; r<NUM_ROWS;r++)
      for(int c = 0; c<NUM_COLS;c++)
        if(!mines.contains(buttons[r][c])&&(!buttons[r][c].clicked))
          return false;//if there are safe spaces that haven't been clicked
    return true;
}

public boolean isLost()
{
  for(int r = 0;r<NUM_ROWS;r++){
      for(int c = 0; c<NUM_COLS;c++){
        if(mines.contains(buttons[r][c])&&buttons[r][c].clicked&&buttons[r][c].myClick == 0)
          return true;
        }}
        return false;
}



public void displayLosingMessage()
{
   for(int i = 0;i<mines.size();i++){
    mines.get(i).clicked = true;
    }
    textSize(50);
    fill(250);
    text("YOU LOST!",width/2,25);
    }


public void resetMines(int row, int col){
  while(mines.size()>0){mines.remove(0);}
  int amountOfMines = (int)(Math.random()*15)+15;
  for(int i = 0; i<amountOfMines;i++)
   setMines();
  if(mines.contains(buttons[row][col])||countMines(row,col)!=0){
    resetMines(row,col);
  } 
  buttons[row][col].mousePressed();
  System.out.println("mines reset bc user clicked " + row + ", " + col);
  }
  
  

public void displayWinningMessage()
{
 // System.out.println("success");
  textSize(50);
  fill(250);
  text("YOU WON!",width/2,25);
}
public boolean isValid(int r, int c)
{
  if(r>NUM_ROWS-1||c>NUM_COLS-1||c<0||r<0){return false;}
  return true;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = row-1; r<=row+1; r++)
      for(int c = col-1;c<=col+1;c++)
        if (isValid(r,c)&&mines.contains(buttons[r][c])){numMines++;}
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    private int myClick;//1= RIGHT,2=LEFT
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = (myRow*height)+50;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true; 
        int numMines = countMines(myRow,myCol);
       if(mouseButton == RIGHT){
          myClick = 1;
          flagged=!flagged;
       }
       else if(mines.contains(this)&&firstClick==false){
          myClick = 0; 
         displayLosingMessage();
           System.out.println("hit a mine: "+myRow+", "+myCol);
       }
       else if(mines.contains(this)&&firstClick==true){
         myClick = 0;
         resetMines(myRow,myCol);
       }
        else if(numMines>0){
          myClick = 0;
          setLabel(numMines);
          System.out.println("counted mines: there are "+numMines+" mines.");
        }
        else {
          myClick = 0;
          for(int r = myRow-1;r<=myRow+1;r++){
            for(int c = myCol-1;c<=myCol+1;c++)
              if(isValid(r,c)&&!buttons[r][c].clicked)
                buttons[r][c].mousePressed();
          }
        //System.out.println("no mines, recursed");
        }
        firstClick = false; 
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        textSize(10);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public int getmyRow(){
      return myRow;
    }
    public int getmyCol(){
      return myCol;
    }}
