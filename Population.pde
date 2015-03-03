FloatTable data;
float[] world;
PFont title, axis, label, list;
int space;
int current, currentYear;
int rows, columns;
boolean pie;

void setup(){
  size(900, 700);
  space = 75;
  pie = true;
  
  String[] worldData = loadStrings("EntireWorld.tsv");
  world = new float[worldData.length];
  for (int i = 0; i < worldData.length; i++){
    world[i] = Float.parseFloat(worldData[i]);
  }
  
  data = new FloatTable("WorldData.tsv");
  rows = data.getRowCount();
  columns = data.getColumnCount();
  
  title = createFont("Times New Roman", 24);
  axis = createFont("Times New Roman", 12);
  label = createFont("Times New Roman", 18);
  list = createFont("Times New Roman", 10);
  
  current = rows;
  currentYear = 0;
}

void draw(){
  background(255);
  fill(0);
  stroke(0);
  drawTitle();
  if (pie == false){
    drawAxis();
    drawData();
  }
  else{
    drawPie();
    pieText();
  }
  drawCountries();
}

void drawTitle(){
  textAlign(CENTER);
  textFont(title);
  if (pie == false)
    text("Change in World Population by Country", width/2, 30);
  else
    text("Division of World Population by Year", width/2, 30);
}

void drawAxis(){
  int n = space;
  line(n,n,n,height-n);
  line(n,height-n,width-2*n,height-n);
  
  xAxis();
  yAxis();
}

void xAxis(){
  textFont(axis);
  int n = space;
  String [] x = data.getColumnNames();
  float div = (width-2.9*n)/x.length;
  for(int i = 0; i < x.length; i++){
    line(n+div*i,height-n,n+div*i,height-n+5);
    if (i%5 == 0 && !pie)
      text(x[i],n+div*i,height -(n/1.5));
    else if (pie){
      if(mouseX > n+div*(i-.5) && mouseX < n+div*(i+.5) && mouseY > height-1.25*n && mouseY < height-.5*n)
        currentYear = i;
      if (i == currentYear && pie)
        text(x[i],n+div*i,height -(n/1.5));
    }
  }
  textFont(label);
  if (!pie)
    text("Year", width/2, height - (n/3));
  else
    text("World Population: " + nf(world[currentYear]/1000000000,0,3) + " Billion", width/2, height - (n/3));
}

void yAxis(){
  textFont(axis);
  int n = space;
  text("People\n(Millions)", n/2 + 10, n/2);
  textAlign(RIGHT, CENTER);
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
  float div = (width-2.9*space)/columns;
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
    stroke(200);
    plotAll();
    stroke(0);
    singleLine(current);
    text(data.getRowName(current), width/2, space/1.5);
  }
  else{
    text("All Countries", width/2, space/1.5);
    plotAll();
  }
}

void drawCountries(){
  fill(0);
  textFont(list);
  textAlign(LEFT,BOTTOM);
  float div = (height)/rows;
  for (int i = 0; i < rows; i++){
    if (i != current)
      text(data.getRowName(i),width-space*1.5,space/3+div*i);
    else{
      fill(255,0,0);
      textFont(axis);
      text(data.getRowName(i),width-space*1.6,space/3+div*i);
      fill(0);
      textFont(list);
    }
    if (mouseX < width && mouseX > width-space*1.75 && mouseY < space/3+div*i && mouseY > space/3+div*(i-1)){
      current = i;
    }
  }
}

void drawPie(){
  xAxis();
  noStroke();
  float r = map(world[currentYear],world[0],world[columns-1],200,500);
  ellipse(width/2, height/2, r, r);
  
  float stop;
  float start = 0;
  for (int i = 0; i < rows; i++){
    if (i != current)
      fill(i);
    else
      fill(255,0,0);
    stop = start + (2*PI)*(data.getFloat(i,currentYear)/world[currentYear]);
    arc(width/2, height/2, r, r,start, stop);
    start = stop;
  }
}

void pieText(){
  text(data.getColumnName(currentYear), width/2, space/1.5);
}

void keyPressed(){
  if (key == 'a'){
    if (!pie){
      current--;
      if (current < 0)
        current = rows;
    }
    else{
      currentYear--;
      if (currentYear < 0)
        currentYear = columns-1;     
    }
  }
  else if (key == 's'){
    if (!pie){
      current++;
      if (current > rows)
        current = 0;
    }
    else{
      currentYear++;
      if (currentYear >= columns)
        currentYear = 0;     
    }
  }
  if (key == ' '){
    pie = !pie;
    current = rows;
    currentYear = 0;
  }
}
