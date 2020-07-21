using JuMP, Gurobi

gfc = Model(Gurobi.Optimizer)

@variable(gfc, x >= 0)
@variable(gfc, y >= 0)

@constraint(gfc, 4x + 9y <= 60)
@constraint(gfc, x - 3y >= -8)
@constraint(gfc, 3x + 2y <= 30)
@constraint(gfc, x <= 12)
@constraint(gfc, x + 2y <= 14)           #GFC-1 derived from the optimal simplex tableau
@constraint(gfc, 95x + 171y <= 1273)     #GFC-2 derived from the optimal simplex tableau
@constraint(gfc, x + y <= 11)            #GFC-3 derived from the optimal simplex tableau

@objective(gfc, Max, 5x + 9y)

optimize!(gfc)

println("The objective value is = ", objective_value(gfc))
println("x = ", value(x))
println("y = ", value(y))
