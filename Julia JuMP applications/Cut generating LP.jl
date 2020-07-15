using JuMP, Gurobi

cglp = Model(Gurobi.Optimizer)

dim =  2
A1 = [-1 3; 0 1; 3 2]
A2 = [-1 3; 0 -1; 4 9]
b1 = [8 3 30]
b2 = [8 -4 60]
xstar = [150/19 60/19]

@variable(cglp, alphaplus[1:dim] >= 0)
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
