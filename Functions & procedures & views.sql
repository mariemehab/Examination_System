/*
----------------- procedures ----------------------------
CREATE PROCEDURE AddStudent
		@St_name NVARCHAR(100),
		@St_Email NVARCHAR(100),
		@Track_ID INT,
		@Intake_ID INT,
		@Branch_ID INT
	AS
	BEGIN
		INSERT INTO Student (St_name, St_Email, Track_ID, Intake_ID, Branch_ID)
		VALUES (@St_name, @St_Email, @Track_ID, @Intake_ID, @Branch_ID);
	END;

------------------------------------------
CREATE PROCEDURE Submit_Student_Answer
    @St_ID INT,
    @EQ_ID INT,
    @Selected_Answer VARCHAR(255),
    @id INT
AS
BEGIN
    DECLARE @Correct_Answer VARCHAR(255);
    DECLARE @Is_Correct BIT;
    DECLARE @Marks INT;

    -- Fetch the correct answer for the question
    SELECT @Correct_Answer = Correct_Answer
    FROM Question
    WHERE Q_id = @EQ_ID;

    -- Determine if the answer is correct
    IF @Selected_Answer = @Correct_Answer
    BEGIN
        SET @Is_Correct = 1;
        SET @Marks = 10;  -- 10 marks for correct answers
    END
    ELSE
    BEGIN
        SET @Is_Correct = 0;
        SET @Marks = 0;  -- 0 marks for incorrect answers
    END

    -- Insert the answer into the st_answer table
    INSERT INTO st_answer (Answer_ID, Answer, Is_Correct, Marks_obtained, EQ_ID, St_ID)
    VALUES (@id, @Selected_Answer, @Is_Correct, @Marks, @EQ_ID, @St_ID);
END;
------------------------------------------

/*
CREATE PROCEDURE [dbo].[CalculateTotalExamResult]
    @Exam_ID INT,
    @Student_ID INT
AS
BEGIN
    DECLARE @TotalMarks INT;

    -- حساب درجة الطالب الكاملة في الامتحان بناءً على درجات كل سؤال
    SELECT @TotalMarks = SUM(Marks_obtained)
    FROM st_answer sa
    JOIN Exam_Question eq ON sa.EQ_ID = eq.EQ_ID
    WHERE eq.Exam_ID = @Exam_ID AND sa.St_ID = @Student_ID;

    -- إذا كانت النتيجة موجودة بالفعل، قم بتحديثها، إذا لم تكن موجودة، قم بإدراجها
    IF EXISTS (SELECT 1 FROM Exam_Total_Result WHERE Exam_ID = @Exam_ID AND Student_ID = @Student_ID)
    BEGIN
        UPDATE Exam_Total_Result
        SET Total_Mark = @TotalMarks
        WHERE Exam_ID = @Exam_ID AND Student_ID = @Student_ID;
    END
    ELSE
    BEGIN
        INSERT INTO Exam_Total_Result (Exam_ID, Student_ID, Total_Mark)
        VALUES (@Exam_ID, @Student_ID, @TotalMarks);
    END

    PRINT 'Total Marks for Exam ' + CAST(@Exam_ID AS NVARCHAR) + ' for Student ' + CAST(@Student_ID AS NVARCHAR) + ' is: ' + CAST(@TotalMarks AS NVARCHAR);
END;
*/

------------------------------------------

CREATE PROCEDURE UpdateStudent
		@Student_ID INT,
		@St_name NVARCHAR(100),
		@St_Email NVARCHAR(100),
		@Track_ID INT,
		@Intake_ID INT,
		@Branch_ID INT
	AS
	BEGIN
		UPDATE Student
		SET St_name = @St_name,
			St_Email = @St_Email,
			Track_ID = @Track_ID,
			Intake_ID = @Intake_ID,
			Branch_ID = @Branch_ID
		WHERE Student_ID = @Student_ID
	END ;
	
------------------------------------------
CREATE PROCEDURE AddExamResult
    @Exam_ID INT,
    @Student_ID INT,
    @Q_ID INT,
    @StudentAnswer NVARCHAR(MAX),
    @CorrectAnswer NVARCHAR(MAX),
    @IsCorrect BIT,
    @Mark INT
AS
BEGIN
    INSERT INTO Ex_Result (Exam_ID, Student_ID, Q_ID, StudentAnswer, CorrectAnswer, IsCorrect, Mark)
    VALUES (@Exam_ID, @Student_ID, @Q_ID, @StudentAnswer, @CorrectAnswer, @IsCorrect, @Mark);
END;

------------------------------------------

CREATE PROCEDURE CalculateExamResult
    @Exam_ID INT,
    @Student_ID INT
AS
BEGIN
    DECLARE @TotalMarks INT;

    SELECT @TotalMarks = SUM(Mark)
    FROM Ex_Result
    WHERE Exam_ID = @Exam_ID AND Student_ID = @Student_ID;

    PRINT 'Total Marks for Exam ' + CAST(@Exam_ID AS NVARCHAR) + ' for Student ' + CAST(@Student_ID AS NVARCHAR) + ' is: ' + CAST(@TotalMarks AS NVARCHAR);
END;

--=========================== Functions ================================
CREATE FUNCTION CalculatePercentage (@Exam_ID INT, @Student_ID INT)
RETURNS DECIMAL(5, 2)
AS
BEGIN
    DECLARE @TotalMarks INT;
    DECLARE @MaxDegree INT;
    DECLARE @Percentage DECIMAL(5, 2);

    SELECT @TotalMarks = SUM(Mark)
    FROM Ex_Result
    WHERE Exam_ID = @Exam_ID AND Student_ID = @Student_ID;

    SELECT @MaxDegree = Max_Degree
    FROM Exam
    WHERE Exam_ID = @Exam_ID;

    SET @Percentage = (CAST(@TotalMarks AS DECIMAL(5, 2)) / @MaxDegree) * 100;
    
    RETURN @Percentage;
END;

--======================== Views ========================================
CREATE VIEW StudentDetails AS
SELECT 
    S.Student_ID,
    S.St_name,
    S.St_Email,
    T.T_name AS TrackName,
    I.Int_name AS IntakeName,
    B.B_Name AS BranchName
FROM Student S
JOIN Track T ON S.Track_ID = T.Track_id
JOIN Intake I ON S.Intake_ID = I.Int_id
JOIN Branch B ON S.Branch_ID = B.Branch_ID;

------------------------------------------------
CREATE VIEW ExamResultsView AS
SELECT 
    ER.Exam_ID,
    ER.Student_ID,
    S.St_name,
    SUM(ER.Mark) AS TotalMarks
FROM Ex_Result ER
JOIN Student S ON ER.Student_ID = S.Student_ID
GROUP BY ER.Exam_ID, ER.Student_ID, S.St_name;

CREATE VIEW InstructorCoursesView AS
SELECT 
    i.Ins_ID, 
    i.Ins_name, 
    c.Course_ID, 
    c.C_name AS Course_Name
FROM 
    Instructor i
    JOIN Teaches t ON i.Ins_ID = t.Ins_ID
    JOIN Course c ON t.Course_ID = c.Course_ID;


--	------------------------------------------------------
	CREATE VIEW ExamQuestionsView AS
SELECT 
    e.Exam_ID, 
    e.Exam_Type, 
    q.Q_ID, 
    q.Q_Text, 
    eq.Degree_Assigned
FROM                                          -- null
    Exam e
    JOIN Contain c ON e.Exam_ID = c.Exam_ID
    JOIN Question q ON c.Q_ID = q.Q_ID
    JOIN Exam_Question eq ON q.Q_ID = eq.Q_ID;
	----------------------------------------------
	CREATE VIEW CourseDetailsView AS
SELECT 
    c.Course_ID, 
    c.C_name AS Course_Name, 
    c.C_Discription, 
    c.Max_degree, 
    c.Min_degree, 
    t.T_name AS Track_Name, 
    b.B_Name AS Branch_Name
FROM 
    Course c
    JOIN Track t ON c.Track_ID = t.Track_id
    JOIN Branch b ON t.Branch_id = b.Branch_ID;
	-----------------------------------------
	CREATE VIEW StudentCourseExamsView AS
SELECT 
    S.Student_ID, 
    S.St_name AS StudentName, 
    S.St_Email AS StudentEmail, 
    C.Course_ID, 
    C.C_name AS CourseName, 
    C.C_Discription AS CourseDescription,
    MAX(CASE WHEN E.Exam_ID IS NOT NULL THEN 1 ELSE 0 END) AS ExamCount
FROM 
    Student S
    INNER JOIN Takes T ON S.Student_ID = T.Student_ID
    INNER JOIN Course C ON T.Course_ID = C.Course_ID
    LEFT JOIN Exam E ON C.Course_ID = E.Course_ID
    LEFT JOIN Participates P ON E.Exam_ID = P.Exam_ID AND S.Student_ID = P.Student_ID
GROUP BY 
    S.Student_ID, 
    S.St_name, 
    S.St_Email, 
    C.Course_ID, 
    C.C_name, 
    C.C_Discription;
	*/
	;
-------------------------------------
/*
CREATE VIEW dbo.ExamDetailsView AS
SELECT 
    e.Exam_ID,
    e.Exam_Type,
    e.Date,
    e.Start_Time,
    e.End_Time,
    e.Total_Time,
    e.Allowance_Options,
    e.Max_Degree,
    c.C_Name,
    i.Ins_Name AS Instructor_Name
FROM 
    Exam e
JOIN Course c ON e.Course_ID = c.Course_ID
JOIN Instructor i ON e.Instructor_ID = i.Ins_ID;
*/
;

-------------------------------------
/*
CREATE VIEW dbo.BranchCoursesView AS
SELECT 
    b.B_Name AS Branch_Name,
    c.C_Name AS Course_Name,
    t.T_Name AS Track_Name
FROM 
    Branch b
JOIN Student s ON b.Branch_ID = s.Branch_ID
JOIN Track t ON s.Track_ID = t.Track_ID
JOIN Course c ON t.Track_ID = c.Track_ID
GROUP BY 
    b.B_Name, c.C_Name, t.T_Name;
*/
;

-------------------------------------
/*
CREATE VIEW dbo.TrackDetailsView AS
SELECT 
    t.Track_ID,
    t.T_Name AS Track_Name,
    COUNT(DISTINCT c.Course_ID) AS Total_Courses,
    COUNT(DISTINCT s.Student_ID) AS Total_Students
FROM 
    Track t
LEFT JOIN Course c ON t.Track_ID = c.Track_ID
LEFT JOIN Student s ON t.Track_ID = s.Track_ID
GROUP BY 
    t.Track_ID, t.T_Name;
*/
;

-------------------------------------
/*
CREATE VIEW dbo.ExamStatisticsView AS
SELECT 
    e.Exam_ID,
    e.Exam_Type,
    c.C_Name AS Course_Name,
    MAX(er.Total_Mark) AS Highest_Mark,
    MIN(er.Total_Mark) AS Lowest_Mark,
    AVG(er.Total_Mark) AS Average_Mark,
    COUNT(er.Student_ID) AS Total_Students
FROM 
    Exam e
LEFT JOIN Exam_Total_Result er ON e.Exam_ID = er.Exam_ID
LEFT JOIN Course c ON e.Course_ID = c.Course_ID
GROUP BY 
    e.Exam_ID, e.Exam_Type, c.C_Name;
*/
;

-------------------------------------
/*
CREATE VIEW dbo.StudentPerformanceView AS
SELECT 
    s.Student_ID,
    s.St_name,
    t.T_Name AS Track_Name,
    c.C_Name AS Course_Name,
    SUM(er.Total_Mark) AS Course_Total_Marks,
    AVG(er.Total_Mark) AS Course_Average_Marks
FROM 
    Student s
JOIN Track t ON s.Track_ID = t.Track_ID
JOIN Exam_Total_Result er ON s.Student_ID = er.Student_ID
JOIN Exam e ON er.Exam_ID = e.Exam_ID
JOIN Course c ON e.Course_ID = c.Course_ID
GROUP BY 
    s.Student_ID, s.St_name, t.T_Name, c.C_Name;
*/
;

