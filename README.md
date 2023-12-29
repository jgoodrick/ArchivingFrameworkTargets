
Purpose:
For reproducing an issue I am running into while trying to archive a framework target that depends on TCA

Steps Taken:

1. Created a basic SPM Package
2. Created a basic iOS framework that depends on the above SPM Package library product
3. Added script to automatically clean, build, and archive the framework for simulator only
4. Ran script: Success.
5. Added dependency on TCA to the SPM library. Added a new LibraryReducer type and made it public (using macros)
6. Imported TCA in the framework target and created a parent reducer for the LibraryReducer (using macros)
7. Ran script: Failed. Commands that failed are SwiftEmitModule and SwiftCompile (after compiling Swift-Syntax)
8. Bumped the minimum deployment target to 17.2 (it was 16.0 previously, during failure)
9. Ran script: Success. 

However, I need to build for 16.0. Xcode archives with no problem.

10. Reverted the minimum deployment target to iOS 16.0 
10. Removed dependence on macros by dropping TCA version to 0.59.0 and fixing build errors (removing macros)
11. Ran script: Success.

At this point, I'm not 100% sure if the dependency of swift-syntax is enough for failure, or if it is the actual use of the macros

12. Updated branch of TCA targeted to "main" (resolving to 1.5.6 at this time)  
13. Ran script: Success.

Conclusion:

Therefore, it is the actual use of the macros in the project that causes the failure to compile from the command line. 

This is particularly strange since archiving from Xcode itself seems to work just fine, with no changes to the settings or scheme whatsoever.


NOTE: If running this script locally, make sure that this repository is in a containing folder that can have an "Artifacts" folder created and written to. (This was done to keep the build artifacts outside of the repository). Also, if signing is required, you will need to add your own development team identifier (and potentially change the bundle ID) in the framework target's xcconfig file.
