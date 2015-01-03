#!/bin/sh
#
# Additional commands to support node manager ip migration.
#
# Prints out list of available network interfaces and associated ip addresses.
# And for HP-UX, it prints out the last used network interface and 
# associated ip addresse.
#
listif()
{
    case "$OS" in
    Linux\ 2.*)
/sbin/ip -o addr show "$INTERFACE" |
      # ip prints out a number followed by a colon [0-9]*:
      # then the main interface name, "lo" in the example below
      # then some whitespace followed by "inet" or "inet6"
      # then the address we are interested in, followed by scopes and other information we are not interested in
      # finally followed by the interface and subinterface

      #example:
      #1: lo    inet 127.0.0.1/8 scope host lo
      #1: lo    inet6 ::1/128 scope host \       valid_lft forever preferred_lft forever
     
      # first match addresses and sub interfaces for ipv4 format
      # 0-9. 
      sed -n 's?.*inet \([0-9.]*\)\/[0-9]* .* \([^ ]*\)?\2 \1?p'

      # now match addresses and interfaces for ipv6 format
      # a-zA-z0-9:
      /sbin/ip -o addr show "$INTERFACE" |
      sed -n 's?[0-9]*: \(.*[a-zA-Z0-9]*\)\ .*inet6 \([a-zA-Z0-9:]*\)\/[0-9]* .* \([^ ]*\)?\1 \2?p'
        ;;
    Darwin*)
        typeset addr
        for i in `/sbin/ifconfig -l`
        do
            addr=`/usr/sbin/ipconfig $i 2>$NullDevice` && echo "$i $addr"
        done
        ;;
    HP-UX*)
	$NETSTAT | grep $INTERFACE | ${AWK:-awk} '{print $1}' > $tempfile1
        for i in `cat $tempfile1`
        do
            echo "$i" | ${AWK:-awk} -F":" '{print $2}' >> $tempfile2
        done
        sort -r $tempfile2 > $tempfile1
        maxInterface=`head -1 $tempfile1`
        if [ x$maxInterface = x ]; then
            maxInterface=0
            LAST_UP_INTERFACE=$INTERFACE
        else
            LAST_UP_INTERFACE="$INTERFACE:$maxInterface"
        fi

        $NETSTAT | grep $LAST_UP_INTERFACE | ${AWK:-awk} '{print $1": "$4}' | uniq
        ;;
    SunOS*)
	$IFCONFIG $IFCONFIGOPTS | ${AWK:-awk} -v this_if=$INTERFACE 'BEGIN {
              if_pat = "^" this_if ".*"
            }
            {
              if ($0 ~ if_pat) {
                 cur_if=$1
                 getline
                 if ($1 ~ "inet") {
                    sub(/addr:/,"",$2);
                    sub(/\/.*?/,"",$2);
                    print cur_if " " $2
                 }
              }
            }'
	;;
	AIX*)
	$NETSTAT | grep $INTERFACE | ${AWK:-awk} '{print $1": "$4}' | uniq
	;;
    *)  echo "Server migration not supported on this platform" >&2
        exit 1
        ;;
    esac
}

#
# Prints out list of available network interfaces and associated ip addresses
# on windows 2000 or later systems.
#

listif_nt()
{
   netsh interface ip show address "$INTERFACE" | grep -e '[^ 	]*IP' >&2
}

#
# Removes an added floating IP address.  It depends on the OS utilities to
# achieve this.  
#  

removeif()
{
    $GREP -q $ADDRESS $AddrFile 
    if [ $? != 0 ]; then
       echo "Cannot remove $ADDRESS -  not brought online" >&2 
       exit 1
    fi
    
    if echo $OS | grep  '^HP-UX' >$NullDevice 2>&1; then
        # Extract the interface to which ADDRESS is assigned.
        if_toberemoved=`$NETSTAT | grep $ADDRESS  | ${AWK:-awk} '{print $1}'`
        # Now check if this extracted interface is a sub-interface of incoming INTERFACE
        # or itself. If not, raise error and exit.
        echo $if_toberemoved | grep $INTERFACE >$NullDevice 2>&1
        if [ $? != 0 -o -z $if_toberemoved -o x$if_toberemoved = x]; then
            echo "Cannot remove $ADDRESS - It is not online at '$INTERFACE' or any of its sub-interfaces" >&2
            exit 1
        fi
        echo "Executing command - '$SUDO $IFCONFIG $if_toberemoved down' AND '$SUDO $IFCONFIG $if_toberemoved 0.0.0.0'"
        $SUDO $IFCONFIG $INET6 $if_toberemoved down
        $SUDO $IFCONFIG $INET6 $if_toberemoved 0.0.0.0
    elif
	echo $OS | grep  '^AIX*' >$NullDevice 2>&1; then
        $SUDO $IFCONFIG $INTERFACE $INET6 $ADDRESS delete	
    elif
        echo $OS | grep  '^SunOS 5.' >$NullDevice 2>&1; then
	    if_toberemoved=$INTERFACE
            $SUDO $IFCONFIG $INTERFACE $INET6 removeif $ADDRESS
    elif [ "x$INET6" = "xinet6" ]; then
          if_toberemoved=$INTERFACE
          echo "Executing command - '$SUDO $IFCONFIG $INTERFACE $INET6 del $ADDRESS_AND_MASK"
          $SUDO $IFCONFIG $INTERFACE $INET6 del $ADDRESS_AND_MASK 
    else
	set -- `listif | grep "^$INTERFACE:.* $ADDRESS$"`
	if_toberemoved=$1

	if [ -n "$if_toberemoved" ]; then
	    $SUDO $IFCONFIG $1 down
	else
	    echo "Cannot remove $ADDRESS - It is not online at '$INTERFACE' or any of its sub-interfaces" >&2
	    exit 1
	fi
    fi

    case "$?" in
    0)    echo "Successfully removed $ADDRESS_AND_MASK from $if_toberemoved."
          ;;
    *)    echo "Failed to remove $ADDRESS_AND_MASK from $if_toberemoved." >&2
          exit 1
          ;;
    esac

    cleanAddressFile
}

#
# Checks if an address is in the Address file, and if it is
# it deletes that from the file
#  

cleanAddressFile()
{
    if [ -f $AddrFile ]; then    
        if $GREP -q $ADDRESS $AddrFile; then
            echo `sed '/'$ADDRESS'/ d' < $AddrFile` > $AddrFile
        fi

        if $GREP -q $ADDRESS $AddrFile; then
            echo "remove by sed FAILED!  $AddrFile still contains %ADDRESS%"
            exit 1
        fi
    fi

}



#
# Removes an added floating IP address.  It depends on the OS utilities to
# achieve this.  Windows 2000+ support
#  

removeif_nt()
{
    $GREP -q $ADDRESS $AddrFile 
    if [ $? != 0 ]; then
       echo "Cannot remove $ADDRESS -  not brought online" >&2 
       exit 1
    fi

    netout=`netsh interface ip delete address "$INTERFACE" $addr >&2`

    if [ $? != 0 ]; then
       echo "Unable to remove $ADDRESS - Check command output" >&2
       echo "$netout" >&2
       exit 1
    fi
    cleanAddressFile
}

#
# Adds a new IP in a subinterface of given interface.  If the IP is already
# online on this  machine, then if ENABLESCRIPTIPCHECK is set, then this will
# report failure. 
#  Invalid Interface or other configuration issues (like netmasks etc) will
#  cause this function to fail
# 

addif()
{
    # Allow awk to be set to nawk for some systems which still
    # ship the ancient version of awk
    newif=`listif | ${AWK:-awk}  -v this_if="$INTERFACE" -v this_ip=$ADDRESS 'BEGIN {
          cnt = 0;
          if_pat = "^" this_if ".*$"
          found=0
          if_matched=0
          new_if=""
        }
        {
          if ($1 ~ if_pat && !found) {
            if_matched = 1
            if ($2 == this_ip) {
              new_if = $1
              found=1
              n = split( $1,x,/:/)
              baseif = n == 1 ? 1 : 0;
            }
            else {
              n = split( $1,x,/:/)
              if (x[2] > cnt) {
                cnt = n == 1 ? 0 : x[2]
              }
            }
          }
        }
        END {
          if (!if_matched)
             new_if = "unknown-if"
          else if (!found)
             new_if = this_if ":" cnt + 1
          else {
             if (baseif) 
               new_if = "already-online-on-baseif"
             else
               new_if = "already-online"
          }
          print new_if
        }'`
    if [ "x$newif" = "xunknown-if" ]; then
        echo "Unknown interface $INTERFACE" >&2
        exit 1
    elif [ "x$newif" != "xalready-online" -a "x$newif" != "xalready-online-on-baseif" ]; then
        cleanAddressFile
        if echo $OS | grep  '^HP-UX' >$NullDevice 2>&1; then
	    echo "Generated command - $SUDO $IFCONFIG $newif $INET6 $ADDRESS_AND_MASK up"
            $SUDO $IFCONFIG $newif $INET6 $ADDRESS_AND_MASK up
	elif echo $OS | grep  '^AIX*' >$NullDevice 2>&1; then
	   echo "$OS" 
            echo "Generated command - $SUDO $IFCONFIG $INTERFACE $INET6 $ADDRESS_AND_MASK up alias"
            $SUDO $IFCONFIG $INTERFACE $INET6 $ADDRESS_AND_MASK up alias
    elif echo $OS | grep  '^SunOS 5.' >$NullDevice 2>&1; then
            echo "Generated command - $SUDO $IFCONFIG $INTERFACE $INET6 addif $ADDRESS_AND_MASK up"
            $SUDO $IFCONFIG $INTERFACE $INET6 addif $ADDRESS_AND_MASK up
    elif [ "x$INET6" = "xinet6" ]; then
        echo "Generated command - $SUDO $IFCONFIG $INTERFACE $INET6 add $ADDRESS_AND_MASK"
        $SUDO $IFCONFIG $INTERFACE $INET6 add $ADDRESS_AND_MASK
        else 
                echo "Generated command - $SUDO $IFCONFIG $newif $ADDRESS_AND_MASK"
                $SUDO $IFCONFIG $newif $ADDRESS_AND_MASK
   
        fi

        if [ $? = 0 ] ; then
            cleanAddressFile
            echo $ADDRESS >> $AddrFile
            if echo $OS | grep  '^Linux' >$NullDevice 2>&1; then

               $SUDO /sbin/arping $MACBROADCAST -q -c 3 -A -I $INTERFACE $ADDRESS > $NullDevice 2>&1
              
              # That should be enough, but if there are hosts out there which ignore
              # gratuitous ARP replies and do not even purge the ARP cache
              # try to send some gratuitous ARP requests
              #

               $SUDO /sbin/arping -q -c 3 -U -I $INTERFACE $ADDRESS > $NullDevice 2>&1
            
            fi
	    echo "Successfully brought $ADDRESS_AND_MASK online on $newif"
        else
            echo "Failed to bring $ADDRESS_AND_MASK online on $newif" >&2
            exit 1
        fi
    else
        if [ x$newif = xalready-online-on-baseif ]; then
          echo "$ADDRESS already online on $INTERFACE, but on the base interface.  This can lead of network connectivity when the interface is brought down" >&2
          exit 1
        fi
        if [ x$ENABLESTRICTIPCHECK = xY ]; then
          echo "$ADDRESS already online on $INTERFACE.  Please make sure that the IP address $ADDRESS is not used by other servers/applications" >&2
          cleanAddressFile
          exit 1
        else
          echo "$ADDRESS already online on $INTERFACE.  Please make sure that the IP address specified is not used by other servers/applications.  Continuing..." >&2
          cleanAddressFile
          echo $ADDRESS >> $AddrFile
        fi
    fi
}

#
# IP add function for Windows 2000+ systems.  Depends on netsh utlities and
# cygwin
#

addif_nt()
{
    newif=`listif_nt 2>&1 | ${AWK:-awk}  -v this_if="$INTERFACE" -v this_ip=$ADDRESS 'BEGIN {
          if_pat = "^Configuration for interface.*" this_if ".*$"
          ip_pat = "^IP Address:.*" $ADDRESS ".*$"
          found=0
          if_matched=0
        }
        {
          # print "Current line ", $0
          if ($0 ~ if_pat) {
            # print "if_matched"
            if_matched = 1
          }
          if (if_matched && ($0 ~ ip_pat)) {
             # print "ip_matched"
              found=1
          }
        }
        END {
          if (!if_matched)
             new_if = "unknown-if"
          else if (!found)
             new_if = this_if
          else
             new_if = "already-online"
          print new_if
        }'`
    if [ "x$newif" = "xunknown-if" ]; then
        cleanAddressFile
        echo "Unknown interface \"$INTERFACE\"" >&2
        exit 1
    elif [ "x$newif" != "xalready-online" ]; then
        cleanAddressFile
        netout=`netsh interface ip add address "$INTERFACE" $ADDRESS $NETMASK >&2`
        if [ $? = 0 ] ; then
            cleanAddressFile
            echo $ADDRESS >> $AddrFile
            
        else
            echo "Failed to bring $ADDRESS_AND_MASK online on $newif" >&2
            echo "$netout" >&2
            cleanAddressFile
            exit 1
        fi
    else
        if [ x$ENABLESTRICTIPCHECK = xY ]; then
          echo "$ADDRESS already online on $INTERFACE.  Please make sure that the IP address $ADDRESS is not used by other servers/applications" >&2
          cleanAddressFile
        else
          echo "$ADDRESS already online on $INTERFACE.  Please make sure that the IP address specified is not used by other servers/applications.  Continuing..." 
          cleanAddressFile 
          echo $ADDRESS >> $AddrFile
        fi
        exit 1
    fi
}

# Check whether parameter IP address is ipv6. Return 0:IPv6; 1:not
# $1: the ip address to check
isIPv6(){
    local ipAddress="$1"
    case "$ipAddress" in
    *::*)
        return 0
       ;;
    esac

    theCounter=`echo "$ipAddress" | ${AWK:-awk} -F":" '{print NF-1}'`
    if [ $theCounter -gt 3 ]; then
        return 0
    else
        return 1
    fi
}

# detect whether ADDRESS is ipv6, and set INET6 accordingly
detect_IPV6(){
    if ( isIPv6 $ADDRESS ); then
        export INET6="inet6"
    fi
}


usage_error()
{
cat <<!!EOF >&2
Usage: `basename $0` 
       -addif <interface-name> <ip-address> [netmask|prefixlength] 
       -removeif <interface-name> <ip-address> [prefixlength]
       -listif <interface-name>

      'addif' adds <ip-address> to next available sub-interface of <interface-name>.
      'removeif' removes <ip-address> from sub-interface of <interface-name>.
      'listif' lists last used sub-interface of <interface-name> and its corresponding <ip-address>
        for HP-UX platform AND it lists <interface-name> and its corresponding <ip-address> for other platforms.

      To find the list of interfaces, use your OS utility.  On Unix-like
      systems, '/sbin/ifconfig' or '/usr/sbin/ifconfig' will list all the interfaces.
      
      On Windows 2000 or later systems, use the following command to list the interface names-
      netsh interface show interface.
!!EOF
exit 1
}

#set -vx

# Parse interface name
[ $# -lt 1 ] && usage_error

# Parse command and options
INTERFACE= ADDRESS=  NETMASK=

case "$1" in
    -addif)     COMMAND=addif
                INTERFACE="$2"
                ADDRESS="$3"
                [ -n "$4" ] && NETMASK="$4" && PREFIXLENGTH="$4"
                [ -z "$INTERFACE" -o -z "$ADDRESS" ] && usage_error
		case "$OS" in
		    Linux\ 2.*)
		    if [ x$NETMASK = x ]; then
			usage_error; fi
		    ;;
		esac
                ;;
    -removeif)  COMMAND=removeif
                INTERFACE="$2"
                ADDRESS="$3"
                [ -n "$4" ] && PREFIXLENGTH="$4"
                [ -z "$INTERFACE" -o -z "$ADDRESS" ] && usage_error
                ;;
    -listif)    COMMAND=listif
                INTERFACE="$2"
                [ -z "$INTERFACE" ] && usage_error
                ;;
    -test)      return  # internal usage only
                ;;
    *)          usage_error
                ;;
esac

IFCONFIG=/sbin/ifconfig
IFCONFIGOPTS=-a
NullDevice=/dev/null
export NullDevice
LAST_UP_INTERFACE=
NETSTAT="/usr/bin/netstat -ain"
if [ "$UseMACBroadcast" = "true" ]; then
    MACBROADCAST="-b"
fi

# Set this to true if IP address should not be online before starting
# a server.  Otherwise, presence of an IP address in an interface will
# cause the script to report success on IP addif
ENABLESTRICTIPCHECK=N

# If ${ServerDir}/data/nodemanager directory does not exist, create it.
if [ ! -d ${ServerDir}/data/nodemanager ]
then
    mkdir -p ${ServerDir}/data/nodemanager
fi

AddrFile=${ServerDir}/data/nodemanager/${ServerName}.addr
tempfile1=${ServerDir}/data/nodemanager/wlsifconfig_temp1
tempfile2=${ServerDir}/data/nodemanager/wlsifconfig_temp2
rm $tempfile1 $tempfile2 >$NullDevice 2>&1

# Must have specified at least one command
[ -z "$COMMAND" ] && usage_error

OS="`uname -sr`"

cygwin=no


case $OS in

 *CYGWIN_NT*)
          NullDevice=nul
          cygwin=yes;;   # Currently only cygwin sshd tested on NT

  HP-UX*) IFCONFIG=/usr/sbin/ifconfig
          IFCONFIGOPTS=$INTERFACE
          ;;
  AIX*)
		  IFCONFIG=/usr/sbin/ifconfig
          IFCONFIGOPTS=$INTERFACE
          ;;
esac

case "$OS" in
SunOS*)
   GREP=/usr/xpg4/bin/grep
   ;;
*)
   GREP=grep
   ;;
esac

nawk '{ print }' < $NullDevice > $NullDevice 2>&1

if [ $? = 0 ]; then
  AWK=nawk
else
  AWK=awk
fi

if [ x$cygwin = xno ]; then
  myid=`id | sed  -e 's;^.*uid=\([0-9][0-9]*\).*$;\1;'`

  SUDO=sudo
  if [ $myid -eq 0 ]; then
    SUDO=
  fi
else
  SUDO=
  COMMAND="${COMMAND}_nt"
fi

detect_IPV6

NETMASK="netmask $NETMASK"
if [ "$INET6" = "inet6" ]; then
    if [ -z "$PREFIXLENGTH" ]; then
        ADDRESS_AND_MASK="$ADDRESS"
    else
ADDRESS_AND_MASK="$ADDRESS/$PREFIXLENGTH"
    fi
else
    ADDRESS_AND_MASK="$ADDRESS $NETMASK"
fi


$COMMAND
exit 0

