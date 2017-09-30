# Environment Builder
A flexible framework for automated environment building.

#### tl;dr
If you don't feel like reading and want to just dive in, copy the contents of the .minimal_example folder to wherever you want your scripts to run, and drop in some files/folders like the examples in the common and example folders. You can also copy the whole project somewhere and run build.sh to see how the system operates. Try running with different environments and command line options, and observe the results.

#### Flexible Config & Sequential Scripting
This script is an attempt to provide a flexible framework for automated environment building. The basic concept is to handle any arbitrary number of properties files with any arbitrary number of shell scripts, with a simple method of loading the properties files and firing the scripts in order.

#### Required Structure, Files, & Variables
The script requires the build.properties file, and build.properties must define a target environment. The script also requires a directory named "common," a directory named "ran_once." The .minimal_example folder demonstrates this bare minimum, which basically just sets the target_environment variable. Note that the target environment can be set to "common" to just run the common files. It's also rather easy to add config properties to suppress the running of common files, force reruns, etc. 

#### Flexible Naming Conventions

Note that your .properties files and your shell scripts can be named whatever you find most descriptive. The only rule is for numbering shell scripts for sequential processing, as described below. The load/run order methodology is also described below.

#### Flexible Configuration
On top of this required structure, you can put any number of arbitrarily named .properties files in the common folder, and create any number of arbitrarily named sibling directories to common. These directory names can then be used in the target_environment variable to load any number of arbitrarily named .properties files, which, if they define a variable already existing from a common properties file, will overwrite those properties.

Note that loading of .properties files is arbitrary, so be careful not to define variables differently in multiple files, or the final value will be arbitrary according to the system's ordering of your arbitrary filenames. The only rule with .properties files if that variables defined in environment properties files will override any settings set in the common properties files.

#### Flexible Sequential Shell Script Execution
The common folder, as well as any environment folders, can have any number of .sh files. These files can be named arbitrarily, but their file names must not contain any hyphens, except for a hyphen followed by a floating point number at the end, just before the .sh.

The .sh files are loaded in order of the floating point numbers following the hyphen in their names. This enables simple ordering of shell script execution, with the ability to step back and forth between common and environment steps, enabling as much code reuse as possible. The common and example folders have examples.

Note that floating point is used, not version notation. Only one decimal is expected. And ordering is thus infinitely arbitrarily variable. You can make a file run after some_file-1.567.sh by naming one this_file-1.568.sh. Also note that if an environment script has a number equal to one from an environment script, the environment script runs *after* the common script. It looks like you can even use negative numbers, as well, so jamming a small script into the process anytime down the line should be easy.

Also note that you can set a suppress_common property that will prevent *all* shell scripts from the common folder to be ignored.

#### Custom Command Line Options As Properties
You can specify any number of arbitrary command line options and/or arguments as simple properties in one of your properties files. See common/cmd.properties for some examples. You will also see, in that file, and example of how to make properties required to run the script. Additionally, of you define sommand line options, you'll need to specifiy a .command file in OPTION_HANDLER_FILE, see the cmd.properties example, which uses cmd.command as the command to parse our command line options into our chosen variables.

#### Run Once
The run once concept I'm using here isn't required and could easily be replaced by any other method, I made that directory required more to remind me how I decided to do it than anything else. Example in common/another_common_thing-2.sh
