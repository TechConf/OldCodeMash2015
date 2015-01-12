# README #

This project was originally created for the demos and code used during a half day workshop entitled "A Lap Around the Cloud with Microsoft Azure" presented by Michael Collier and Mike Wood for [CodeMash 2015](http://www.codemash.org).

Talk abstract:
*It can be difficult to know how and where to get started with the Microsoft Azure platform due to the rapid pace of innovation. In this workshop you will learn about a range of commonly used services within Azure, as well as a battle tested insights into creating defensive architectures for the cloud. Come with a laptop ready to learn and complete a hands-on exercises that will walk you through building and deploying an application that leverages multiple Azure services. Leave the workshop with knowledge of various hosting options in Azure, experience in deploying a solution, and lessons in designing your solutions to protect against failure.*

### What to expect from the workshop ###
The workshop will focus on getting started with Microsoft Azure.  There will be an overview, then we will cover the different types of compute options in Azure, followed by a mixture of demonstrations and hands on labs.  We will work with Azure Virtual Machines, Azure Web Sites, Azure Document DB, traffic manager and more. 

### What is this repository for? ###

* For attendees of the workshop to be able to retrieve the code from the demonstrations and Hands on Labs.
* For people who are interested by did not attend to be able to see examples used in the workshop.
* See short examples of some specific aspects of working with Microsoft Azure.  

### What is this repository NOT for? ###

The examples here should **NOT** be blindly used for production purposes. As with almost all samples and examples which are trying to focus on a specific aspect being taught there can be other important aspects that are ignored or aren't covered in the name of clarity and brevity.  For example, the website does not include authentication or authorization, which means anyone can push data into the application data store.  It also doesn't perform data scrubbing or validation, all of which is a big security hole.  There are many sessions and resources on the Internet that cover these security concerns and we highly recommend you read up on those as well.


### Getting Started (Prerequisites) ###

Microsoft Azure has cross-platform\language SDKs and command line tools; however, this workshop focuses on using .NET for the examples. To prepare you machine for the workshop you'll want to have the following installed: 

**Azure PowerShell cmdlets**
 - Version used in workshop was 0.8.12.
 - Use either Web Platform Installer or Windows Standalone
- https://github.com/Azure/azure-powershell/releases   

**Azure SDK 2.5 (for Visual Studio 2013)**
- Obtain from http://azure.microsoft.com/en-us/downloads/ 

**Visual Studio 2013 Pro with Update 4 (or higher)** 
 - Download 90-day free trial from http://www.visualstudio.com/en-us/downloads/download-visual-studio-vs.aspx 
- Alternative: Visual Studio Community 2014 with Update 4 (http://www.visualstudio.com/en-us/downloads/download-visual-studio-vs.aspx)

**Azure Subscription**:
- Free Month Trial: sign up via http://azure.microsoft.com/en-us/pricing/free-trial/
OR
- MSDN Benefits: http://azure.microsoft.com/en-us/pricing/member-offers/msdn-benefits/ 
OR
- Use an existing subscription


*The above prerequisites are accurate as of Dec 29th, 2014.* 


### Who do I talk to? ###

The authors of this repo and workshop are [Michael Collier](https://twitter.com/MichaelCollier) or [Mike Wood](https://twitter.com/mikewo).  Reach out to us on twitter.

