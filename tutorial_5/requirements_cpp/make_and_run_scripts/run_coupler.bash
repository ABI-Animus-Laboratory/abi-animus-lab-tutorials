#!/bin/bash 

### IMPORTANT NOTE: it's safer to specify absolute paths only, as folders with solvers and input files might change location one with respect to the other

FOLDERcoupler="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

FOLDERcpp="./../generated_models/cvs_model_hybrid_cpp"
# FOLDERcpp="./../generated_models/cvs_model_with_arm_hybrid_cpp"

FILEconfig="coupler_config.json"

USE_PETSC=0
# USE_PETSC=1

cd "$FOLDERcpp" || exit 1

# spack load sundials

if [[ "$USE_PETSC" -eq 1 ]]; then
    make -f MakefilePETSC clean
    make -f MakefilePETSC
else
    make -f Makefile clean
    make -f Makefile
    export LD_LIBRARY_PATH=$(spack location -i sundials)/lib:$LD_LIBRARY_PATH
fi
# make clean
# make
# export LD_LIBRARY_PATH=$(spack location -i sundials)/lib:$LD_LIBRARY_PATH

# cd /hpc/bghi639/Software/1D-0D-coupler-cpp-example/CA_coupler_scripts
cd "$FOLDERcoupler" || exit 1

# make -f Makefile clean
# make -f Makefile clean_pipe
# make -f Makefile
make -f MakefileCoupler clean
make -f MakefileCoupler clean_pipe
make -f MakefileCoupler

echo "*** RUNNING THE COUPLER NOW ***"

# ./coupler "$FOLDERcpp/$FILEconfig"
# ./coupler "$FOLDERcpp/$FILEconfig" > log_$(date +'%Y-%m-%d_%H-%M-%S').txt
# ./coupler "$FOLDERcpp/$FILEconfig" > log_$(date +'%Y-%m-%d_%H-%M-%S').txt & 
./coupler "$FOLDERcpp/$FILEconfig" > log_$(date +'%Y-%m-%d_%H-%M-%S').txt 2>&1 &

echo "*** SUCCESS $(date +'%Y-%m-%d_%H-%M-%S') ***"
