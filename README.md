# Pyehtim

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://ptiede.github.io/Pyehtim.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://ptiede.github.io/Pyehtim.jl/dev/)
[![Build Status](https://github.com/ptiede/Pyehtim.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/ptiede/Pyehtim.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/ptiede/Pyehtim.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/ptiede/Pyehtim.jl)


This is a thin wrapper around the excellent [eht-imaging](https://github.com/achael/eht-imaging) package.
[PythonCall](https://github.com/cjdoris/PythonCall.jl) is used to interface with eht-imaging. The main export
is the `ehtim` object that contains the ehtim module. This means that all the usual `eht-imaging` commands
should work identically to how they work in Python. We also add some convenience functions. See the docs for details.



