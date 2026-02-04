#include <petsc.h>
#include <iostream>

int main(int argc, char **argv) {
    PetscErrorCode ierr;
    ierr = PetscInitialize(&argc, &argv, NULL, NULL); if (ierr) return ierr;
    
    PetscPrintf(PETSC_COMM_WORLD, "Hello, PETSc! Verification successful.\n");
    
    ierr = PetscFinalize();
    return ierr;
}
