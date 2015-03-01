FloatTable data;
PFont title, axis, label;
int space;

void setup(){
  size(1000, 600);
  space = 75;
  data = new FloatTable("WorldData.tsv");
  title = createFont("Times New Roman", 24);
  axis = createFont("Times New Roman", 12);
  label = createFont("Times New Roman", 18);
}

void draw(){
  background(255);
  fill(0);
  stroke(0);
  textAlign(CENTER);
  textFont(title);
  text("Change in World Population by Country", width/2, 30);
  drawAxis();
}

void drawAxis(){
  int n = space;
  line(n,n,n,height-n);
  line(n,height-n,width-n,height-n);
  
  xAxis();
  yAxis();
  
  plotPoints();
}

void xAxis(){
  int n = space;
  String [] x = data.getColumnNames();
  float div = (width-1.9*n)/x.length;
  textFont(axis);
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
  int gap = 15;
  float div = (height-2*n)/gap;
  float step = (data.getTableMax())/gap;
  for(int i = 0; i < gap; i++){
    line(n-5,(height-n)-div*i,n,(height-n)-div*i);
    text(nf((step*i)/1000000,0,2)+"",n-15,(height-n)-div*i);
  }
}

void plotPoints(){
  float div = (width-1.9*space)/data.getColumnCount();
  for (int i = 0; i < data.getRowCount(); i++){
    for(int j = 0; j < data.getColumnCount(); j++){
      float x = space + (Integer.parseInt(data.getColumnName(j)) - Integer.parseInt(data.getColumnName(0)))*div;
      float y = map(data.getFloat(i,j), 0, data.getTableMax(), height-space, space);
      point(x,y);
    }
  }
}
