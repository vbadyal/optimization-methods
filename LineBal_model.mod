set WRKST;                                                                                                                                                                                                         #set of workstations

set TASKS;                                                                                                                                                                                                           #set of tasks

set MODELS;                                                                                                                                                                                                      #set of models/products

set PR {TASKS};                                                                                                                                                                                                  #subset of all tasks that precede task i, i=1,...,N

set S {TASKS};                                                                                                                                                                                                     #subset of all tasks that follow task i, i=1,...,N 

set AsblTask {WRKST, MODELS};                                                                                                                                                                 #subset of tasks and models pair

set IP {TASKS, TASKS};                                                                                                                                                                                     #set of immediate predecessors

param ttime {TASKS, MODELS} >= 0;                                                                                                                                                        #task times for different models                

param C {MODELS} >= 0;                                                                                                                                                                              #cycle time for different models                     

param EM {i in TASKS, m in MODELS} = ceil((ttime[i,m]+sum {j in PR[i]} t[j,m])/C[m])                                                            #earliest station assignment for a task and a model

param LM {i in TASKS, m in MODELS} = card(WRKST) +1-ceil((ttime[i,m]+sum {j in S[i]} t[j,m])/C[m])                              #latest station assignment for a task and model
      
param E {i in TASKS} = max(EM[i,1]..EM[i,card(MODELS)])                                                                                                              #earliest station assignment for a task

param L {i in TASKS} = max(LM[i,1]..LM[i,card(MODELS)])                                                                                                               #latest station assignment for a task and model

var TaskAssign{TASKS, WRKST} binary;                                                                                                                                                   #0/1 variable to assign a task to a workstation  

var StationAssign{WRKST, MODELS} binary;                                                                                                                                        #0/1 variable to determine if a model utilizes a workstation 

var WRKSTutil {WRKST} binary;                                                                                                                                                                #0/1 variable to determine if a workstation is utilized by all models

minimize total_station_utilized:                                                                                                                                                              #objective function minimizes number of stations
sum{k in WRKST} WRKSTutil[k];    

subject to assignment_constraints {i in TASKS}:                                                                                                                                 #assignment constraint
sum{k in E[i]..L[i]} TaskAssign[i,k]=1;             

subject to precedence_constraints {(a,b) in IP: L[a]>=E[b]>=E[a]}:                                                                                               #precedence constraint
sum{k in E[a]..L[a]} k*TaskAssign[a,k]-sum{k in E[b]..L[b]} k*TaskAssign[b,k]<=0;             

subject to CT_constraints {k in WRKST, m in MODELS}:                                                                                                                    #cycle time constraint
sum {i in AsblTask[k,m]} ttime[i,m]*TaskAssign[i,k] <= C[m];                          

subject to station_constraints1 {k in WRKST, m in MODELS}:                                                                                                         # station utilization constraint-1/2
sum{i in AsblTask[k,m]} TaskAssign[i,k] - card(AsblTask[k,m])*StationAssign[k,m] <= 0;                         

subject to station_constraints2 {k in WRKST}:                                                                                                                                     # station utilization constraint-2/2
sum{m in 1..card(MODELS)} StationAssign[k,m] - P*WRKSTutil[k] = 0;                        

