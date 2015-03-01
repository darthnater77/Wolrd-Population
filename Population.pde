FloatTable data;
PFont title, axis, label;
int space;
int current;
int rows, columns;

void setup(){
  size(1000, 700);
  space = 75;
  data = new FloatTable("WorldData.tsv");
  rows = data.getRowCount();
  columns = data.getColumnCount();
  title = createFont("Times New Roman", 24);
  axis = createFont("Times New Roman", 12);
  label = createFont("Times New Roman", 18);
  current = rows;
}

void draw(){
  background(255);
  fill(0);
  stroke(0);
  drawTitle();
  drawAxis();
  //drawCountries();
  drawData();
}

void drawTitle(){
  textAlign(CENTER);
  textFont(title);
  text("Change in World Population by Country", width/2, 30);
}

void drawAxis(){
  int n = space;
  line(n,n,n,height-n);
  line(n,height-n,width-n,height-n);
  
  xAxis();
  yAxis();
}

void xAxis(){
  textFont(axis);
  int n = space;
  String [] x = data.getColumnNames();
  float div = (width-1.9*n)/x.length;
  for(int i = 0; i < x.length; i++){
    line(n+div*i,height-n,n+div*i,height-n+5);
    if (i%5 == 0)
      text(x[i],n+div*i,height -(n/1.5));
  }
  textFont(label);
  text("Year", width/2, height - (n/5));
}

void yAxis(){
  textFont(axis);
  textAlign(RIGHT, CENTER);
  int n = space;
  int gap = 14;
  float div = (height-2*n)/gap;
  float step = (data.getTableMax())/gap;
  for(int i = 0; i < gap+1; i++){
    line(n-5,(height-n)-div*i,n,(height-n)-div*i);
    text(nf((step*i)/1000000,0,1)+"",n-15,(height-n)-div*i);
  }
}

void plotAll(){
  for (int i = 0; i < rows; i++){
     singleLine(i);
  }
}

void singleLine(int i){
  float x, y;
  float prevX = 0;
  float prevY = 0;
  float div = (width-1.9*space)/columns;
  for(int j = 0; j < columns; j++){
    x = space + (Integer.parseInt(data.getColumnName(j)) - Integer.parseInt(data.getColumnName(0)))*div;
    y = map(data.getFloat(i,j), 0, data.getTableMax(), height-space, space);
    // point(x,y);
    if (j > 0)
      line(x,y,prevX,prevY);
    prevX = x;
    prevY = y;
  }
}

void drawData(){
  textAlign(CENTER);
  textFont(label);
  if (current < rows){
    singleLine(current);
    text(data.getRowName(current), width/2, space/1.5);
  }
  else{
    plotAll();
    text("All Countries", width/2, space/1.5);
  }
}

void drawCountries(){
  textFont(axis);
  textAlign(LEFT,BOTTOM);
  float div = (height)/rows;
  for (int i = 0; i < rows; i++){
    text(data.getRowName(i),width-space + 10,space/2+div*i);
  }
}

void keyPressed(){
  if (key == 'a'){
    current--;
    if (current < 0)
      current = rows;
  }
  else if (key == 's'){
    current++;
    if (current > rows)
      current = 0;
  }
}
