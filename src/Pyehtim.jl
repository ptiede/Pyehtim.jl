module Pyehtim

using Reexport
@reexport using PythonCall
const ehtim = PythonCall.pynew()

export ehtim,
       get_datatable, get_arraytable, get_scantable,
       get_source, get_bw, get_fr_angles, get_radec,
       get_rf, get_mjd, load_uvfits_and_array, 
       scan_average


"""
    get_datatable(obs)

Extracts the eht-imaging obs.data into a Julia table. Note this copies the data.
For a non-copying version just access data the usual way
"""
function get_datatable(obs)
    obsamps = obs.data
    n = obsamps.dtype.names
    nj = Symbol.(pyconvert(Tuple, n))
    d = map(n) do i
        pyconvert(Vector, getindex(obsamps, i))
    end

    return NamedTuple{nj}(Tuple(d))
end

"""
    getarraytable(obs)

Construct the array table for a given eht-imaging obsdata object.
"""
function get_arraytable(obs)
    return (
        sites = pyconvert(Vector{Symbol}, obs.tarr["site"]),
        X     = pyconvert(Vector, obs.tarr["x"]),
        Y     = pyconvert(Vector, obs.tarr["y"]),
        Z     = pyconvert(Vector, obs.tarr["z"]),
        SEFD1 = pyconvert(Vector, obs.tarr["sefdr"]),
        SEFD2 = pyconvert(Vector, obs.tarr["sefdl"]),
        fr_parallactic = pyconvert(Vector, obs.tarr["fr_par"]),
        fr_elevation   = pyconvert(Vector, obs.tarr["fr_elev"]),
        fr_offset      = deg2rad.(pyconvert(Vector, obs.tarr["fr_off"])),
    )
end
       
"""
    scan_average(obs)

This homogenizes the scan times for an eht-imaging `Obsdata` object. This is needed
because eht-imaging has a bug that will sometimes create very small scans and
this can mess up both the closure construction and the gain scan times.
Note that this is only a problem if we
are fitting **scan averaged** data.
"""
function scan_average(obs)
    obsc = obs.copy()
    obsc.add_scans() # Add the scans before averaging otherwise the scan table is messed up!
    obsc = obsc.avg_coherent(0.0, scan_avg=true)
    stimes = pyconvert(Matrix, obsc.scans)
    times = pyconvert(Vector, obsc.data["time"])
    @info "Before homogenizing we have $(length(unique(times))) unique times"

    for r in eachrow(stimes)
        sbegin, send = r
        indices = findall(x-> (sbegin < x <= send), times)
        times[indices] .= (send+sbegin)/2
    end
    obsc.data["time"] = pylist(times)
    @info "After homogenizing we have $(length(unique(pyconvert(Vector, obsc.data["time"])))) unique times"

    return obsc
end


"""
    get_fr_angles(obs)

Returns the feed rotation angles for a given observation as a set of tuples.
The first tuple contains the elevation correction for site 1 and 2.
The second tuple returns the parallactic angle correction for site 1 and 2
"""
function get_fr_angles(ehtobs)
    el1 = pyconvert(Vector, ehtobs.unpack(pylist(["el1"]),ang_unit="rad")["el1"])
    el2 = pyconvert(Vector, ehtobs.unpack(pylist(["el2"]),ang_unit="rad")["el2"])

    # read parallactic angles for each station
    par1 = pyconvert(Vector, ehtobs.unpack(pylist(["par_ang1"]),ang_unit="rad")["par_ang1"])
    par2 = pyconvert(Vector, ehtobs.unpack(pylist(["par_ang2"]),ang_unit="rad")["par_ang2"])
    return (el1, el2), (par1, par2)
end

"""
    load_uvfits_and_array(uvfile, arrayfile=nothing; kwargs...)

Load a uvfits file with eht-imaging and returns a eht-imaging `Obsdata`
object. You can optionally pass an array file as well that will load
additional information such at the telescopes field rotation information
with the arrayfile. This is expected to be an eht-imaging produced array
or antenna file.
"""
function load_uvfits_and_array(uvfile, arrayfile=nothing; kwargs...)
    obs = ehtim.obsdata.load_uvfits(uvfile; kwargs...)
    if arrayfile !== nothing
        tarr = ehtim.io.load.load_array_txt(arrayfile).tarr
        obs.tarr = tarr
    end
    return obs
end

function get_radec(obs)::Tuple{Float64, Float64}
    return (pyconvert(Float64, obs.ra), pyconvert(Float64, obs.dec))
end

function get_mjd(obs)::Int
    return pyconvert(Int, obs.mjd)
end

function get_source(obs)::Symbol
    return pyconvert(Symbol, obs.source)
end

get_rf(obs) = pyconvert(Float64, obs.rf)
get_bw(obs) = pyconvert(Float64, obs.bw)

"""
    get_scantable(obs)

Constructs the scan table of a given observation.
"""
function get_scantable(obs)
    if PythonCall.Convert.pyisnone(obs.scans)
        obs.add_scans()
    end
    sc = pyconvert(Matrix, obs.scans)
    return ((start=sc[:,1], stop = sc[:,2]))
end




# Write your package code here.

function __init__()
    PythonCall.pycopy!(ehtim, pyimport("ehtim"))
end

end
