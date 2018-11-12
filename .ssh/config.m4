# Current identity file
IdentityFile ~/.ssh/keys/identity

# Allow local commands to run from ~C !command
PermitLocalCommand yes

# Keepalive the connection by sending a keepalive message every 5 minutes
# Timeout only if there's no response after 2 tries
ServerAliveInterval 300
ServerAliveCountMax 2

m4_ifelse(PH_SYSTEM, CYGWIN, ,
    # Allow sharing of already existing connections (only for non-Cygwin)
    ControlMaster auto
    ControlPath /tmp/ssh-control:%h:%p:%r
)

# Disable host authentication for localhost addresses
NoHostAuthenticationForLocalhost yes

Include hosts
