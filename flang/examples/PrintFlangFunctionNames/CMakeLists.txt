# TODO: Note that this is currently only available on Linux.
# On Windows, we would also have to specify e.g. `PLUGIN_TOOL`.
add_llvm_example_library(flangPrintFunctionNames
    MODULE
    PrintFlangFunctionNames.cpp

    DEPENDS
    acc_gen
    flangFrontend
    omp_gen
)
