using JuMP, Gurobi

cglp = Model(Gurobi.Optimizer)

A1 = [-1 0 3]
B1 = [3 1 2]
A2 = [-1 0 4]
B2 = [3 -1 9]
b1 = [8 3 30]
b2 = [8 -4 60]
xstar = [150/19 60/19]

@variable(cglp, alphaplus >= 0)
@variable(cglp, betaplus >= 0)
@variable(cglp, alphaminus >= 0)
@variable(cglp, betaminus >= 0)
@variable(cglp, alphazero)
@variable(cglp, u[1:3] >= 0)
@variable(cglp, v[1:3] >= 0)

@objective(cglp, Max, sum((alphaplus - alphaminus) * xstar[1] + (betaplus-betaminus) * xstar[2]) - alphazero)


@constraint(cglp, sum(u[i] * A1[i] for i=1:3) >= (alphaplus - alphaminus))
@constraint(cglp, sum(v[i] * A2[i] for i=1:3) >= (alphaplus - alphaminus))
@constraint(cglp, sum(u[i] * B1[i] for i=1:3) >= (betaplus - betaminus))
@constraint(cglp, sum(v[i] * B2[i] for i=1:3) >= (betaplus - betaminus))
@constraint(cglp, sum(v[i] * b2[i] for i=1:3) <= alphazero)
@constraint(cglp, sum(u[i] * b1[i] for i=1:3) <= alphazero)
@constraint(cglp, (betaplus + betaminus) + (alphaplus + alphaminus) == 1)

optimize!(cglp)

println("The objective value is=", objective_value(cglp))
println("alpha=", value(alphaplus) - value(alphaminus))
println("beta=", value(betaplus) - value(betaminus))
println("alphazero=", value(alphazero))
