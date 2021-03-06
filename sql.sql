USE [master]
GO
/****** Object:  Database [methoda]    Script Date: 30/12/2021 11:16:23 ******/
CREATE DATABASE [methoda]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'methoda', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\methoda.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'methoda_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\methoda_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [methoda] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [methoda].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [methoda] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [methoda] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [methoda] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [methoda] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [methoda] SET ARITHABORT OFF 
GO
ALTER DATABASE [methoda] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [methoda] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [methoda] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [methoda] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [methoda] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [methoda] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [methoda] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [methoda] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [methoda] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [methoda] SET  DISABLE_BROKER 
GO
ALTER DATABASE [methoda] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [methoda] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [methoda] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [methoda] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [methoda] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [methoda] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [methoda] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [methoda] SET RECOVERY FULL 
GO
ALTER DATABASE [methoda] SET  MULTI_USER 
GO
ALTER DATABASE [methoda] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [methoda] SET DB_CHAINING OFF 
GO
ALTER DATABASE [methoda] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [methoda] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [methoda] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'methoda', N'ON'
GO
ALTER DATABASE [methoda] SET QUERY_STORE = OFF
GO
USE [methoda]
GO
/****** Object:  Table [dbo].[status]    Script Date: 30/12/2021 11:16:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[status](
	[name] [nvarchar](50) NOT NULL,
	[initial] [bit] NOT NULL,
	[orphan] [bit] NOT NULL,
	[final] [bit] NOT NULL,
 CONSTRAINT [PK_status_1] PRIMARY KEY CLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[transitions]    Script Date: 30/12/2021 11:16:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[transitions](
	[name] [nvarchar](50) NOT NULL,
	[fromStatus] [nvarchar](50) NOT NULL,
	[toStatus] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
INSERT [dbo].[status] ([name], [initial], [orphan], [final]) VALUES (N'a', 1, 0, 1)
INSERT [dbo].[status] ([name], [initial], [orphan], [final]) VALUES (N'b', 0, 1, 1)
INSERT [dbo].[status] ([name], [initial], [orphan], [final]) VALUES (N'c', 0, 1, 1)
INSERT [dbo].[status] ([name], [initial], [orphan], [final]) VALUES (N'd', 0, 1, 1)
GO
/****** Object:  StoredProcedure [dbo].[addStatus]    Script Date: 30/12/2021 11:16:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[addStatus](@name nvarchar(50),@initial bit,@orphan bit ,@final bit)
AS
insert  into  status  values (@name,@initial,@orphan,@final)
GO
/****** Object:  StoredProcedure [dbo].[addTransition]    Script Date: 30/12/2021 11:16:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[addTransition](@name nvarchar(50),@fromStatus nvarchar(50),@toStatus nvarchar(50))
AS 
insert  into  transitions  values (@name,@fromStatus,@toStatus)
update status 
set final=0 
where name=@fromStatus
GO
/****** Object:  StoredProcedure [dbo].[deleteStatus]    Script Date: 30/12/2021 11:16:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[deleteStatus](@name nvarchar(50))
AS 
delete from status Where name=@name
delete from transitions where fromStatus =@name OR toStatus=@name
GO
/****** Object:  StoredProcedure [dbo].[deleteTransition]    Script Date: 30/12/2021 11:16:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[deleteTransition](@name nvarchar(50))
AS 
delete from transitions Where name=@name
GO
/****** Object:  StoredProcedure [dbo].[getAllStatus]    Script Date: 30/12/2021 11:16:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[getAllStatus]
AS
select  * from status
GO
/****** Object:  StoredProcedure [dbo].[getAllTransition]    Script Date: 30/12/2021 11:16:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[getAllTransition]
AS 
select * from transitions
GO
/****** Object:  StoredProcedure [dbo].[reset]    Script Date: 30/12/2021 11:16:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[reset]
AS 
delete from status 
delete from transitions 
GO
/****** Object:  StoredProcedure [dbo].[updateStatus]    Script Date: 30/12/2021 11:16:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[updateStatus](@name nvarchar(50),@initial bit,@ophan bit,@final bit)
AS 
update status
set 
initial=@initial,
orphan=@ophan,
final=@final
where name=@name
GO
USE [master]
GO
ALTER DATABASE [methoda] SET  READ_WRITE 
GO