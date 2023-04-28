using EHTImaging
using Test

@testset "EHTImaging.jl" begin
    # Write your tests here.
    obs = load_uvfits_and_array(joinpath(@__DIR__, "SR1_M87_2017_096_hi_hops_netcal_StokesI.uvfits"))

    data  = get_datatable(obs)
    array = get_arraytable(obs)
    st    = get_scantable(obs)
    fr    = get_fr_angles(obs)
    r,d   = get_radec(obs)
    mjd   = get_mjd(obs)
    src   = get_source(obs)
    rf    = get_rf(obs)
    bw    = get_bw(obs)

    @test pyconvert(Bool, bw == obs.bw)
    @test pyconvert(Bool, rf == obs.rf)
    @test pyconvert(Bool, r == obs.ra)
    @test pyconvert(Bool, d == obs.dec)
end
