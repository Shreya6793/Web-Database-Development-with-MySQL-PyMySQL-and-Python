-- Bare Bone DDL to create the SWIM DB of CSCI 4333

DROP SCHEMA IF EXISTS SWIM;
CREATE SCHEMA SWIM;
USE SWIM;

-- You may use the following DELETE TABLE
-- to ensure starting with a clean slate.
-- Note the DELETE TABLE is usually in the
-- reverse order of CREATE TABLE to ensure
-- no referential integrity violations.
DROP TABLE IF EXISTS Commitment;
DROP TABLE IF EXISTS V_Task;
DROP TABLE IF EXISTS V_TaskList;
DROP TABLE IF EXISTS Participation;
DROP TABLE IF EXISTS Event;
DROP TABLE IF EXISTS Meet;
DROP TABLE IF EXISTS LevelHistory;
DROP TABLE IF EXISTS OtherCaretaker;
DROP TABLE IF EXISTS Swimmer;
DROP TABLE IF EXISTS Venue;
DROP TABLE IF EXISTS Level;
DROP TABLE IF EXISTS Caretaker;
DROP TABLE IF EXISTS Coach;

-- Create tables
DROP TABLE IF EXISTS Coach;
CREATE TABLE Coach(
    CoachId      INT UNSIGNED AUTO_INCREMENT, 
    LName        VARCHAR(30) NOT NULL,
    FName        VARCHAR(30) NOT NULL,
    Phone        VARCHAR(12) NOT NULL,
    EMail        VARCHAR(60) NOT NULL,
    CONSTRAINT Coach_pk PRIMARY KEY(CoachId)
);

DROP TABLE IF EXISTS Caretaker;
CREATE TABLE Caretaker(
    CT_Id        INT UNSIGNED AUTO_INCREMENT, 
    LName        VARCHAR(30) NOT NULL,
    FName        VARCHAR(30) NOT NULL,
    Phone        VARCHAR(12) NOT NULL,
    EMail        VARCHAR(60) NOT NULL,
    CONSTRAINT Caretaker_pk PRIMARY KEY(CT_Id)
);

DROP TABLE IF EXISTS Level;
CREATE TABLE Level(
    LevelId      INT UNSIGNED, 
    -- ok to use smaller INT such as TINYINT
    Level        VARCHAR(30) NOT NULL,
    Description  VARCHAR(250),
    CONSTRAINT level_pk PRIMARY KEY(LevelId),
    CONSTRAINT level_ck_1 UNIQUE(Level)
);

DROP TABLE IF EXISTS Venue;
CREATE TABLE Venue(
    VenueId     INT UNSIGNED AUTO_INCREMENT, 
    -- ok to use smaller INT such as SMALLINT
    Name        VARCHAR(100) NOT NULL,
    Address     VARCHAR(100) NOT NULL,
    City        VARCHAR(50) NOT NULL,
    State       VARCHAR(15) NOT NULL,
    ZipCode     VARCHAR(10) NOT NULL,
    Phone       VARCHAR(12) NOT NULL,
    CONSTRAINT venue_pk PRIMARY KEY(VenueId),
    CONSTRAINT venue_ck_1 UNIQUE(Name)
);

DROP TABLE IF EXISTS Swimmer;
CREATE TABLE Swimmer(
    SwimmerId       INT UNSIGNED AUTO_INCREMENT, 
    LName           VARCHAR(30) NOT NULL,
    FName           VARCHAR(30) NOT NULL,
    Phone           VARCHAR(12) NOT NULL,
    EMail           VARCHAR(60) NOT NULL,
    JoinTime        DATE NOT NULL,
    CurrentLevelId  INT UNSIGNED NOT NULL,
    Main_CT_Id      INT UNSIGNED NOT NULL,
    Main_CT_Relationship VARCHAR(30) NOT NULL,
    Main_CT_Since   DATE NOT NULL,
    CONSTRAINT swimmer_pk PRIMARY KEY(SwimmerId),
    CONSTRAINT swimmer_level_fk FOREIGN KEY(CurrentLevelId) 
        REFERENCES Level(LevelId),
    CONSTRAINT swimmer_caretaker_fk FOREIGN KEY(Main_CT_Id) 
        REFERENCES Caretaker(CT_Id)
);

DROP TABLE IF EXISTS OtherCaretaker;
CREATE TABLE OtherCaretaker(
    OC_Id        INT UNSIGNED AUTO_INCREMENT, 
    SwimmerId    INT UNSIGNED NOT NULL,
    CT_Id        INT UNSIGNED NOT NULL,
    Relationship VARCHAR(30) NOT NULL,
    Since        DATE NOT NULL,
    CONSTRAINT othercaretaker_pk PRIMARY KEY(OC_Id),
    CONSTRAINT othercaretaker_swimmer_fk FOREIGN KEY(SwimmerId) 
        REFERENCES Swimmer(SwimmerId),
    CONSTRAINT othercaretaker_caretaker_fk FOREIGN KEY(CT_Id) 
        REFERENCES Caretaker(CT_Id)
);

DROP TABLE IF EXISTS LevelHistory;
CREATE TABLE LevelHistory(
    LH_Id        INT UNSIGNED AUTO_INCREMENT, 
    SwimmerId    INT UNSIGNED NOT NULL,
    LevelId      INT UNSIGNED NOT NULL,
    StartDate    DATE NOT NULL,
    Comment      VARCHAR(250),
    CONSTRAINT levelhistory_pk PRIMARY KEY(LH_Id),
    CONSTRAINT levelhistory_ck_1 UNIQUE(SwimmerId, LevelId),
    CONSTRAINT levelhistory_swimmer_fk FOREIGN KEY(SwimmerId) 
        REFERENCES Swimmer(SwimmerId),
    CONSTRAINT levelhistory_level_fk FOREIGN KEY(LevelId) 
        REFERENCES Level(LevelId)
);

DROP TABLE IF EXISTS Meet;
CREATE TABLE Meet(
    MeetId      INT UNSIGNED AUTO_INCREMENT, 
    Title       VARCHAR(100) NOT NULL,
    Date        DATE NOT NULL,
    StartTime   TIME NOT NULL,
    EndTime     TIME NOT NULL,
    VenueId     INT UNSIGNED NOT NULL,
    CoachId     INT UNSIGNED NOT NULL,
    CONSTRAINT meet_pk PRIMARY KEY(MeetId),
    CONSTRAINT meet_venue_fk FOREIGN KEY(VenueId) 
        REFERENCES Venue(VenueId),
    CONSTRAINT meet_coach_fk FOREIGN KEY(CoachId) 
        REFERENCES Coach(CoachId)
);

DROP TABLE IF EXISTS Event;
CREATE TABLE Event(
    EventId      INT UNSIGNED AUTO_INCREMENT, 
    Title        VARCHAR(100) NOT NULL,
    StartTime    TIME NOT NULL,
    EndTime      TIME NOT NULL,
    MeetId       INT UNSIGNED NOT NULL,
    LevelId      INT UNSIGNED NOT NULL,
    CONSTRAINT event_pk PRIMARY KEY(EventId),
    CONSTRAINT event_meet_fk FOREIGN KEY(MeetId) 
        REFERENCES Meet(MeetId),
    CONSTRAINT event_level_fk FOREIGN KEY(LevelId) 
        REFERENCES Level(LevelId)
);

DROP TABLE IF EXISTS Participation;
CREATE TABLE Participation(
    ParticipationId INT UNSIGNED AUTO_INCREMENT, 
    SwimmerId       INT UNSIGNED NOT NULL,
    EventId         INT UNSIGNED NOT NULL,
    Committed       BOOLEAN,
    CommitTime      DATETIME,
    Participated    BOOLEAN,
    Result          VARCHAR(100),
    Comment         VARCHAR(100),
    CommentCoachId  INT UNSIGNED,
    CONSTRAINT participation_pk PRIMARY KEY(ParticipationId),
    CONSTRAINT participation_ck_1 UNIQUE(SwimmerId, EventId),
    CONSTRAINT participation_swimmer_fk FOREIGN KEY(SwimmerId) 
        REFERENCES Swimmer(SwimmerId),
    CONSTRAINT participation_event_fk FOREIGN KEY(EventId) 
        REFERENCES Event(EventId),
    CONSTRAINT participation_coach_fk FOREIGN KEY(CommentCoachId) 
        REFERENCES Coach(CoachId)
);

DROP TABLE IF EXISTS V_TaskList;
CREATE TABLE V_TaskList(
    VTL_Id      INT UNSIGNED AUTO_INCREMENT, 
    MeetId      INT UNSIGNED NOT NULL,
    Required    BOOLEAN NOT NULL,
    Description VARCHAR(250) NOT NULL,
    Penalty     VARCHAR(100),
    PenaltyAmt  DECIMAL(6,2),
    CONSTRAINT v_tasklist_pk PRIMARY KEY(VTL_Id),
    CONSTRAINT v_tasklist_meet_fk FOREIGN KEY(MeetId) 
        REFERENCES Meet(MeetId)
);

DROP TABLE IF EXISTS V_Task;
CREATE TABLE V_Task(
    VT_Id       INT UNSIGNED AUTO_INCREMENT, 
    VTL_Id      INT UNSIGNED NOT NULL,
    Name        VARCHAR(100) NOT NULL,
    Comment     VARCHAR(250),
    Num_V       SMALLINT UNSIGNED DEFAULT 1,
    CONSTRAINT v_task_pk PRIMARY KEY(VT_Id),
    CONSTRAINT v_task_v_tasklist_fk FOREIGN KEY(VTL_Id) 
        REFERENCES V_TaskList(VTL_Id)
);

DROP TABLE IF EXISTS Commitment;
CREATE TABLE Commitment(
    CommitmentId    INT UNSIGNED AUTO_INCREMENT, 
    CT_Id           INT UNSIGNED NOT NULL,
    VT_Id           INT UNSIGNED NOT NULL,
    CommitTime      DATETIME NOT NULL,
    Rescinded       BOOLEAN,
    RescindTime     DATETIME,
    CarriedOut      BOOLEAN,
    Comment         VARCHAR(100),
    CommentCoachId  INT UNSIGNED,
    CONSTRAINT commitment_pk PRIMARY KEY(CommitmentId),
    CONSTRAINT commitment_ck_1 UNIQUE(CT_Id, VT_Id),
    CONSTRAINT commitment_caretaker_fk FOREIGN KEY(CT_Id) 
        REFERENCES Caretaker(CT_Id),
    CONSTRAINT commitment_v_task_fk FOREIGN KEY(VT_Id)
        REFERENCES V_Task(VT_Id),
    CONSTRAINT commitment_coach_fk FOREIGN KEY(CommentCoachId) 
        REFERENCES Coach(CoachId)
);

