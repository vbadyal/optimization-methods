using JuMP, Gurobi

gmi = Model(Gurobi.Optimizer)

@variable(gmi, x >= 0)
@variable(gmi, y >= 0)

@constraint(gmi, 4x + 9y <= 60)
@constraint(gmi, x - 3y >= -8)
@constraint(gmi, 3x + 2y <= 30)
@constraint(gmi, x <= 12)
@constraint(gmi, x + 2y <= 14)
@constraint(gmi,x + y <= 11)

@objective(gmi, Max, 5x + 9y)

optimize!(gmi)

println("The objective value is: ",objective_value(gmi))
println("x = ",value(x))
println("y = ",value(y))
