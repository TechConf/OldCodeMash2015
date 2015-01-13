These shell scripts can be modified for your environment.

It is recommended that you set the JAVA_HOME environment variable before executing
one of these scripts; this will ensure that the correct java executable is used.

If running on Windows a registy file is provided to perform the following performance
optimizations:

- Coherence requires system performance be optimized for background services.
  See this link http://support.microsoft.com/default.aspx?scid=kb;en-us;308186&sd=tech#4

- Coherence uses a packet size based on the standard 1500 byte MTU.  Windows includes
  a fast I/O path for "small" packets, where small is defined as 1024 bytes.
  Increasing this limit to match the MTU can significantly improve network performance.
  See this link http://www.microsoft.com/technet/itsolutions/network/deploy/depovg/tcpip2k.mspx
  for references to FastSendDatagramThreshold.

To make these changes to your registry, run the included "optimize.reg" registry file.