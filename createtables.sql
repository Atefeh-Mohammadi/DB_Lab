create database KARGAH
use [KARGAH]
CREATE TABLE [USER] (
    ID BIGINT IDENTITY(1,1) PRIMARY KEY, 
    NAME NVARCHAR(255) NOT NULL,
    FAMILY NVARCHAR(255) NOT NULL,
    AGE INT NULL,
    SEX BIT NULL,
    isActive BIT DEFAULT 0,  
    BIRTHDATE DATETIME NULL,
    USERNAME VARCHAR (255) NOT NULL,
    PASSWORD nvarchar(128) NOT NULL,
    CREATEDAT DATETIME not null,
    CONSTRAINT PK_USER PRIMARY KEY (ID),
    CONSTRAINT CHK_USER_AGE CHECK (AGE >= 14)
);



create table Question(
	q_id bigint IDENTITY(1,1) PRIMARY KEY,
	ID BIGINT,
	[text] nvarchar(max),
	goodness integer default 0,
	answers_number integer default 0,
	views integer default 0, 
	[date] date,
	is_spam integer default 0 ,
	keyword nvarchar(max),
	visible bit default 1,
	FOREIGN KEY (ID) REFERENCES [USER]
);


create table Answer(
	a_id bigint IDENTITY(1,1) PRIMARY KEY,
	q_id bigint,
	ID bigint,
	[text] nvarchar(max),
	goodness integer default 0,
	questioner_selected bit default 0,
	admin_selected bit default 0 ,
	[date] date,
	FOREIGN KEY (ID) REFERENCES [USER],
	FOREIGN KEY (q_id) REFERENCES Question,
);




create table Comment(
	c_id bigint IDENTITY(1,1) PRIMARY KEY,
	a_id bigint,
	q_id bigint,
	ID BIGINT,
	[text] nvarchar(max),
	[date] date,
	FOREIGN KEY (ID) REFERENCES [USER],
	FOREIGN KEY (q_id) REFERENCES Question,
	FOREIGN KEY (a_id) REFERENCES Answer
);



create table [Admin](
	adm_id bigint
	PRIMARY KEY (adm_id)
);

create table Score(
	ID BIGINT IDENTITY(1,1) PRIMARY KEY,
	score integer default 0,
	can_use_off integer default 0,
	rate integer,
    USERID BIGINT,
    CONSTRAINT FK_SCORE_USER FOREIGN KEY (USERID)
    REFERENCES [USER](ID)
);


create table DateNotif(
	n_id bigint IDENTITY(1,1) PRIMARY KEY,
	q_id bigint,
	text nvarchar(max),
	PRIMARY KEY(n_id),
	FOREIGN KEY (q_id) REFERENCES [Question]
)


create table SpamNotif(
	s_id bigint IDENTITY(1,1) PRIMARY KEY,
	q_id bigint,
	text nvarchar(max),
	delete_it int default -1,
	PRIMARY KEY(s_id),
	FOREIGN KEY (q_id) REFERENCES [Question]
)