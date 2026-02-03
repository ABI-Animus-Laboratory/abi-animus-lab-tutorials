/**
*	Publication: Maso Talou, G.D., Safaei, S., Hunter, P.J. et al. Adaptive constrained constructive optimisation *   for complex vascularisation processes. Sci Rep 11, 6180 (2021). https://doi.org/10.1038/s41598-021-85434-9
*	@author: Gonzalo D Maso Talou
*	@affiliation: The University of Auckland
*/

// g++ example_1.cpp -Wall -std=c++11 -O3 -I/hpc/gmas685/workspaces/eclipse-workspace/vita/vita_build/include/vtk-8.1 -I/hpc/gmas685/workspaces/eclipse-workspace/vita/include/vita_source -L/hpc/gmas685/workspaces/eclipse-workspace/vita/vita_build/lib -L/hpc/gmas685/workspaces/eclipse-workspace/vita/lib -o example_1 -lVItA -lvtkCommonCore-8.1 -lvtkCommonDataModel-8.1 -lvtkCommonExecutionModel-8.1 -lvtkFiltersModeling-8.1 -lvtkIOCore-8.1 -lvtkIOLegacy-8.1 -lvtkIOXML-8.1 -lvtkIOGeometry-8.1 -lvtkInfovisCore-8.1 -lvtkFiltersGeneral-8.1 -lvtkFiltersCore-8.1 -lvtkCommonTransforms-8.1 -lvtkIOXMLParser-8.1

// STD Libs
#include<cmath>
#include<string>
#include<ctime>
#include<cstdio>
#include<cstdlib>
#include<vector>

// VItA Libs
#include<structures/domain/AbstractDomain.h>
#include<structures/domain/StagedDomain.h>
#include<core/GeneratorData.h>
#include<core/StagedFRROTreeGenerator.h>
#include<constrains/ConstantConstraintFunction.h>
#include<structures/tree/SingleVesselCCOOTree.h>
#include<structures/vascularElements/AbstractVascularElement.h>
#include<io/VTKObjectTreeNodalWriter.h>
#include<structures/domain/SimpleDomain2D.h>

using namespace std;

void vascularise(string output_filename, AbstractConstraintFunction<double, int>* gam,
    AbstractConstraintFunction<double, int>* delta, AbstractConstraintFunction<double, int>* eta,
    int n_draw, int seed, int N_fail, double l_lim_fr,
    double perfusion_area_factor, double close_neighborhood_factor, int Delta_nu,
    double theta_min)
{

    // Boundary conditions - Flow, radius and position of the inlet 
    double q0 {10};
    double r0 {0.05};
    point x0 {0.99, 0.99, -0.0005};
    
    // Number of terminals to be generated
    long long int n_term {500};
    // Domain geometry
    string input_vtk = "ex1_simple2D.vtk";
    
    // Optimisation parameters
    GeneratorData *gen_data_0 = new GeneratorData(16000, N_fail, l_lim_fr, perfusion_area_factor, close_neighborhood_factor, 0.25, Delta_nu, 0, false);    

    // Domain definition
    SimpleDomain2D *domain_0 = new SimpleDomain2D(input_vtk, n_draw, seed, gen_data_0);
    domain_0->setMinBifurcationAngle(theta_min);
    domain_0->setIsConvexDomain(true);

    // Define domain stages
    StagedDomain *staged_domain = new StagedDomain();
    staged_domain->addStage(n_term, domain_0);

    // Creation of DCCO generator
    StagedFRROTreeGenerator *tree_generator = new StagedFRROTreeGenerator(staged_domain, x0, r0, q0, n_term, {gam}, {delta}, {eta}, 0., 1.e-5);
    SingleVesselCCOOTree *tree = static_cast<SingleVesselCCOOTree *>(tree_generator->getTree());
    // Indicates that all meshes and boundary conditions are in cm (important for the viscosity computation).
    tree->setIsInCm(true);

    // Executes DCCO generator
    tree_generator->generate(10, ".");
        
    // Saves the outputs as CCO and VTP files
    tree->save(output_filename + ".cco");
    VTKObjectTreeNodalWriter *tree_writer = new VTKObjectTreeNodalWriter();
    tree_writer->write(output_filename + ".vtp", tree);
          
    delete tree_writer;
    delete tree_generator;
    delete staged_domain;
    delete domain_0;
    delete gen_data_0;
}


int main(int argc, char *argv[])
{
    // Consecutive attempts to generate a point - N_fail
    int N_fail = 200;
    // Correction step factor - fr - Eq (14)
    double l_lim_fr = 0.9;
    // Discretisation of the testing triangle for the bifurcation - Delta nu - Figure 1
    int Delta_nu = 7;

    // Geometrical constrains - 
    // Power-law coefficient - gamma - Eq (3) - Murray's law
    AbstractConstraintFunction<double,int> *gam {new ConstantConstraintFunction<double, int>(3.)};
    // Symmetry ratio parameter - delta - Eq (4)
    AbstractConstraintFunction<double,int> *delta {new ConstantConstraintFunction<double, int>(0)};
    // Viscosity in cP - eta - Eq (7)
    AbstractConstraintFunction<double,int> *eta {new ConstantConstraintFunction<double, int>(3.6)};

    // Buffer size for random point generation
    int n_draw {10000};
    // Random seed
    int seed {2208};
    // Minimum bifurcation angle - theta_min - Eq (17) 
    double theta_min {(3./18.) * M_PI};
    // l_min tuning parameter - nu - Eq (12)
    double perfusion_area_factor {1.0};
    // Heuristic parameter to reduce the neighbour vessels to be tested for connections in line 15 of Algorithm 2
    double close_neighbourhood_factor {4.0};

    vascularise("ex1_simple2D", gam, delta, eta, n_draw, seed, N_fail, l_lim_fr, perfusion_area_factor, close_neighbourhood_factor, Delta_nu, theta_min);
    
    delete gam;    
    delete delta;
    delete eta;
        
    return 0;
} 
