USE [master]
GO
/****** Object:  Database [Examination_System]    Script Date: 12/09/2024 04:06:58 ص ******/
CREATE DATABASE [Examination_System]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Examination System', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Examination System.mdf' , SIZE = 51200KB , MAXSIZE = 256000KB , FILEGROWTH = 10240KB ), 
 FILEGROUP [examFG1] 
( NAME = N'examfile1', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\examfile1.ndf' , SIZE = 51200KB , MAXSIZE = 256000KB , FILEGROWTH = 10240KB )
 LOG ON 
( NAME = N'Examination System_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Examination System_log.ldf' , SIZE = 30720KB , MAXSIZE = 102400KB , FILEGROWTH = 10240KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [Examination_System] ADD FILEGROUP [FG1]
GO
ALTER DATABASE [Examination_System] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Examination_System].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Examination_System] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Examination_System] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Examination_System] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Examination_System] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Examination_System] SET ARITHABORT OFF 
GO
ALTER DATABASE [Examination_System] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Examination_System] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Examination_System] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Examination_System] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Examination_System] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Examination_System] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Examination_System] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Examination_System] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Examination_System] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Examination_System] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Examination_System] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Examination_System] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Examination_System] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Examination_System] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Examination_System] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Examination_System] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Examination_System] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Examination_System] SET RECOVERY FULL 
GO
ALTER DATABASE [Examination_System] SET  MULTI_USER 
GO
ALTER DATABASE [Examination_System] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Examination_System] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Examination_System] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Examination_System] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Examination_System] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Examination_System] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Examination_System', N'ON'
GO
ALTER DATABASE [Examination_System] SET QUERY_STORE = ON
GO
ALTER DATABASE [Examination_System] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [Examination_System]
GO
/****** Object:  User [training_manager_user]    Script Date: 12/09/2024 04:06:59 ص ******/
CREATE USER [training_manager_user] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [student_user]    Script Date: 12/09/2024 04:06:59 ص ******/
CREATE USER [student_user] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [instructor_user]    Script Date: 12/09/2024 04:06:59 ص ******/
CREATE USER [instructor_user] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [admin_user]    Script Date: 12/09/2024 04:06:59 ص ******/
CREATE USER [admin_user] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [TrainingManagerRole]    Script Date: 12/09/2024 04:06:59 ص ******/
CREATE ROLE [TrainingManagerRole]
GO
/****** Object:  DatabaseRole [StudentRole]    Script Date: 12/09/2024 04:06:59 ص ******/
CREATE ROLE [StudentRole]
GO
/****** Object:  DatabaseRole [InstructorRole]    Script Date: 12/09/2024 04:06:59 ص ******/
CREATE ROLE [InstructorRole]
GO
/****** Object:  DatabaseRole [AdminRole]    Script Date: 12/09/2024 04:06:59 ص ******/
CREATE ROLE [AdminRole]
GO
ALTER ROLE [TrainingManagerRole] ADD MEMBER [training_manager_user]
GO
ALTER ROLE [StudentRole] ADD MEMBER [student_user]
GO
ALTER ROLE [InstructorRole] ADD MEMBER [instructor_user]
GO
ALTER ROLE [AdminRole] ADD MEMBER [admin_user]
GO
/****** Object:  UserDefinedFunction [dbo].[CalculatePercentage]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CalculatePercentage] (@Exam_ID INT, @Student_ID INT)
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
GO
/****** Object:  Table [dbo].[Instructor]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Instructor](
	[Ins_ID] [int] NOT NULL,
	[Ins_name] [nvarchar](100) NOT NULL,
	[Ins_Email] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Ins_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Ins_Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Course]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Course](
	[Course_ID] [int] NOT NULL,
	[C_name] [nvarchar](100) NULL,
	[C_Discription] [nvarchar](255) NULL,
	[Max_degree] [int] NULL,
	[Min_degree] [int] NULL,
	[Track_ID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Course_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Teaches]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Teaches](
	[Ins_ID] [int] NOT NULL,
	[Course_ID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Ins_ID] ASC,
	[Course_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[InstructorCoursesView]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[InstructorCoursesView] AS
SELECT 
    i.Ins_ID, 
    i.Ins_name, 
    c.Course_ID, 
    c.C_name AS Course_Name
FROM 
    Instructor i
    JOIN Teaches t ON i.Ins_ID = t.Ins_ID
    JOIN Course c ON t.Course_ID = c.Course_ID;
GO
/****** Object:  Table [dbo].[Branch]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Branch](
	[Branch_ID] [int] NOT NULL,
	[B_Name] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Branch_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Track]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Track](
	[Track_id] [int] NOT NULL,
	[T_name] [varchar](255) NOT NULL,
	[Intake_id] [int] NOT NULL,
	[Branch_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Track_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[T_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[CourseDetailsView]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE VIEW [dbo].[CourseDetailsView] AS
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
GO
/****** Object:  Table [dbo].[Exam]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Exam](
	[Exam_ID] [int] NOT NULL,
	[Exam_Type] [nvarchar](50) NOT NULL,
	[Date] [date] NOT NULL,
	[Start_Time] [time](7) NOT NULL,
	[End_Time] [time](7) NOT NULL,
	[Total_Time] [int] NOT NULL,
	[Allowance_Options] [nvarchar](50) NULL,
	[Max_Degree] [int] NULL,
	[Course_ID] [int] NULL,
	[Instructor_ID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Exam_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Student]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student](
	[Student_ID] [int] NOT NULL,
	[St_name] [nvarchar](100) NOT NULL,
	[St_Email] [nvarchar](100) NOT NULL,
	[Track_ID] [int] NULL,
	[Intake_ID] [int] NULL,
	[Branch_ID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Student_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[St_Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Takes]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Takes](
	[Student_ID] [int] NOT NULL,
	[Course_ID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Student_ID] ASC,
	[Course_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Participates]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Participates](
	[Student_ID] [int] NOT NULL,
	[Exam_ID] [int] NOT NULL,
	[Participation_Date] [date] NOT NULL,
	[Course_ID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Student_ID] ASC,
	[Exam_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[StudentCourseExamsView]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE VIEW [dbo].[StudentCourseExamsView] AS
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
GO
/****** Object:  Table [dbo].[Intake]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Intake](
	[Int_id] [int] NOT NULL,
	[Int_name] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Int_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[StudentDetailsView]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- عرض بيانات الطلاب مع التفاصيل الكاملة
CREATE VIEW [dbo].[StudentDetailsView] AS
SELECT 
    s.Student_ID, 
    s.St_name, 
    s.St_Email, 
    b.B_Name AS Branch_Name, 
    t.T_name AS Track_Name, 
    i.Int_name AS Intake_Name
FROM 
    Student s
    JOIN Branch b ON s.Branch_ID = b.Branch_ID
    JOIN Track t ON s.Track_ID = t.Track_id
    JOIN Intake i ON s.Intake_ID = i.Int_id;
GO
/****** Object:  Table [dbo].[Exam_Total_Result]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Exam_Total_Result](
	[TotalResultID] [int] IDENTITY(1,1) NOT NULL,
	[Exam_ID] [int] NOT NULL,
	[Student_ID] [int] NOT NULL,
	[Total_Mark] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TotalResultID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[StudentExamResultsView]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[StudentExamResultsView] AS
SELECT 
    s.Student_ID,
    s.St_name,
    e.Exam_ID,
    e.Exam_Type,
    etr.Total_Mark AS Exam_result
FROM 
    Student s
JOIN 
    Exam_Total_Result etr ON s.Student_ID = etr.Student_ID
JOIN 
    Exam e ON e.Exam_ID = etr.Exam_ID;
GO
/****** Object:  Table [dbo].[Training_Manager]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Training_Manager](
	[MGR_ID] [int] NOT NULL,
	[MGR_Name] [nvarchar](100) NOT NULL,
	[MGR_Email] [nvarchar](100) NOT NULL,
	[Branch_ID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MGR_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[MGR_Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[TrainingManagerView]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------
CREATE VIEW [dbo].[TrainingManagerView] AS
SELECT 
    TM.MGR_ID,
    TM.MGR_Name,
    TM.MGR_Email,
    B.Branch_ID,
    B.B_Name AS BranchName,
    C.Course_ID,
    C.C_name AS CourseName,
    T.T_name AS TrackName
FROM Training_Manager TM
JOIN Branch B ON TM.Branch_ID = B.Branch_ID
JOIN Track T ON B.Branch_ID = T.Branch_id
JOIN Course C ON T.Track_id = C.Track_ID;

GO
/****** Object:  View [dbo].[ExamDetailsView]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ExamDetailsView] AS
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
GO
/****** Object:  View [dbo].[BranchCoursesView]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BranchCoursesView] AS
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
GO
/****** Object:  View [dbo].[TrackDetailsView]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TrackDetailsView] AS
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
GO
/****** Object:  View [dbo].[ExamStatisticsView]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ExamStatisticsView] AS
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
GO
/****** Object:  View [dbo].[StudentPerformanceView]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[StudentPerformanceView] AS
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
GO
/****** Object:  Table [dbo].[Contain]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contain](
	[Exam_ID] [int] NOT NULL,
	[Q_ID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Exam_ID] ASC,
	[Q_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Exam_Question] UNIQUE NONCLUSTERED 
(
	[Exam_ID] ASC,
	[Q_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EX_Crc]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EX_Crc](
	[Exam_ID] [int] NOT NULL,
	[Course_ID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Exam_ID] ASC,
	[Course_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Exam_Question]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Exam_Question](
	[EQ_ID] [int] IDENTITY(1,1) NOT NULL,
	[Exam_ID] [int] NOT NULL,
	[Q_ID] [int] NOT NULL,
	[Course_ID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EQ_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Q_options]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Q_options](
	[Options_id] [int] NOT NULL,
	[Q_id] [int] NOT NULL,
	[Option_A] [varchar](255) NOT NULL,
	[Option_B] [varchar](255) NOT NULL,
	[Option_C] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[Options_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Question]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Question](
	[Q_id] [int] NOT NULL,
	[Q_type] [varchar](10) NOT NULL,
	[Q_text] [text] NOT NULL,
	[Correct_answer] [varchar](50) NOT NULL,
	[Instructor_id] [int] NULL,
	[Track_id] [int] NOT NULL,
	[Course_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Q_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[st_answer]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[st_answer](
	[Answer_ID] [int] IDENTITY(1,1) NOT NULL,
	[Answer] [text] NULL,
	[Is_Correct] [bit] NULL,
	[Marks_obtained] [decimal](5, 2) NULL,
	[St_ID] [int] NULL,
	[Q_ID] [int] NULL,
	[EXAM_ID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Answer_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [idx_Contains_Exam_ID]    Script Date: 12/09/2024 04:07:00 ص ******/
CREATE NONCLUSTERED INDEX [idx_Contains_Exam_ID] ON [dbo].[Contain]
(
	[Exam_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_Contains_Question_ID]    Script Date: 12/09/2024 04:07:00 ص ******/
CREATE NONCLUSTERED INDEX [idx_Contains_Question_ID] ON [dbo].[Contain]
(
	[Q_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_Course_Track_ID]    Script Date: 12/09/2024 04:07:00 ص ******/
CREATE NONCLUSTERED INDEX [idx_Course_Track_ID] ON [dbo].[Course]
(
	[Track_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_Exam_Course_ID]    Script Date: 12/09/2024 04:07:00 ص ******/
CREATE NONCLUSTERED INDEX [idx_Exam_Course_ID] ON [dbo].[Exam]
(
	[Course_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_Participates_Exam_ID]    Script Date: 12/09/2024 04:07:00 ص ******/
CREATE NONCLUSTERED INDEX [idx_Participates_Exam_ID] ON [dbo].[Participates]
(
	[Exam_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_Participates_Participation_Date]    Script Date: 12/09/2024 04:07:00 ص ******/
CREATE NONCLUSTERED INDEX [idx_Participates_Participation_Date] ON [dbo].[Participates]
(
	[Participation_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_Participates_Student_ID]    Script Date: 12/09/2024 04:07:00 ص ******/
CREATE NONCLUSTERED INDEX [idx_Participates_Student_ID] ON [dbo].[Participates]
(
	[Student_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_Student_Track_ID]    Script Date: 12/09/2024 04:07:00 ص ******/
CREATE NONCLUSTERED INDEX [idx_Student_Track_ID] ON [dbo].[Student]
(
	[Track_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_Takes_Course_ID]    Script Date: 12/09/2024 04:07:00 ص ******/
CREATE NONCLUSTERED INDEX [idx_Takes_Course_ID] ON [dbo].[Takes]
(
	[Course_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_Takes_Student_ID]    Script Date: 12/09/2024 04:07:00 ص ******/
CREATE NONCLUSTERED INDEX [idx_Takes_Student_ID] ON [dbo].[Takes]
(
	[Student_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_Teaches_Course_ID]    Script Date: 12/09/2024 04:07:00 ص ******/
CREATE NONCLUSTERED INDEX [idx_Teaches_Course_ID] ON [dbo].[Teaches]
(
	[Course_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_Teaches_Instructor_ID]    Script Date: 12/09/2024 04:07:00 ص ******/
CREATE NONCLUSTERED INDEX [idx_Teaches_Instructor_ID] ON [dbo].[Teaches]
(
	[Ins_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_Track_Branch_ID]    Script Date: 12/09/2024 04:07:00 ص ******/
CREATE NONCLUSTERED INDEX [idx_Track_Branch_ID] ON [dbo].[Track]
(
	[Branch_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_Training_Manager_Branch_ID]    Script Date: 12/09/2024 04:07:00 ص ******/
CREATE NONCLUSTERED INDEX [idx_Training_Manager_Branch_ID] ON [dbo].[Training_Manager]
(
	[Branch_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Contain]  WITH CHECK ADD FOREIGN KEY([Exam_ID])
REFERENCES [dbo].[Exam] ([Exam_ID])
GO
ALTER TABLE [dbo].[Course]  WITH CHECK ADD FOREIGN KEY([Track_ID])
REFERENCES [dbo].[Track] ([Track_id])
GO
ALTER TABLE [dbo].[EX_Crc]  WITH CHECK ADD FOREIGN KEY([Course_ID])
REFERENCES [dbo].[Course] ([Course_ID])
GO
ALTER TABLE [dbo].[EX_Crc]  WITH CHECK ADD FOREIGN KEY([Exam_ID])
REFERENCES [dbo].[Exam] ([Exam_ID])
GO
ALTER TABLE [dbo].[Exam]  WITH CHECK ADD FOREIGN KEY([Course_ID])
REFERENCES [dbo].[Course] ([Course_ID])
GO
ALTER TABLE [dbo].[Exam]  WITH CHECK ADD FOREIGN KEY([Instructor_ID])
REFERENCES [dbo].[Instructor] ([Ins_ID])
GO
ALTER TABLE [dbo].[Exam_Question]  WITH CHECK ADD FOREIGN KEY([Course_ID])
REFERENCES [dbo].[Course] ([Course_ID])
GO
ALTER TABLE [dbo].[Exam_Question]  WITH CHECK ADD FOREIGN KEY([Exam_ID])
REFERENCES [dbo].[Exam] ([Exam_ID])
GO
ALTER TABLE [dbo].[Exam_Question]  WITH CHECK ADD FOREIGN KEY([Q_ID])
REFERENCES [dbo].[Question] ([Q_id])
GO
ALTER TABLE [dbo].[Exam_Total_Result]  WITH CHECK ADD FOREIGN KEY([Exam_ID])
REFERENCES [dbo].[Exam] ([Exam_ID])
GO
ALTER TABLE [dbo].[Exam_Total_Result]  WITH CHECK ADD FOREIGN KEY([Student_ID])
REFERENCES [dbo].[Student] ([Student_ID])
GO
ALTER TABLE [dbo].[Participates]  WITH CHECK ADD FOREIGN KEY([Course_ID])
REFERENCES [dbo].[Course] ([Course_ID])
GO
ALTER TABLE [dbo].[Participates]  WITH CHECK ADD FOREIGN KEY([Exam_ID])
REFERENCES [dbo].[Exam] ([Exam_ID])
GO
ALTER TABLE [dbo].[Participates]  WITH CHECK ADD FOREIGN KEY([Student_ID])
REFERENCES [dbo].[Student] ([Student_ID])
GO
ALTER TABLE [dbo].[Participates]  WITH CHECK ADD  CONSTRAINT [FK_Student_Course] FOREIGN KEY([Student_ID], [Course_ID])
REFERENCES [dbo].[Takes] ([Student_ID], [Course_ID])
GO
ALTER TABLE [dbo].[Participates] CHECK CONSTRAINT [FK_Student_Course]
GO
ALTER TABLE [dbo].[Q_options]  WITH CHECK ADD FOREIGN KEY([Q_id])
REFERENCES [dbo].[Question] ([Q_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Question]  WITH CHECK ADD FOREIGN KEY([Course_id])
REFERENCES [dbo].[Course] ([Course_ID])
GO
ALTER TABLE [dbo].[Question]  WITH CHECK ADD FOREIGN KEY([Instructor_id])
REFERENCES [dbo].[Instructor] ([Ins_ID])
GO
ALTER TABLE [dbo].[Question]  WITH CHECK ADD FOREIGN KEY([Track_id])
REFERENCES [dbo].[Track] ([Track_id])
GO
ALTER TABLE [dbo].[st_answer]  WITH CHECK ADD FOREIGN KEY([Q_ID])
REFERENCES [dbo].[Question] ([Q_id])
GO
ALTER TABLE [dbo].[st_answer]  WITH CHECK ADD FOREIGN KEY([EXAM_ID])
REFERENCES [dbo].[Exam] ([Exam_ID])
GO
ALTER TABLE [dbo].[st_answer]  WITH CHECK ADD FOREIGN KEY([St_ID])
REFERENCES [dbo].[Student] ([Student_ID])
GO
ALTER TABLE [dbo].[Student]  WITH CHECK ADD FOREIGN KEY([Branch_ID])
REFERENCES [dbo].[Branch] ([Branch_ID])
GO
ALTER TABLE [dbo].[Student]  WITH CHECK ADD FOREIGN KEY([Intake_ID])
REFERENCES [dbo].[Intake] ([Int_id])
GO
ALTER TABLE [dbo].[Student]  WITH CHECK ADD FOREIGN KEY([Track_ID])
REFERENCES [dbo].[Track] ([Track_id])
GO
ALTER TABLE [dbo].[Takes]  WITH CHECK ADD FOREIGN KEY([Course_ID])
REFERENCES [dbo].[Course] ([Course_ID])
GO
ALTER TABLE [dbo].[Takes]  WITH CHECK ADD FOREIGN KEY([Student_ID])
REFERENCES [dbo].[Student] ([Student_ID])
GO
ALTER TABLE [dbo].[Teaches]  WITH CHECK ADD FOREIGN KEY([Course_ID])
REFERENCES [dbo].[Course] ([Course_ID])
GO
ALTER TABLE [dbo].[Teaches]  WITH CHECK ADD FOREIGN KEY([Ins_ID])
REFERENCES [dbo].[Instructor] ([Ins_ID])
GO
ALTER TABLE [dbo].[Track]  WITH CHECK ADD FOREIGN KEY([Branch_id])
REFERENCES [dbo].[Branch] ([Branch_ID])
GO
ALTER TABLE [dbo].[Track]  WITH CHECK ADD FOREIGN KEY([Intake_id])
REFERENCES [dbo].[Intake] ([Int_id])
GO
ALTER TABLE [dbo].[Training_Manager]  WITH CHECK ADD FOREIGN KEY([Branch_ID])
REFERENCES [dbo].[Branch] ([Branch_ID])
GO
/****** Object:  StoredProcedure [dbo].[AddStudent]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddStudent]
	@st_id INT,
    @St_name NVARCHAR(100),
    @St_Email NVARCHAR(100),
    @Track_ID INT,
    @Intake_ID INT,
    @Branch_ID INT
AS
BEGIN
    INSERT INTO Student (Student_id, St_name, St_Email, Track_ID, Intake_ID, Branch_ID)
    VALUES (@st_id, @St_name, @St_Email, @Track_ID, @Intake_ID, @Branch_ID);
END;
GO
/****** Object:  StoredProcedure [dbo].[CalcExamResult]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CalcExamResult]
    @Exam_ID INT,
    @Student_ID INT
AS
BEGIN
    DECLARE @TotalMarks INT;

    -- حساب درجة الطالب الكاملة في الامتحان بناءً على درجات كل سؤال
    SELECT @TotalMarks = SUM(Marks_obtained)
    FROM st_answer sa
    JOIN Exam_Question eq ON sa.Q_ID = eq.Q_ID
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
GO
/****** Object:  StoredProcedure [dbo].[GetAnExam]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetAnExam]
    @Exam_ID INT,
    @Course_ID INT,
    @NumQuestions INT
AS
BEGIN
    -- Randomly select questions based on Course_ID
    SELECT TOP (@NumQuestions) 
		Q.Q_ID,
        Q.Q_Text,
        QO.Option_A,
        QO.Option_B,
        QO.Option_C,
		E.Exam_ID, 
		C.C_name AS Course_name
    FROM Question Q
    LEFT JOIN Q_options QO ON Q.Q_ID = QO.Q_ID -- Join to get the options for each question
	JOIN Exam E ON E.Course_ID = Q.Course_id
	JOIN Course C ON Q.Course_id = C.Course_ID
    WHERE Q.Course_ID = @Course_ID
    ORDER BY NEWID(); -- Random retrieval

    -- Insert the selected questions into Exam_Question table, linking them to the specified exam
    INSERT INTO Exam_Question (Exam_ID, Q_ID, Course_ID)
    SELECT @Exam_ID, Q_ID, @Course_ID
    FROM (
        SELECT TOP (@NumQuestions) Q_ID
        FROM Question
        WHERE Course_ID = @Course_ID
        ORDER BY NEWID()
    ) AS RandomQuestions;
END;
GO
/****** Object:  StoredProcedure [dbo].[Submit_Student_Answer]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Submit_Student_Answer]
    @St_ID INT,
    @Q_ID INT,
    @Selected_Answer VARCHAR(255),
    @Exam_ID INT  -- Add parameter for Exam_ID
AS
BEGIN
    DECLARE @Correct_Answer VARCHAR(255);
    DECLARE @Is_Correct BIT;
    DECLARE @Marks INT;

    -- Fetch the correct answer for the question
    SELECT @Correct_Answer = Correct_Answer
    FROM Question
    WHERE Q_id = @Q_ID;

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

    -- Insert the answer into the st_answer table with all required fields
    INSERT INTO st_answer (Answer, Is_Correct, Marks_obtained, Q_ID, St_ID, EXAM_ID)
    VALUES (@Selected_Answer, @Is_Correct, @Marks, @Q_ID, @St_ID, @Exam_ID);
END;
GO
/****** Object:  StoredProcedure [dbo].[UpdateStudent]    Script Date: 12/09/2024 04:07:00 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateStudent]
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
    WHERE Student_ID = @Student_ID;
END;
GO
USE [master]
GO
ALTER DATABASE [Examination_System] SET  READ_WRITE 
GO
