# Contributing

## Reporting an issue

Before reporting an error in the code or the documentation, you must first ensure that you are using the latest version of the package. Otherwise, you must check that it has not been corrected in a more recent version.

Issues must be reported exclusively throught the [issue reporting system](https://github.com/goualard-f/MicroFloatingPoints.jl/issues) on github. You must clearly identify in your comment the version of the package you are using, the steps to perform to replicate the issue, what you obtained and what you were expecting. You may provide a fix to the issue through a *[pull request](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue)*.

## Contributing code

The main objective of the package is to provide small IEEE 754-compliant floating-point number types that can be used as drop-in replacements for `Float32` and `Float64` in most code, and secondarily, to offer graphical methods to better understand what is going on when computing with these types. 

Contributions that increase the performances, or further the compatibility of the `Floatmu{}` parametric type with the `Float32` and `Float64` standard types (e.g., through providing support for mathematical functions not already supported) are most welcome. So are graphical functions that provide a novel way of graphically visualizing floating-point computations, provided they make sense with the small `Floatmu{}` types.

### What will not be considered

No contribution that would break the IEEE 754 compliance of the `Floatmu{}` types will be considered. The same goes for code that would add non IEEE 754-compliant new types or types with greater range or precision than `Float32`, for which there are already well-established Julia types (e.g., `BigFloat`) and packages.

Graphical additions that cater to a very small audience only may or may not be accepted.

### Documentation

When contributing code that adds new functionalities or modifies existing ones, you **must** provide the relevant new or amended documentation, correctly inserted into the existing one. 
