using JuMP, Gurobi

cglp = Model(Gurobi.Optimizer)

dim =  2
A1 = [-1 3; 0 1; 3 2]    #Use a split disjunction of your choice, using (y<=3 v y>=4) here. 
A2 = [-1 3; 0 -1; 4 9]
b1 = [8 3 30]
b2 = [8 -4 60]
xstar = [150/19 60/19] # Fractional point to be cut off using split cut (x,y)

@variable(cglp, alphaplus[1:dim] >= 0)       #modeling a free variable using two positive variables 
@variable(cglp, alphaminus[1:dim] >= 0)
@variable(cglp, beta)
@variable(cglp, u[1:3] >= 0)
@variable(cglp, v[1:3] >= 0)

@objective(cglp, Max, sum((alphaplus[j] - alphaminus[j]) * xstar[j] for j = 1:dim) - beta)

@constraint(cglp, Constr1[j in 1:dim], sum(u[i] * A1[i,j] for i=1:3) >= (alphaplus[j] - alphaminus[j]))
@constraint(cglp, Constr2[j in 1:dim], sum(v[i] * A2[i,j] for i=1:3) >= (alphaplus[j] - alphaminus[j]))
@constraint(cglp, sum(u[i] * b1[i] for i=1:3) <= beta)
@constraint(cglp, sum(v[i] * b2[i] for i=1:3) <= beta)
@constraint(cglp, sum((alphaplus[j] + alphaminus[j]) for j = 1:dim) == 1)

optimize!(cglp)

println("The objective value is = ", objective_value(cglp))

for j in 1:dim
println("alpha$j = ", value(alphaplus[j] - alphaminus[j])) 
end

println("beta = ", value(beta))

#If objective value > 0: Final split cut to be added to the original LP relaxation is (alpha1*x + alpha2*y <= beta)
#If objective value <= 0: xstar or (x,y) cannot be seperated from conv(p1 U p2).
