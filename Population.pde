FloatTable data;

void setup(){
  size(1000, 600);
  data = new FloatTable("WorldData.tsv");
}

void draw(){
  background(255);
  fill(0);
  text("Change in World Population by Country", width/2, 20);
  drawAxis();
}

void drawAxis(){
  
}
