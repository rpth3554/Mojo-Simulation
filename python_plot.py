import time
from lasso.dyna import D3plot, ArrayType, FilterType

start_time = time.time()
d3plot = D3plot("/home/bladerunner/Public/seat_02/d3plot")
#d3plot.plot(-1)

# get eff. plastic strain
pstrain = d3plot.arrays[ArrayType.element_shell_effective_plastic_strain]
pstrain.shape

# mean across all 3 integration points
pstrain = pstrain.mean(axis=2)
pstrain.shape



# we only have 1 timestep here but let's take last one in general
last_timestep = -1
#d3plot.plot(0, field=pstrain[last_timestep])
# we don't like the fringe, let's adjust

#end_time = time.time()
d3plot.plot(i_timestep=14, field=pstrain[last_timestep], fringe_limits=(0, 0.3))
print("number of times steps are", d3plot._state_info.n_timesteps)
end_time = time.time()
elapsed_time = end_time - start_time
print(elapsed_time)
