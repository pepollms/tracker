---
title: Pre-Election Poll Monitoring System
subtitle: |
    | Operations Manual
    |
author:
  - name: Ricardo Maicle
    email: rmaicle@gmail.com
  - name: Dan Zambrano
    email: dan.kidtech@gmail.com
version: Version 0.3.0
date: January 2019
distribution: |
    | Private; distribution limited to company use only.
    |
xdistribution: |
    | For private use; distribution limited to executive level only.
    | This is an optional second line.
    | Approved for public release and unlimited distribution.
    |
xcopyright: Copyleft \textcopyright\space2017
licenseimage: cc_by_nc_sa_40.eps
license: CC BY-NC-SA 4.0
licensetext: This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License (CC BY-NC-SA 4.0). You are free to copy, reproduce, distribute, display, and make adaptations of this work for non-commercial purposes provided that you give appropriate credit. To view a copy of this license, visit [http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode](http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode).
licenselink: "http://creativecommons.org/licenses/by-nc-sa/4.0/](http://creativecommons.org/licenses/by-nc-sa/4.0/"
xsource: The source is available at [https://www.github.com/rmaicle/mdtopdf](https://www.github.com/rmaicle/mdtopdf).
---



# Introduction {#chapter-introduction}

The Pre-Election Poll Monitoring System keeps track of the number of voters who would prefer to vote for a candidate. The numbers are then compared to the voting population to determine the likelyhood of winning the election.



## System Overview {#chapter-software-system-overview}

The following diagram shows the overview of the system where external actors interact with the system and describes the operation performed.

!uml(images/pp-overview.svg {width=420})(System Overview UML Use Case Diagram)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
left to right direction
skinparam packageStyle rectangle
actor Leader
actor Maintainer
actor Monitor
rectangle "Pre-Election Poll Monitoring" {

    (Import Source Data) -- Maintainer
    (Set Precinct Target Values) -- Maintainer
    (Assign Precinct Leader) -- Maintainer
    (Update\nPoll Database) -- Maintainer
    Leader -- (Add In-Favor Message)
    (View\nPoll Status) -- Monitor
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



## System Requirements

The following lists the primary requirements of the system.

1. The system shall collate in-favor pre-election poll for the candidate.
2. The system shall monitor pre-election poll from the provincial level down to the precinct level.
3. The system shall drill down the pre-election poll from the provincial level down to the precinct level.
4. The system shall set a user defined target value for each precinct.
5. The system shall display the number and percentage of in-favor pre-election poll compared to the target value.
6. The system shall display the number and percentage of target value compared to the actual number of voters.
7. The system shall accept only registered or authorized personnel to provide updates on in-favor pre-election poll numbers for each precinct.
8. The system shall be viewable online.

\clearpage
