# Introduction {#chapter-introduction}

The Pre-Election Poll Monitoring System keeps track of the number of voters who would prefer to vote for a candidate. The numbers are then compared to the voting population to determine the likelyhood of winning the election.

To support keeping track of performance milestone or achievment, the system also monitors a target count of voters who would prefer to vote for a candidate. The voter and target counts are monitored per precinct, the smallest voting jurisdiction in the Philippines.



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

The following is the list of primary requirements of the system.

1. The system shall keep track of the number of voters in favor of a candidate.
2. The system shall maintain, per precinct, the target number of voters in favor of a candidate.
3. The system shall keep track of people is in charge of each precinct in monitoring the number of voters in favor of a candidate;
4. The system shall compute the percentages of voters in favor in relation to the target number of voeters in favor of a candidate.
5. The system shall compute the percentage of target number of voters in relation to the total number of voters in every precinct.
6. The system shall display the number of voters in favor, target number of voters, total number of voters and their correspdoning percentages.
7. The system shall be able to display the current values from the provincial level down to the precinct level.
8. The system shall display the monitoring status online.

The following is the list of supporting requirements of the system.

1. The system shall be able to change the precinct assignment of people in charge of monitoring the number of voters.
2. The system shall be able to update the target number of voters per precinct.
3. The system shall be able to update the information of people in charge of each precinct.
4. The system shall be able to manually override the number of voters in favor of a candidate.

\clearpage
