FloatTable data;
PFont title, axis, label;

void setup(){
  size(1000, 600);
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
  drawAxis(75);
}

void drawAxis(int n){
  line(n,n/2,n,height-n);
  line(n,height-n,width-n,height-n);
  
  String [] x = data.getColumnNames();
  float div = (width-1.9*n)/x.length;
  textFont(axis);
  for(int i = 0; i < x.length; i += 5){
    text(x[i],n+div*i,height -(n/1.5));
  }
 
  float min = data.getTableMin();
  int gap = 15;
  div = (height-1.1*n)/gap;
  float step = (data.getTableMax() - data.getTableMin())/gap;
  for(int i = 0; i < gap; i++){
    text((min+step*i)+"",n/2,height-(n+div*i));
  }
  
  textFont(label);
  text("Year", width/2, height - (n/5));
}

void plotPoints(){
  
}
