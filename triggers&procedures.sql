
-- to show answers of questions with order
create procedure show_answers_for_questions_by_id  @q_id bigint
as 
select * from Answer
			where @q_id = q_id
			order by admin_selected , goodness;
go

--inease is selected number when insert an answer

create trigger insease_answer_number_in_Q
on Answer 
for update
as
begin 
	declare @last_added_answer	bigint
	declare @is_admin_selected int
	set @last_added_answer = (select max(a_id) from Answer)
	set @is_admin_selected = (select admin_selected 
				from Answer   
				where @last_added_answer = a_id)

	if @is_admin_selected = 1
	begin
		update Question
		set admin_selected = 1
		where (select q_id from Answer where a_id = @last_added_answer)= q_id
	end

	select * from Question
	 
end
go


--------------spam
CREATE TRIGGER tr_QUESTION_For_SPAM
on dbo.Question
FOR UPDATE
AS
BEGIN
    -- SET NOCOUNT ON;
    DECLARE @QUESTION_ID BIGINT
    Declare @SPAM_NUMBER integer
    DECLARE @USER_ID NVARCHAR(MAX)
    -- DECLARE @TYPE BIGINT
    
    DECLARE @TEXT NVARCHAR(MAX)

    set @QUESTION_ID = (select q_id from inserted)
    set @SPAM_NUMBER = (select is_spam from inserted)
    set @USER_ID = (select ID from inserted)

    IF UPDATE (is_spam) 
    BEGIN

        IF @SPAM_NUMBER>5
        BEGIN
            -- set spam notif
            set @SPAM_NUMBER = (select is_spam from inserted)
            set @TEXT = 'this questoin is reported as a spam';
            INSERT into dbo.SpamNotif (q_id , text)
            values (@QUESTION_ID , @TEXT);
            
            --set spam question's visibility false
            UPDATE dbo.Question
            SET    visible = 0

        END
        --change score of spammer user
        DECLARE @SCORE INTEGER
        DECLARE @DISCOUNT INTEGER
        IF (select Score from Score where ID =  @USER_ID)!=null
        BEGIN
            set @SCORE = (select Score from Score where ID =  @USER_ID) - 10
            set @DISCOUNT = (case 
                        when (select Score from Score where ID =  @USER_ID) > 0.1 then 
                            (select Score from Score where ID =  @USER_ID) - 0.1
                         else 0
                         end)
            UPDATE dbo.Score
            SET    ID = @USER_ID , score = @SCORE , can_use_off = @DISCOUNT
        END
        ELSE
        BEGIN
            set @SCORE = -10
            set @DISCOUNT = 0
            INSERT into dbo.Score (ID , score, can_use_off)
                values (@USER_ID , @SCORE , @DISCOUNT);
        END
    END
End
--------
create procedure admin_login 
as 
declare @c bigint 
set @c = 1
while @c <= (select max(q_id) from Question) 
begin
	if (select answers_number from Question where @c = q_id)>0
	begin
		declare @a date
		set @a = (SELECT CONVERT(date, getdate(), 101));
		declare @b varchar(10)
		set @b = (select [date] from Question where @c = q_id)
		if DATEDIFF(day, @b, @a) > 30 
		begin
	
		insert into DateNotif (q_id ,[TEXT] )
		values (( select q_id  from Question where @c = q_id),( select	[text]  from Question where @c = q_id) )
		end
	end
	set @c = @c + 1

end

go


---------goodness

CREATE TRIGGER tr_ANSWER_For_goodness_selection
on dbo.ANSWER
FOR UPDATE
AS
BEGIN

    -- SET NOCOUNT ON;
    DECLARE @ANSWER_ID BIGINT
    Declare @GOODNESS integer
    DECLARE @REPLIER_USER_ID NVARCHAR(MAX)

    set @ANSWER_ID = (select a_id from inserted)
    set @GOODNESS = (select goodness from inserted)
    set @REPLIER_USER_ID = (select ID from inserted)

    IF UPDATE(goodness)
    BEGIN
        --increament score
        IF(select USERID from dbo.score where USERID = @REPLIER_USER_ID)!=NULL
        BEGIN
            UPDATE dbo.score
            SET score = score + 1 , can_use_off = can_use_off + 0.1
            WHERE USERID = @REPLIER_USER_ID
        END
        ELSE
        BEGIN
            INSERT into dbo.Score (ID , score, can_use_off)
                values (@REPLIER_USER_ID , 1 , 0.1);
        END
    END
    IF UPDATE(questioner_selected)
    BEGIN
        IF(SELECT USERID FROM dbo.score where USERID = @REPLIER_USER_ID)!=NULL
        BEGIN
            UPDATE dbo.score
            SET score = score + 10 , can_use_off = can_use_off + 1
            WHERE USERID = @REPLIER_USER_ID
        END
        ELSE
        BEGIN
            INSERT into dbo.Score (ID , score, can_use_off)
                values (@REPLIER_USER_ID , 10 , 1);
        END
    END
End
---------
create procedure admin_logout_spam
as
begin 
	declare @c bigint
	set @c = 1
	declare @max bigint
	set @max = (select max(s_id) from spamNotif)
	while @c <= @max
	begin
		delete from Question 
			where q_id = (select q_id from spamNotif where s_id = @c and delete_it = 1)

		if (select delete_it from spamNotif where s_id = @c ) = 0
		begin
			update Question
			set is_spam = 0 , visible = 1
			where q_id = @c
		end 
		delete from spamNotif 
			where s_id = @c
	end
end




-------goodness

CREATE TRIGGER tr_ANSWER_For_goodness_selection
on dbo.ANSWER
FOR UPDATE
AS
BEGIN

    -- SET NOCOUNT ON;
    DECLARE @ANSWER_ID BIGINT
    Declare @GOODNESS integer
    DECLARE @REPLIER_USER_ID NVARCHAR(MAX)

    set @ANSWER_ID = (select a_id from inserted)
    set @GOODNESS = (select goodness from inserted)
    set @REPLIER_USER_ID = (select ID from inserted)

    IF UPDATE(goodness)
    BEGIN
        --increament score
        IF(select ID from dbo.score where USERID = @REPLIER_USER_ID)!=NULL
        BEGIN
            UPDATE dbo.score
            SET score = score + 1 , can_use_off = can_use_off + 0.1
            WHERE USERID = @REPLIER_USER_ID
        END
        ELSE
        BEGIN
            INSERT into dbo.Score (ID , score, can_use_off)
                values (@REPLIER_USER_ID , 1 , 0.1);
        END
    END
    IF UPDATE(questioner_selected)
    BEGIN
        IF(SELECT USERID FROM dbo.score where USERID = @REPLIER_USER_ID)!=NULL
        BEGIN
            UPDATE dbo.score
            SET score = score + 10 , can_use_off = can_use_off + 1
            WHERE USERID = @REPLIER_USER_ID
        END
        ELSE
        BEGIN
            INSERT into dbo.Score (ID , score, can_use_off)
                values (@REPLIER_USER_ID , 10 , 1);
        END
    END
End











