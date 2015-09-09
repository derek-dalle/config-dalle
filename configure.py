#!/usr/bin/env python
"""
Global System Settings Module
=============================

This function stores as many of my preferred settings as practicable.

:Call:
    
    .. code-block:: bash
    
        $ configure [OPTIONS]
        
:Options:
    
    -h, --help
        Display this help message and exit
        
    -root
        Run with root privileges
        
    -scripts
        Update run scripts
        
    -scriptdir $BIN
        Use script directory *BIN* instead of ``$HOME/bin``
        
    -settings
        Synchronize settings and dotfiles
        
    -matlab
        Update Matlab settings in ``~/Documents/MATLAB``
        
    -jedit
        Update jEdit settings
        
    -keyboards
        Update keyboard files
        
    -packages
        Install missing packages
        
    -package_list $F
        Use package list *F* instead of default

:Versions:
    * 2013-07-06 ``@ddalle``: First version
    * 2013-07-26 ``@ddalle``: Improved to take optional inputs
    * 2015-09-07 ``@ddalle``: Started conversion to Python (from BASH)
"""

# System modules
import os, sys, shutil
import subprocess as sp



# Update settings
opts = {
    "root": False,
    "packages": False,
    "settings": False,
    "dropbox": False,
    "local": False,
    "scripts": False,
    "keyboards": False,
    "jedit": False,
    "matlab": False,
    "f_packages": "ubuntu/packages.list",
    "scriptdir": "bin"
}

# Get inputs
def ProcessInputs():
    """Process the command-line inputs from :code:`sys.argv`
    
    :Call:
        >>> a, kw = ProcessInputs()
    :Inputs:
        *a*: :class:`list` (:class:`str`)
            List of non-keyword inputs
        *kw*: :class:`dict`
            Dictionary of keyword inputs
    :Versions:
        * 2015-09-07 ``@ddalle``: First versoin
    """
    # Initialize outputs
    a = []
    kw = {}
    # Extract direct command-line call
    argv = sys.argv
    # Number of inputs
    argc = len(sys.argv)
    iarg = 1
    # Loop through inputs.
    for i in range(argc):
        # Check if last input reached.
        if iarg >= argc: break
        # Read the input.
        o = argv[iarg]
        # Check for hyphens.
        if not o.startswith('-'):
            # General input
            a.append(o)
            # Go to next input.
            iarg += 1
        else:
            # Key name starts after '-'s
            k = o.lstrip('-')
            # Increase the argument count.
            iarg += 1
            # Check for key value.
            if iarg >= argc:
                # No option value; last argument reached
                kw[k] = True
            else:
                # Read the next argument.
                v = argv[iarg]
                # Check if it's another option.
                if v.startswith('-'):
                    # No option value; next argument is another key
                    kw[k] = True
                else:
                    # Store the key and value.
                    kw[k] = v
                    # Go to next argument.
                    iarg += 1
    # Output
    return a, kw
    
# Process the input keys
def CheckInputs(*a, **kw):
    """Check the command-line inputs and apply them to internal options
    
    :Call:
        >>> CheckInputs(*a, **kw)
    :Inputs:
        *a*: :class:`list` (:class:`str`)
            List of non-keyword inputs
        *kw*: :class:`dict`
            Dictionary of keyword inputs
    :Versions:
        * 2015-09-07 ``@ddalle``: First version
    """
    # Check for anything in *a*
    if len(a) > 0:
        UnknownOption(a[0])
        sys.exit()
    # Loop through inputs.
    for k in kw:
        # Check the inputs
        if k in ['settings', 'dotfiles']:
            opts['settings'] = kw[k]
        elif k in ['scripts']:
            opts['scripts'] = kw[k]
        elif k in ['jedit']:
            opts['jedit'] = kw[k]
        elif k in ['matlab']:
            opts['matlab'] = kw[k]
        elif k in ['root', 'sudo']:
            opts['root'] = kw[k]
        elif k in ['packages']:
            opts['packages'] = kw[k]
        elif k in ['keyboards']:
            opts['keyboards'] = kw[k]
        else:
            UnknownOption(k)
            sys.exit()
            
# Print the input settings
def PrintSettings():
    """Print the processed input settings
    
    :Call:
        >>> PrintSettings()
    :Versions:
        * 2015-09-07 ``@ddalle``: First version
    """
    print("Settings:")
    print("  %27s: %s" % ('Root privileges', opts['root']))
    print("  %27s: %s" % ('Install packages', opts['packages']))
    print("  %27s: %s" % ('Update scripts', opts['scripts']))
    print("  %27s: %s" % ('Update dotfiles', opts['settings']))
    print(" ")
    print("Specific programs:")
    print("  %27s: %s" % ('jEdit', opts['jedit']))
    print("  %27s: %s" % ('MATLAB', opts['matlab']))
    print(" ")
    
    
# Unknown option
def UnkownOption(k):
    """Display unknown option warning
    
    :Call:
        >>> UnkownOption(k)
    :Inputs:
        *k*: :class:`str`
            Name of unknown option
    :Versions:
        * 2015-09-07 ``@ddalle``: First version
    """
    print(" ")
    print(" Unknown input option '%s'" % k)
    print(" Run `%s -help` for valid options." % sys.argv[0])
    
# Update file
def UpdateFile(fsrc, fdst, sudo=False):
    """Update a file if the repository file is newer
    
    :Call:
        >>> UpdateFile(fsrc, fdst, sudo=False)
    :Inputs:
        *fsrc*: :class:`str`
            Source file
        *fdst*: :class:`str`
            Destination file
        *sudo*: :class:`bool`
            Whether or not root is needed
    :Versions:
        * 2015-09-07 ``@ddalle``: First version
    """
    # Status update.
    print("  %s --> %s" % (fsrc, fdst))
    # Check if source file exists.
    if not os.path.isfile(fsrc):
        print("  File '%s' does not exist." % fsrc)
        return
    # Check if destination file already exists.
    if os.path.isfile(fdst):
        # Get the modification dates.
        tsrc = os.path.getmtime(fsrc)
        tdst = os.path.getmtime(fdst)
        # Check for newer destination.
        if tdst > tsrc:
            print("    Working version is newer; aborting.")
            return
    # Copy the file.
    if sudo and opts.get('root'):
        # Sudo copy
        print("    Updating with root privileges")
        sp.call(['sudo', 'cp', fsrc, fdst])
    elif sudo:
        # No permissions
        print("    Cannot update without root privileges")
    else:
        # Status update
        print("    Updating")
        # Normal copy
        shutil.copy(fsrc, fdst)
        
# Update folder recursively.
def UpdateDir(fdir, fdst, sudo=False):
    # Save location
    fpwd = os.getcwd()
    # Enter the folder.
    os.chdir(fdir)
    # Loop through contents of folder
    for f in os.listdir('.'):
        # Destination file
        fdsti = os.path.join(fdst, f)
        # Check type.
        if os.path.isdir(f):
            # Make destination if necessary.
            if not os.path.isdir(fdsti):
                os.mkdir(fdsti)
            # Recurse
            UpdateDir(f, fdsti, sudo=sudo)
        # Update the file
        UpdateFile(f, fdsti, sudo=sudo)
    # Go back home.
    os.chdir(fpwd)
    
# Update scripts
def UpdateScripts():
    """Update run scripts
    
    :Call:
        >>> UpdateScripts()
    :Versions:
        * 2015-09-07 ``@ddalle``: First version
    """
    # Check settings.
    if not opts['scripts']: return
    # Get scriptdir
    fscript = opts.get('scriptdir', 'bin')
    # Turn into absolute path.
    fbin = os.path.join(os.environ['HOME'], fscript)
    # Change to the bin folder.
    os.chdir('bin')
    # Loop through contents of library
    for f in os.listdir('.'):
        # Process the file before copying it?
        
        # Copy the file.
        UpdateFile(f, os.path.join(fbin, f))
    # Go back up
    os.chdir('..')
    # Extra line
    print(" ")
        
# Update dot files
def UpdateDotFiles():
    """Update dot files such as ``~/.bashrc``
    
    :Call:
        >>> UpdateDotFiles()
    :Versions:
        * 2015-09-07 ``@ddalle``: First version
    """
    # Check command-line option.
    if not opts['settings']: return
    # Home directory
    fhome = os.environ['HOME']
    # Copy files individually.
    UpdateFile('bash/.bashrc', os.path.join(fhome, '.bashrc'))
    UpdateFile('vim/.vimrc',   os.path.join(fhome, '.vimrc'))
    # Extra line
    print(" ")
    
# Update MATLAB files
def UpdateMatlab():
    # Check command-line options
    if not opts['matlab']: return
    # Status update
    print("Synchronizing MATLAB settings.")
    # Home directory
    fhome = os.environ['HOME']
    # Destination folder
    fdir = os.path.join(fhome, 'Documents', 'MATLAB')
    # Make folders if necessary
    if not os.path.isdir(fdir): os.mkdir(fdir)
    # Update the Octave settings.
    UpdateFile('octave/.octaverc', os.path.join(fhome, '.octaverc'))
    # Update contents of entire folder
    UpdateDir('MATLAB', fdir)
    print(" ")
    
# Update jEdit
def UpdateJedit():
    # Check command-line options.
    if not opts['jedit']: return
    # Status update
    print("Synchronizing jEdit settings.")
    # Home directory
    fhome = os.environ['HOME']
    # Child directories
    fjedit = os.path.join(fhome, '.jedit')
    fmodes = os.path.join(fjedit, 'modes')
    fkeys  = os.path.join(fjedit, 'keymaps')
    fjars  = os.path.join(fjedit, 'jars')
    # Local locations
    f0 = os.path.join('jedit', '.jedit')
    f1 = os.path.join('jedit', '.jedit', 'properties')
    f2 = os.path.join('jedit', 'properties')
    # Copy the main config file to a temp location.
    shutil.copyfile(f1, f2)
    # Long form of the destination directory.
    fh2 = fhome.replace('/', '\/')
    # Command to set the correct HOME directory.
    cmd = ['sed', '-i', "s/\$HOME/%s/g"%fh2, f2]
    # Update it.
    sp.call(cmd)
    # Update the file if appropriate.
    UpdateFile(fh2, os.path.join(fjedit, 'properties'))
    # Update the folders.
    UpdateDir(os.path.join(f0,'modes'),   fmodes)
    UpdateDir(os.path.join(f0,'keymaps'), fkeys)
    UpdateDir(os.path.join(f0,'jars'),    fjars)
    # Cleanup
    os.remove(fh2)
    print(" ")
            
    
    
    
    
# Main function
def main(*a, **kw):
    """Primary global configuration script
    
    :Call:
        >>> main(*a, **kw)
    :Versions:
        * 2015-09-07 ``@ddalle``: First version
    """
    # Check for no inputs
    if kw == {}:
        print(" Running without options.")
        print(" To show options run '%s -help'." % sys.argv[0])
        print("")
    # Check the inputs.
    CheckInputs(*a, **kw)
    # Display the settings
    PrintSettings()
    
    # Update scripts
    UpdateScripts()
    
    # Update programs
    UpdateMatlab()
    UpdateJedit()
    
        
        
# Check for script
if __name__ == "__main__":
    # Process inputs
    a, kw = ProcessInputs()
    # Print the opening message.
    print(" ")
    print("* Global configuration script *")
    print("Invoked with: ")
    print(" ")
    print("  %s" % " ".join(sys.argv))
    print(" ")
    # Check for help input.
    if kw.get('h') or kw.get('help'):
        print(__doc__)
        sys.exit()
    # Run the main function.
    main(*a, **kw)
    
