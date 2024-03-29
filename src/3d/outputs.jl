#=
secondarycirculation/outputs.jl
    Additional fields to output, none in this case
=#
using Oceananigans
using Oceananigans.Utils: OrSchedule, SpecifiedTimes

# This macro should define and create output writers for any desired saved fields
macro additional_outputs!(simulation)
    return quote
        $simulation.output_writers[:buoyancy_evolution] = JLD2OutputWriter(
            model,
            (; u, v, w, b),
            filename = "$output_folder/3d_state.jld2",
            schedule = OrSchedule(TimeInterval(1/sp.f), SpecifiedTimes(init_time:0.1:init_time+10)),
            overwrite_existing = true
        )
        @info "Created 3D state writer"
    end
end

#= 
return quote
        # Define the lateral and geostrophic shear production and buoyancy flux
        
        LSP = Field(Average((u - u_dfm) * (v - v_dfm); dims=2)) * ∂x(v_dfm)
        GSP = Field(Average((w - w_dfm) * (v - v_dfm); dims=2)) * ∂z(v_dfm)
        
        uFLUX = Average((w - w_dfm) * (u - u_dfm); dims=2)
        vFLUX = Average((w - w_dfm) * (v - v_dfm); dims=2)
        wFLUX = Average((w - w_dfm) * (w - w_dfm); dims=2)
        bFLUX = Average((w - w_dfm) * (b - b_dfm); dims=2)
        
        $simulation.output_writers[:turbulent_flux] = JLD2OutputWriter(
            model,
            (; bFLUX, uFLUX, vFLUX, wFLUX),
            filename = "$output_folder/turbulent_flux.jld2",
            schedule = TimeInterval(1/(sp.f*write_freq)),
            overwrite_existing = true
        )
        
        $simulation.output_writers[:shearproduction] = JLD2OutputWriter(
            model,
            (; LSP, GSP),
            filename = "$output_folder/shear_production.jld2",
            schedule = TimeInterval(1/(sp.f*write_freq)),
            overwrite_existing = true
        )
        
        q = (∂x(v_dfm) + sp.f) * ∂z(b_dfm) - ∂z(v_dfm) * ∂x(b_dfm)
        invRi = ∂z(v_dfm) * ∂z(v_dfm) / ∂z(b_dfm)
        
        $simulation.output_writers[:qRi] = JLD2OutputWriter(
            model,
            (; q, invRi),
            filename = "$output_folder/qRi.jld2",
            schedule = TimeInterval(1/(sp.f*write_freq)),
            overwrite_existing = true
        )
        
        ω = Field(∂z(u_dfm) - ∂x(w_dfm))
        ω_depth = Average(ω * ω; dims=(1, 2))
        $simulation.output_writers[:secondarycirculation] = JLD2OutputWriter(
            model,
            (; ω, ω_depth),
            filename = "$output_folder/secondary_circulation.jld2",
            schedule = TimeInterval(1/(sp.f*write_freq)),
            overwrite_existing = true
        )
        
        pHY′ = Average(model.pressures.pHY′; dims=2)
        pNHS = Average(model.pressures.pNHS; dims=2)
        $simulation.output_writers[:pressure] = JLD2OutputWriter(
            model,
            (; pHY′, pNHS),
            filename = "$output_folder/pressure.jld2",
            schedule = TimeInterval(1/(sp.f*write_freq)),
            overwrite_existing = true
        )
        
        $simulation.output_writers[:full_state] = JLD2OutputWriter(
            model,
            (; u, v, w, b),
            filename = "$output_folder/full_state.jld2",
            schedule = TimeInterval(1/(sp.f)),
            overwrite_existing = true
        )
    end
=#