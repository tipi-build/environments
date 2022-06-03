$source = "C:\.tipi"
$dest =  "D:\.tipi"

# copy everything
# ---------------

# NOTE: this was terribly slow, taking a good 5minutes to "sync". Replaced with...
# Copy-Item -Path $source -Destination $dest -Recurse

# ... some ROBOCOPY goodness
#
# Details:
# /S: Copies subdirectories  
# /E: includes empty directories.
# /Z: Copies files in restartable mode
# /ZB: Copies files in restartable mode. If file access is denied, switches to backup mode.
# /R:5: retries on failed copies (instead of 1MIO)
# /W:5: wait (in seconds) between retries
# /NP: hides progress display
# /MT:128: thread count for copies. Scales fairly well => higher is seemingly better (defaults to 8)
# /log:*PATH* : redirects the output to a log file (huge perf gain here...)
Robocopy /S /E /Z /ZB /R:5 /W:5 /NP /MT:128 /log:c:\temp\distro-copy.log $source $dest

# make sure everyone can read/write *stuff*
# -----------------------------------------
icacls $dest /grant Users:F