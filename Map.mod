set STATES;                                                                                                       

set NEIGHBORS within {STATES, STATES};                                            

set COLORS;                                                                                                    

var ColorAssign {STATES, COLORS} binary;                      

var ColorUsed {COLORS} binary; 

minimize total_colors_utilized: 
sum{c in COLORS} ColorUsed[c];    

subject to edge_constraints {(u,v) in NEIGHBORS, c in COLORS}:
ColorAssign[u,c] + ColorAssign[v,c]<=1;             

subject to color_constraints {u in STATES, c in COLORS}:
ColorAssign[u,c] <= ColorUsed[c];

subject to assignment_constraints {u in STATES}:
sum{c in COLORS}ColorAssign[u,c] =1 ;

        

                   

