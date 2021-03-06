USE [master]
GO
/****** Object:  Database [OnlineTutors]    Script Date: 5/27/2018 12:13:45 PM ******/
CREATE DATABASE [OnlineTutors]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'OnlineTutors', FILENAME = N'E:\OnlineTutor\Database\OnlineTutors.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'OnlineTutors_log', FILENAME = N'E:\OnlineTutor\Database\OnlineTutors_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [OnlineTutors] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [OnlineTutors].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [OnlineTutors] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [OnlineTutors] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [OnlineTutors] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [OnlineTutors] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [OnlineTutors] SET ARITHABORT OFF 
GO
ALTER DATABASE [OnlineTutors] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [OnlineTutors] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [OnlineTutors] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [OnlineTutors] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [OnlineTutors] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [OnlineTutors] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [OnlineTutors] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [OnlineTutors] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [OnlineTutors] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [OnlineTutors] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [OnlineTutors] SET  DISABLE_BROKER 
GO
ALTER DATABASE [OnlineTutors] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [OnlineTutors] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [OnlineTutors] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [OnlineTutors] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [OnlineTutors] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [OnlineTutors] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [OnlineTutors] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [OnlineTutors] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [OnlineTutors] SET  MULTI_USER 
GO
ALTER DATABASE [OnlineTutors] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [OnlineTutors] SET DB_CHAINING OFF 
GO
ALTER DATABASE [OnlineTutors] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [OnlineTutors] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'OnlineTutors', N'ON'
GO
USE [OnlineTutors]
GO
/****** Object:  StoredProcedure [dbo].[tblPageImagesUpdate]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[tblPageImagesUpdate]
(@Imageid int,@ImageURL varchar(100),
           @DisplayOrder int,
           @PageID int,
           @status bit
           ,@UpdatedBy int
)

as
if(@ImageURL='' )
begin
	select @ImageURL=ImageURL from [tblPageImages] WHERE Imageid=@Imageid
end
if(exists(select * from [tblPageImages] WHERE Imageid=@Imageid))
UPDATE [dbo].[tblPageImages]
   SET [ImageURL] = @ImageURL
      ,[DisplayOrder] = @DisplayOrder
      ,[PageID] = @PageID
      ,[status] = @status
      ,UpdatedBy=@UpdatedBy
	  ,UpdatedOn=getdate()
 WHERE Imageid=@Imageid

GO
/****** Object:  StoredProcedure [dbo].[USP_AddNode]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Akhilesh Tiwari>
-- Create date: <Create Date,19-11-2010>
-- Description:	<Description,Used for insert the new Node>
-- =============================================
CREATE procedure [dbo].[USP_AddNode](@NodeName as varchar(50), @CreatedBy as varchar(100), @count as integer output)
as
begin
select @count=count(*) from Node where Node_Name=@NodeName and Node_Status='True'
	if (@count<=0)
		insert into Node(Node_Name,Createdby)values(@NodeName,@CreatedBy)
end


GO
/****** Object:  StoredProcedure [dbo].[USP_AddSubNode]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Akhilesh Tiwari>
-- Create date: <Create Date,19-11-2010>
-- Description:	<Description,Used for insert the new subnode>
-- =============================================
CREATE procedure [dbo].[USP_AddSubNode](@SubNodeName as varchar(50),@NodeId as numeric(18), @path varchar(200), @HelpText varchar(50),@Url as varchar(100),@CreatedBy as varchar(100), @count as integer output)
as
begin	
select @count=count(*) from SubNode where SubNode_Name=@SubNodeName and SubNode_Status='True'
	if @count<=0
		insert into SubNode(SubNode_Name,Node_Id,path,HelpText,Url,CreatedBy)values(@SubNodeName,@NodeId,@Path,@HelpText,@Url,@CreatedBy)
end




GO
/****** Object:  StoredProcedure [dbo].[USP_AddUser]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Akhilesh Tiwari>
-- Create date: <Create Date,19-11-2010>
-- Description:	<Description,Used for insert the new User>
-- =============================================
CREATE procedure [dbo].[USP_AddUser](@UserName as varchar(100),@email as nvarchar(100),@ContactNo as nvarchar(15),@Loginid as nvarchar(20),@Password as nvarchar(10), @Branch_Id as int,@Groupid as numeric(18),@Compid as int,@CreatedBy as varchar(100),@count as integer output)
as
begin
select @count=count(*) from UserMaster where Login_Id=@LoginId and Status='True'
	if @count<=0
		insert into UserMaster(User_Name,Email,Contact_Number,Login_Id,Password,Branch_Id,Group_Id,Company_Id,CreatedBy)values(@UserName,@email,@ContactNo,@Loginid,@Password,@Branch_Id,@Groupid,@Compid,@CreatedBy)
end


GO
/****** Object:  StoredProcedure [dbo].[usp_CategoryGet]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_CategoryGet]
as

SELECT [CategoryID]
      ,[CategoryName]
      ,c.[Status]
	  ,c.CreatedBy CreatedByID
      ,u.User_Name as CreatedBy
      ,c.[CreatedOn]
	  ,c.UpdatedBy UpdatedByID
      ,u1.User_Name as UpdatedBy
      ,c.[UpdatedOn]
  FROM [dbo].[tblCategory] c 
  inner join UserMaster u on u.User_Id=c.[CreatedBy]
  left join UserMaster u1 on u1.User_Id=c.[UpdatedBy]


GO
/****** Object:  StoredProcedure [dbo].[usp_CategoryGetbyID]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_CategoryGetbyID](@CategoryID int)
as

SELECT [CategoryID]
      ,[CategoryName]
      ,c.[Status]
	  ,c.CreatedBy CreatedByID
      ,u.User_Name as CreatedBy
      ,c.[CreatedOn]
	  ,c.UpdatedBy UpdatedByID
      ,u1.User_Name as UpdatedBy
      ,c.[UpdatedOn]
  FROM [dbo].[tblCategory] c 
  inner join UserMaster u on u.User_Id=c.[CreatedBy]
  left join UserMaster u1 on u1.User_Id=c.[UpdatedBy]
  where [CategoryID]=@CategoryID


GO
/****** Object:  StoredProcedure [dbo].[usp_CategoryGetList]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[usp_CategoryGetList]
as

select * from (
select 0 CategoryID,'--Select--' CategoryName
union
select CategoryID,CategoryName from tblCategory where Status=1) as aa
GO
/****** Object:  StoredProcedure [dbo].[usp_CategoryInsert]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[usp_CategoryInsert]
(@CategoryName varchar(100)
              ,@CreatedBy int)
as


if(not exists(select * from [tblCategory] where [CategoryName]=@CategoryName))
begin
INSERT INTO [dbo].[tblCategory]
           ([CategoryName]
                      ,[CreatedBy]
           )
     VALUES
           (@CategoryName,@CreatedBy
		   
           )
select 1
end
else
select 0

GO
/****** Object:  StoredProcedure [dbo].[usp_CategoryUpdate]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_CategoryUpdate]
(@CategoryID int,@CategoryName varchar(100),@UpdatedBy int, @status bit)
as

if(exists(select * from [tblCategory] where CategoryID=@CategoryID))
begin

UPDATE [dbo].[tblCategory]
   SET [CategoryName] = @CategoryName
      ,[Status] =@status
   
      ,[UpdatedBy] = @UpdatedBy
      ,[UpdatedOn] = getdate()
 WHERE CategoryID=@CategoryID
 select 1

end
else
select 0
GO
/****** Object:  StoredProcedure [dbo].[USP_FilltreeNodeRights]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Akhilesh Tiwari>
-- Create date: <Create Date,17-11-2010>
-- Description:	<Description,Used for display the nodes value and return the userid and nodeid>
-- =============================================
Create procedure [dbo].[USP_FilltreeNodeRights]
as
begin
select Node.Node_Id,Node.Node_Name from Node where Node.Node_Status='True'
end


GO
/****** Object:  StoredProcedure [dbo].[USP_FilltreeSubNodeRights]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Akhilesh Tiwari>
-- Create date: <Create Date,17-11-2010>
-- Description:	<Description,Used for display the nodes value and return the userid and nodeid>
-- =============================================
Create procedure [dbo].[USP_FilltreeSubNodeRights](@NodeId as numeric(18))
as
begin
select SubNode.SubNode_Id,SubNode.SubNode_Name from SubNode where SubNode.Node_Id=@NodeId and SubNode.SubNode_Status='True'
end


GO
/****** Object:  StoredProcedure [dbo].[USP_GetNodeDetails]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Akhilesh Tiwari>
-- Create date: <Create Date,17-11-2010>
-- Description:	<Description,Used for display the nodes value and return the userid and nodeid>
-- =============================================
CREATE procedure [dbo].[USP_GetNodeDetails]
as
begin
select * from Node   Where node_status='true' order by sequenceid

end



GO
/****** Object:  StoredProcedure [dbo].[USP_GetNodeDetailsOnId]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Rahul Arya>
-- Create date: <Create Date,2-12-2010>
-- Description:	<Used for display the nodes value and return the userid and nodeid>
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetNodeDetailsOnId]
(
@NodeId numeric(18)
)
as
begin
select * from Node where Node_Id=@NodeId and Node_Status='true'
end

GO
/****** Object:  StoredProcedure [dbo].[USP_GetNodeDetailsPrint]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Akhilesh Tiwari>
-- Create date: <Create Date,17-11-2010>
-- Description:	<Description,Used for display the nodes value and return the userid and nodeid>
-- =============================================
Create procedure [dbo].[USP_GetNodeDetailsPrint]
as
begin
SELECT     Node_Name, dbo.FormatDate(CreationDate) AS Expr1, CreatedBy
FROM         dbo.Node   Where node_status='true' order by dbo.Node.Node_Name 
end


GO
/****** Object:  StoredProcedure [dbo].[USP_GetNodeValues]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<Author,,Akhilesh Tiwari>
-- Create date: <Create Date,17-11-2010>
-- Description:	<Description,Used for display the nodes value and return the userid and nodeid>
-- =============================================
CREATE procedure [dbo].[USP_GetNodeValues](@LoginId as numeric(18))
as
begin
select distinct(SubNode.Node_Id) Node_Id,UserMaster.User_Id,Node.Node_Name,sequenceid --, SubNode.SortOrder
from SubNode,Node,Rights,UserMaster where SubNode.Node_Id=Node.Node_Id 
and SubNode.SubNode_Id=Rights.SubNode_Id 
and UserMaster.User_Id=Rights.User_Id
and UserMaster.User_Id=@LoginId
and UserMaster.Status='True' 
and Node.Node_Status='True' 
and SubNode.SubNode_Status='True'
order by sequenceid
 /*select Group.Group_Id,Group.Group_Name,Node.Node_Id,Node.Node_Name,UserMaster.User_Id 
 from Group,Node,UserMaster where Group.Group_Id=UserMaster.Group_Id 
and UserMaster.Login_Id=@LoginId and UserMaster.Password=@Password
and UserMaster.Status='True' 
and Node.Node_Status='True' 
and Group.Group_Status='True'*/ 

end





GO
/****** Object:  StoredProcedure [dbo].[USP_GetSubNode]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Rahul Arya>
-- Create date: <Create Date,23-11-2010>
-- Description:	<Used for Get the All Sub Node Value >
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetSubNode]
AS
(
select SubNode_Id,SubNode_Name from SubNode
)


GO
/****** Object:  StoredProcedure [dbo].[USP_GetSubNodeDetails]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Akhilesh Tiwari>
-- Create date: <Create Date,17-11-2010>
-- Description:	<Description,Used for display the nodes value and return the userid and nodeid>
-- =============================================
CREATE procedure [dbo].[USP_GetSubNodeDetails]
as
begin
select SubNode.SubNode_Id,SubNode.SubNode_Name,SubNode.path,SubNode.HelpText,SubNode.Url,
Node.Node_Name,SubNode.SubNode_Status,SubNode.CreationDate,SubNode.CreatedBy 
from SubNode,Node where SubNode.Node_Id=Node.Node_Id  and SubNode.Subnode_status='true'
order by Node.Node_Name,SubNode.SubNode_Name asc
end



GO
/****** Object:  StoredProcedure [dbo].[USP_GetSubNodeDetailsOnId]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Rahul Arya>
-- Create date: <Create Date,2-12-2010>
-- Description:	<Used for display the Subnodes value >
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetSubNodeDetailsOnId]
(
@SubNodeId numeric(18)
)
as
begin

SELECT     dbo.SubNode.SubNode_Name, dbo.Node.Node_Name, dbo.SubNode.Url, dbo.SubNode.SubNode_Status, 
                      dbo.SubNode.path, dbo.SubNode.HelpText
FROM         dbo.SubNode INNER JOIN
                      dbo.Node ON dbo.SubNode.Node_Id = dbo.Node.Node_Id WHERE     (dbo.SubNode.SubNode_Id = @SubNodeId) And SubNode_Status ='true'

end


GO
/****** Object:  StoredProcedure [dbo].[USP_GetSubNodeDetailsPrint]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Akhilesh Tiwari>
-- Create date: <Create Date,17-11-2010>
-- Description:	<Description,Used for display the nodes value and return the userid and nodeid>
-- =============================================
create procedure [dbo].[USP_GetSubNodeDetailsPrint]
as
begin
SELECT     dbo.SubNode.SubNode_Name, dbo.SubNode.path, dbo.SubNode.HelpText, dbo.SubNode.Url, 
                      dbo.Node.Node_Name, dbo.FormatDate(dbo.SubNode.CreationDate) AS CreationDate, dbo.SubNode.CreatedBy
FROM         dbo.SubNode CROSS JOIN
                      dbo.Node where SubNode.Node_Id=Node.Node_Id  and SubNode.Subnode_status='true'
order by Node.Node_Name,SubNode.SubNode_Name asc
end



GO
/****** Object:  StoredProcedure [dbo].[USP_GetSubNodeIcons]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







-- =============================================
-- Author:		<Simran Kaur>
-- Create date: <Create Date,01-12-2010>
-- Description:	<Used for Get the Icons>
-- =============================================
create PROCEDURE [dbo].[USP_GetSubNodeIcons]
(
@Uid as numeric(18),
@SubnodeName varchar(50)

)

AS
Begin
--SELECT   path, HelpText,Url,Node_Id
--FROM         dbo.SubNode where SubNode_Status='true'and Node_Id=@Node_Id and CreatedBy=@CreatedBy 



SELECT   dbo.SubNode.path, dbo.SubNode.HelpText,dbo.SubNode.Url, dbo.Rights.Right_Id
FROM         dbo.SubNode INNER JOIN
                      dbo.Rights ON dbo.SubNode.SubNode_Id = dbo.Rights.SubNode_Id
WHERE     (dbo.Rights.User_Id = @Uid) AND (dbo.SubNode.SubNode_Name = @SubnodeName) AND (dbo.Rights.Status = 'True') AND 
                      (dbo.SubNode.SubNode_Status = 'True')

end




GO
/****** Object:  StoredProcedure [dbo].[USP_GetSubNodeonNode]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Rahul Arya>
-- Create date: <Create Date,23-11-2010>
-- Description:	<Used for Get the All Sub Node Value >
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetSubNodeonNode]
(@NodeId int)
AS
(
select SubNode_Id,SubNode_Name from SubNode where Node_Id=@NodeId
)


GO
/****** Object:  StoredProcedure [dbo].[USP_GetSubNodeSelectedValue]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Rahul Arya>
-- Create date: <Create Date,6-12-2010>
-- Description:	<Used for Get the SubNode Selected Value>
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetSubNodeSelectedValue]
(
 @UserId int
)

As
select Rights.Right_Id,SubNode.SubNode_Id,Rights.Status,UserMaster.User_Name,UserMaster.User_Id,
SubNode.SubNode_Name,Rights.CreationDate,Rights.CreatedBy, [Group].Group_Name from Rights,SubNode,UserMaster,[Group] 
where Rights.User_Id=UserMaster.User_Id and 
Rights.SubNode_Id=SubNode.SubNode_Id and UserMaster.Group_Id=[Group].Group_Id and Rights.Status='True'
 and UserMaster.Status='True' and [Group].Group_Status='True' and Rights.status='true' and UserMaster.User_Id = @UserId and
 SubNode.SubNode_Status='True' order by UserMaster.User_Name,SubNode.SubNode_Name asc 

GO
/****** Object:  StoredProcedure [dbo].[USP_GetSubNodeValues]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Akhilesh Tiwari>
-- Create date: <Create Date,17-11-2010>
-- Description:	<Description,Used for display the subnodes according to the user rights>
-- =============================================
CREATE procedure [dbo].[USP_GetSubNodeValues](@Uid as numeric(18),@NodeId as numeric(18))
as
begin
 Select SubNode_Name,Url,SortOrder from SubNode,Rights where SubNode.SubNode_Id=Rights.SubNode_Id 
and Rights.User_Id=@Uid  and  SubNode.Node_Id =@NodeId
and Rights.Status='True' 
and SubNode.SubNode_Status='True' order by SubNode.SortOrder
end



GO
/****** Object:  StoredProcedure [dbo].[USP_GetUserDetails]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Akhilesh Tiwari>
-- Create date: <Create Date,17-11-2010,>
-- Description:	<Description, used for get the user details at login time,>
-- =============================================
--exec [USP_GetUserDetails] 'admin','1234456'
CREATE procedure [dbo].[USP_GetUserDetails](@LoginId as varchar(20),@Password as varchar(10))
as
begin
  select UserMaster.USer_Id,UserMaster.USer_Name,UserMaster.Email,Contact_Number,UserMaster.Login_Id,UserMaster.Group_Id from UserMaster  where  UserMaster.Login_Id=@LoginId and UserMaster.Password=@Password and UserMaster.Status=1
end


GO
/****** Object:  StoredProcedure [dbo].[USP_GetUserIcon]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Rahul Arya>
-- Create date: <Create Date,23-11-2010>
-- Description:	<Used for Get the All Sub Node Value >
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetUserIcon]
(@UName varchar(50))
AS
(
SELECT     dbo.SubNode.SubNode_Id, dbo.SubNode.SubNode_Name, dbo.SubNode.Node_Id, dbo.SubNode.Url, 
                      dbo.SubNode.path, dbo.SubNode.SubNode_Status, dbo.SubNode.HelpText, dbo.SubNode.CreatedBy
FROM         dbo.UserMaster INNER JOIN
                      dbo.SubNode ON dbo.UserMaster.User_Name = dbo.SubNode.CreatedBy 
where dbo.UserMaster.User_Name=@UName)


GO
/****** Object:  StoredProcedure [dbo].[usp_PageGet]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[usp_PageGet]
as

SELECT [PageID]
      ,[PageName]
      ,c.[Status]
	  ,c.CreatedBy CreatedByID
      ,u.User_Name as CreatedBy
      ,c.[CreatedOn]
	  ,c.UpdatedBy UpdatedByID
      ,u1.User_Name as UpdatedBy
      ,c.[UpdatedOn]
  FROM [dbo].tblPageMaster c 
  inner join UserMaster u on u.User_Id=c.[CreatedBy]
  left join UserMaster u1 on u1.User_Id=c.[UpdatedBy]


GO
/****** Object:  StoredProcedure [dbo].[usp_PageGetbyID]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create proc [dbo].[usp_PageGetbyID](@PageMasterID int)
as

SELECT [PageID]
      ,[PageName]
      ,c.[Status]
	  ,c.CreatedBy CreatedByID
      ,u.User_Name as CreatedBy
      ,c.[CreatedOn]
	  ,c.UpdatedBy UpdatedByID
      ,u1.User_Name as UpdatedBy
      ,c.[UpdatedOn]
  FROM [dbo].[tblPageMaster] c 
  inner join UserMaster u on u.User_Id=c.[CreatedBy]
  left join UserMaster u1 on u1.User_Id=c.[UpdatedBy]
  where [PageID]=@PageMasterID


GO
/****** Object:  StoredProcedure [dbo].[usp_PageGetList]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[usp_PageGetList]
as

SELECT [PageID]
      ,[PageName]
     
  FROM [dbo].tblPageMaster c 
 where Status=1
 order by 2


GO
/****** Object:  StoredProcedure [dbo].[usp_PageImmagesInsert]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_PageImmagesInsert]
(
@ImageURL varchar(100),
           @DisplayOrder int,
           @PageID int,
           
           @CreatedBy int
)
as


INSERT INTO [dbo].[tblPageImages]
           ([ImageURL]
           ,[DisplayOrder]
           ,[PageID]
           
           
           ,[CreatedBy])
     VALUES
           (@ImageURL,@DisplayOrder,@PageID,@CreatedBy)
		   if(@@ROWCOUNT>0)
		   select 1
		   else
		   select 0

GO
/****** Object:  StoredProcedure [dbo].[usp_PageInsert]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[usp_PageInsert]
(@PageName varchar(100)
              ,@CreatedBy int)
as


if(not exists(select * from [tblPageMaster] where [PageName]=@PageName))
begin
INSERT INTO [dbo].[tblPageMaster]
           ([PageName]
                      ,[CreatedBy]
           )
     VALUES
           (@PageName,@CreatedBy
		   
           )
select 1
end
else
select 0

GO
/****** Object:  StoredProcedure [dbo].[usp_PageUpdate]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[usp_PageUpdate]
(@PageID int,@PageName varchar(100),@UpdatedBy int, @status bit)
as

if(exists(select * from tblPageMaster where PageID=@PageID))
begin

UPDATE [dbo].tblPageMaster
   SET [PageName] = @PageName
      ,[Status] =@status
   
      ,[UpdatedBy] = @UpdatedBy
      ,[UpdatedOn] = getdate()
 WHERE PageID=@PageID
 select 1

end
else
select 0
GO
/****** Object:  StoredProcedure [dbo].[usp_ServiceGet]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_ServiceGet]
as


SELECT ServiceID
      ,[Description]
	  ,c1.CategoryName
	  ,c1.CategoryID
      ,c.[Status]
	  ,c.CreatedBy CreatedByID
      ,u.User_Name as CreatedBy
      ,c.[CreatedOn]
	  ,c.UpdatedBy UpdatedByID
      ,u1.User_Name as UpdatedBy
      ,c.[UpdatedOn]
  FROM [dbo].tblService c 
  left join tblCategory c1 on c.CategoryId=c1.CategoryID
  inner join UserMaster u on u.User_Id=c.[CreatedBy]
  left join UserMaster u1 on u1.User_Id=c.[UpdatedBy]
GO
/****** Object:  StoredProcedure [dbo].[usp_ServiceGetbyID]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec [usp_PageGetbyID] 1
CREATE proc [dbo].[usp_ServiceGetbyID](@ServiceID int)
as

SELECT ServiceID
      ,[Description]
	  ,c1.CategoryName
	  ,c1.CategoryID
      ,c.[Status]
	  ,c.CreatedBy CreatedByID
      ,u.User_Name as CreatedBy
      ,c.[CreatedOn]
	  ,c.UpdatedBy UpdatedByID
      ,u1.User_Name as UpdatedBy
      ,c.[UpdatedOn]
  FROM [dbo].tblService c 
  inner join tblCategory c1 on c.CategoryId=c1.CategoryID
  inner join UserMaster u on u.User_Id=c.[CreatedBy]
  left join UserMaster u1 on u1.User_Id=c.[UpdatedBy]
  where ServiceID=@ServiceID


GO
/****** Object:  StoredProcedure [dbo].[usp_ServiceInsert]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[usp_ServiceInsert]
(@Description varchar(100)
              ,@CreatedBy int
			  ,@categoryid int)
as


if(not exists(select * from tblService where Description=@Description))
begin
INSERT INTO [dbo].tblService
           (Description,CategoryId
                      ,[CreatedBy]
           )
     VALUES
           (@Description,@CategoryId,@CreatedBy
		   
           )
select 1
end
else
select 0

GO
/****** Object:  StoredProcedure [dbo].[usp_ServiceUpdate]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_ServiceUpdate]
(@ServiceID int,@Description varchar(100),@UpdatedBy int, @status bit,@categoryid int)
as

if(exists(select * from tblService where ServiceID=@ServiceID))
begin

UPDATE [dbo].tblService
   SET Description = @Description
      ,[Status] =@status
   ,CategoryId=@categoryid
      ,[UpdatedBy] = @UpdatedBy
      ,[UpdatedOn] = getdate()
 WHERE ServiceID=@ServiceID
 select 1

end
else
select 0
GO
/****** Object:  StoredProcedure [dbo].[usp_tblBlogContentGet]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_tblBlogContentGet]


as


SELECT [ID]
      ,p.[pageid]
	  ,p1.PageName
      ,[Title]
      ,[Keywords]
      ,[KeywordDesc]
      ,[Pageh1]
      ,BlogContent
      ,p.[Status]
      ,p.[CreatedBy] CreatedByID
	  ,u.User_Name as CreatedBy
      ,p.[CreatedOn]
      ,p.[UpdatedBy] UpdatedByID
	   ,u1.User_Name as UpdatedBy
      ,p.[UpdatedOn]
	  ,p.displayorder
  FROM [dbo].[tblBlogContent] p
  left join tblPageMaster p1 on p1.PageID=p.pageid
  inner join UserMaster u on u.User_Id=p.[CreatedBy]
  left join UserMaster u1 on u1.User_Id=p.[UpdatedBy]
  

GO
/****** Object:  StoredProcedure [dbo].[usp_tblBlogContentGetID]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_tblBlogContentGetID]
(@ID int)

as


SELECT [ID]
      ,p.[pageid]
	  ,p1.PageName
      ,[Title]
      ,[Keywords]
      ,[KeywordDesc]
      ,[Pageh1]
      ,BlogContent
      ,p.[Status]
      ,p.[CreatedBy] CreatedByID
	  ,u.User_Name as CreatedBy
      ,p.[CreatedOn]
      ,p.[UpdatedBy] UpdatedByID
	   ,u1.User_Name as UpdatedBy
      ,p.[UpdatedOn]
	  ,p.displayorder
  FROM [dbo].[tblBlogContent] p
  left join tblPageMaster p1 on p1.PageID=p.pageid
  inner join UserMaster u on u.User_Id=p.[CreatedBy]
  left join UserMaster u1 on u1.User_Id=p.[UpdatedBy]
  where p.Status=1 and ID=@ID

GO
/****** Object:  StoredProcedure [dbo].[usp_tblBlogContentInsert]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_tblBlogContentInsert]
(@pageid int,
           @Title varchar(100)
           ,@Keywords varchar(500)
           ,@KeywordDesc varchar(max)
           ,@Pageh1 varchar(500)
           ,@BlogContent varchar(max)
            ,          @CreatedBy int
			,@displayorder int
 )
as


INSERT INTO [dbo].[tblBlogContent]
           ([pageid]
           ,[Title]
           ,[Keywords]
           ,[KeywordDesc]
           ,[Pageh1]
           ,BlogContent
           ,displayorder
           ,[CreatedBy]
           )
     VALUES
           (@pageid 
           ,@Title 
           ,@Keywords 
           ,@KeywordDesc 
           ,@Pageh1 
           ,@BlogContent
		   ,@displayorder
            ,@CreatedBy 
           )

GO
/****** Object:  StoredProcedure [dbo].[usp_tblBlogContentUpdate]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_tblBlogContentUpdate](@id int,@pageid int,
           @Title varchar(100)
           ,@Keywords varchar(500)
           ,@KeywordDesc varchar(max)
           ,@Pageh1 varchar(500)
           ,@BlogContent varchar(max)
            ,          @UpdatedBy int,@Status bit
			,@displayorder int
			)
as
if(exists(select * from tblBlogContent where id=@id))
UPDATE [dbo].[tblBlogContent]
   SET [pageid] = @pageid
      ,[Title] = @Title
      ,[Keywords] = @Keywords
      ,[KeywordDesc] = @KeywordDesc
      ,[Pageh1] = @Pageh1
      ,BlogContent = @BlogContent
      ,[Status] = @Status
     ,displayorder=@displayorder
      ,[UpdatedBy] = @UpdatedBy
      ,[UpdatedOn] = getdate()
 WHERE id=@id
 

GO
/****** Object:  StoredProcedure [dbo].[usp_tblPageContentGet]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_tblPageContentGet]

as


SELECT [ID]
      ,p.[pageid]
	  ,p1.PageName
      ,[Title]
      ,[Keywords]
      ,[KeywordDesc]
      ,[Pageh1]
      ,[pagecontent]
      ,p.[Status]
      ,p.[CreatedBy] CreatedByID
	  ,u.User_Name as CreatedBy
      ,p.[CreatedOn]
      ,p.[UpdatedBy] UpdatedByID
	   ,u1.User_Name as UpdatedBy
      ,p.[UpdatedOn]
	  ,p.displayorder
  FROM [dbo].[tblPageContent] p
  left join tblPageMaster p1 on p1.PageID=p.pageid
  inner join UserMaster u on u.User_Id=p.[CreatedBy]
  left join UserMaster u1 on u1.User_Id=p.[UpdatedBy]
  where p.Status=1

GO
/****** Object:  StoredProcedure [dbo].[usp_tblPageContentGetID]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_tblPageContentGetID]
(@ID int)

as


SELECT [ID]
      ,p.[pageid]
	  ,p1.PageName
      ,[Title]
      ,[Keywords]
      ,[KeywordDesc]
      ,[Pageh1]
      ,[pagecontent]
      ,p.[Status]
      ,p.[CreatedBy] CreatedByID
	  ,u.User_Name as CreatedBy
      ,p.[CreatedOn]
      ,p.[UpdatedBy] UpdatedByID
	   ,u1.User_Name as UpdatedBy
      ,p.[UpdatedOn]
	  ,p.displayorder
  FROM [dbo].[tblPageContent] p
  left join tblPageMaster p1 on p1.PageID=p.pageid
  inner join UserMaster u on u.User_Id=p.[CreatedBy]
  left join UserMaster u1 on u1.User_Id=p.[UpdatedBy]
  where p.Status=1 and ID=@ID

GO
/****** Object:  StoredProcedure [dbo].[usp_tblPageContentInsert]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_tblPageContentInsert]
(@pageid int,
           @Title varchar(100)
           ,@Keywords varchar(500)
           ,@KeywordDesc varchar(max)
           ,@Pageh1 varchar(500)
           ,@pagecontent varchar(max)
		   ,@displayorder int
            ,          @CreatedBy int
 )
as


INSERT INTO [dbo].[tblPageContent]
           ([pageid]
           ,[Title]
           ,[Keywords]
           ,[KeywordDesc]
           ,[Pageh1]
           ,[pagecontent]
           ,displayorder
           ,[CreatedBy]
           )
     VALUES
           (@pageid 
           ,@Title 
           ,@Keywords 
           ,@KeywordDesc 
           ,@Pageh1 
           ,@pagecontent
		   ,@displayorder 
            ,@CreatedBy 
           )

select 1
GO
/****** Object:  StoredProcedure [dbo].[usp_tblPageContentUpdate]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_tblPageContentUpdate](@id int,@pageid int,
           @Title varchar(100)
           ,@Keywords varchar(500)
           ,@KeywordDesc varchar(max)
           ,@Pageh1 varchar(500)
           ,@pagecontent varchar(max)
		   ,@displayorder int
            ,          @UpdatedBy int,@Status bit)
as
if(exists(select * from tblPageContent where id=@id))
UPDATE [dbo].[tblPageContent]
   SET [pageid] = @pageid
      ,[Title] = @Title
      ,[Keywords] = @Keywords
      ,[KeywordDesc] = @KeywordDesc
      ,[Pageh1] = @Pageh1
      ,[pagecontent] = @pagecontent
      ,[Status] = @Status
     ,displayorder=@displayorder
      ,[UpdatedBy] = @UpdatedBy
      ,[UpdatedOn] = getdate()
 WHERE id=@id
 select 1
 

GO
/****** Object:  StoredProcedure [dbo].[usp_tblPageImagesGet]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[usp_tblPageImagesGet]
as

SELECT [Imageid]
      ,[ImageURL]
      ,[DisplayOrder]
      ,p.[PageID]
	  ,p1.PageName
      ,p.[status]
      
	  ,p.[CreatedBy] CreatedByID
	  ,u.User_Name as CreatedBy
      ,p.[CreatedOn]
      ,p.[UpdatedBy] UpdatedByID
	   ,u1.User_Name as UpdatedBy,
	   p.UpdatedOn
  FROM [dbo].[tblPageImages] p
  inner join tblPageMaster p1 on p1.PageID=p.pageid
   inner join UserMaster u on u.User_Id=p.[CreatedBy]
  left join UserMaster u1 on u1.User_Id=p.[UpdatedBy]


GO
/****** Object:  StoredProcedure [dbo].[usp_tblPageImagesGetbyID]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_tblPageImagesGetbyID]
(@Imageid int)
as

SELECT [Imageid]
      ,isnull([ImageURL],'') ImageURL
      ,[DisplayOrder]
      ,p.[PageID]
	  ,p1.PageName
      ,p.[status]
      
	  ,p.[CreatedBy] CreatedByID
	  ,u.User_Name as CreatedBy
      ,p.[CreatedOn]
      ,p.[UpdatedBy] UpdatedByID
	   ,u1.User_Name as UpdatedBy,
	   p.UpdatedOn
  FROM [dbo].[tblPageImages] p
  inner join tblPageMaster p1 on p1.PageID=p.pageid
   inner join UserMaster u on u.User_Id=p.[CreatedBy]
  left join UserMaster u1 on u1.User_Id=p.[UpdatedBy]
  where Imageid=@Imageid

GO
/****** Object:  StoredProcedure [dbo].[usp_tblPageImagesInsert]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[usp_tblPageImagesInsert]
(		   @ImageURL varchar(100),
           @DisplayOrder int,
           @PageID int,
           
           @CreatedBy int)

		   as

INSERT INTO [dbo].[tblPageImages]
           (
		   [ImageURL]
           ,[DisplayOrder]
           ,[PageID]
           ,[CreatedBy]
           )
     VALUES
           (
		   @ImageURL,
		   @DisplayOrder
		   ,@PageID
		   ,@CreatedBy
		   )

		   select 1

GO
/****** Object:  StoredProcedure [dbo].[usp_tblPageImagesUpdate]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[usp_tblPageImagesUpdate]
(@Imageid int,@ImageURL varchar(100),
           @DisplayOrder int,
           @PageID int,
           @status bit
           ,@UpdatedBy int
)

as

if(exists(select * from [tblPageImages] WHERE Imageid=@Imageid))
begin
UPDATE [dbo].[tblPageImages]
   SET [ImageURL] = @ImageURL
      ,[DisplayOrder] = @DisplayOrder
      ,[PageID] = @PageID
      ,[status] = @status
      ,UpdatedBy=@UpdatedBy
	  ,UpdatedOn=getdate()
 WHERE Imageid=@Imageid
 select 1
 end
 else
 select 0
GO
/****** Object:  StoredProcedure [dbo].[usp_tblPageMasterListGet]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[usp_tblPageMasterListGet](@Status int)
as

SELECT [PageID]
      ,[PageName]
 
  FROM [dbo].[tblPageMaster]
  where [Status]=@Status

GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateNode]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Akhilesh Tiwari>
-- Create date: <Create Date,20-11-2010>
-- Description:	
-- This stored procedure will update a table record 
-- based on the passed in primary key value.  
-- =============================================
CREATE procedure [dbo].[USP_UpdateNode]

	@pk_NodeId numeric(18),
    @p_NodeName varchar(50),
    @p_Status bit
  
as
declare @NodeName1  varchar(50)  
--select @NodeName1=Node_Name from [Node] where Node_Name= @p_NodeName
--if(@NodeName1<>@p_NodeName)
    
            -- Update the record with the passed parameters
            UPDATE [Node]
            SET 
            [Node_Name] = @p_NodeName,
            [Node_Status] = @p_Status
            WHERE [Node_Id] = @pk_NodeId




GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateSubNode]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Akhilesh Tiwari>
-- Create date: <Create Date,20-11-2010>
-- Description:	
-- This stored procedure will update a table record 
-- based on the passed in primary key value.  Concurreny
-- is supported by using checksum method.
-- =============================================
CREATE procedure [dbo].[USP_UpdateSubNode]

	@pk_SubNodeId numeric(18),
    @p_SubNodeName varchar(50),
	@p_NodeId numeric(18),
	@p_Url nvarchar(100),
    @path varchar(200),
    @HelpText varchar(50),
    @p_Status bit
    
as
--declare @SubNodeName1  varchar(100)  
--select @SubNodeName1=SubNode_Name from [SubNode] where SubNode_Name=@p_SubNodeName
--if(@SubNodeName1<>@p_SubNodeName)

            -- Update the record with the passed parameters
            UPDATE [SubNode]
            SET 
            [SubNode_Name] = @p_SubNodeName,
			[Node_Id] = @p_NodeId,
			[Url] = @p_Url,
            [path]=@path,
            [HelpText]=@HelpText,
            [SubNode_Status] = @p_Status
            WHERE [SubNode_Id] = @pk_SubNodeId

           





GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateUser]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Akhilesh Tiwari>
-- Create date: <Create Date,20-11-2010>
-- Description:	
-- This stored procedure will update a table record 
-- based on the passed in primary key value.  Concurreny
-- is supported by using checksum method.
-- =============================================
CREATE procedure [dbo].[USP_UpdateUser]

	@pk_UserId numeric(18),
    @p_UserName varchar(100),
    @Company_Id int,
	@p_Email nvarchar(100),
	@p_ContactNo nvarchar(15),
	@p_Password nvarchar(10),
    @Branch_Id int,
	@p_GroupId numeric(18),
    @p_Status bit
    
AS

BEGIN

            -- Update the record with the passed parameters
            UPDATE [UserMaster]
            SET 
            [User_Name] = @p_UserName,
            [Company_Id]=@Company_Id,
			[Email] = @p_Email,
            [Contact_Number] = @p_ContactNo,
			[Password] = @p_Password,
            [Branch_Id]=@Branch_Id,
			[Group_Id] = @p_GroupId,
			[Status] = @p_Status
            WHERE [User_Id] = @pk_UserId

           
END



GO
/****** Object:  Table [dbo].[Group]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Group](
	[Group_Id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[Group_Name] [nvarchar](50) NOT NULL,
	[GroupType] [int] NULL,
	[RedirectUrl] [nvarchar](100) NULL,
	[Group_Status] [bit] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Node]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Node](
	[Node_Id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[Node_Name] [varchar](50) NOT NULL,
	[Node_Status] [bit] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](100) NULL,
	[SequenceID] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Rights]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Rights](
	[Right_Id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[User_Id] [numeric](18, 0) NOT NULL,
	[SubNode_Id] [numeric](18, 0) NOT NULL,
	[Status] [bit] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SubNode]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SubNode](
	[SubNode_Id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[SubNode_Name] [varchar](50) NOT NULL,
	[Node_Id] [numeric](18, 0) NOT NULL,
	[Url] [nvarchar](100) NULL,
	[SubNode_Status] [bit] NOT NULL,
	[path] [varchar](200) NULL,
	[HelpText] [varchar](50) NULL,
	[SortOrder] [int] NULL,
	[CreationDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBlogContent]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBlogContent](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[pageid] [int] NULL,
	[Title] [varchar](100) NULL,
	[Keywords] [varchar](500) NULL,
	[KeywordDesc] [varchar](max) NULL,
	[Pageh1] [varchar](500) NULL,
	[BlogContent] [varchar](max) NULL,
	[displayorder] [int] NULL,
	[Status] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCategory]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCategory](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [varchar](100) NULL,
	[Status] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_tblCategory] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblPageContent]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblPageContent](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[pageid] [int] NOT NULL,
	[Title] [varchar](100) NULL,
	[Keywords] [varchar](500) NULL,
	[KeywordDesc] [varchar](max) NULL,
	[Pageh1] [varchar](500) NULL,
	[pagecontent] [varchar](max) NULL,
	[displayorder] [int] NULL,
	[Status] [bit] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_tblPageContent] PRIMARY KEY CLUSTERED 
(
	[pageid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblPageImages]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblPageImages](
	[Imageid] [int] IDENTITY(1,1) NOT NULL,
	[ImageURL] [varchar](100) NULL,
	[DisplayOrder] [int] NULL,
	[PageID] [int] NULL,
	[status] [bit] NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_tblPageImages] PRIMARY KEY CLUSTERED 
(
	[Imageid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblPageMaster]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblPageMaster](
	[PageID] [int] IDENTITY(1,1) NOT NULL,
	[PageName] [varchar](100) NULL,
	[Status] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_PageName] PRIMARY KEY CLUSTERED 
(
	[PageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblService]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblService](
	[ServiceID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL,
	[CategoryId] [int] NULL,
	[Status] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_tblService] PRIMARY KEY CLUSTERED 
(
	[ServiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserMaster]    Script Date: 5/27/2018 12:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserMaster](
	[User_Id] [int] IDENTITY(1,1) NOT NULL,
	[User_Name] [varchar](100) NOT NULL,
	[Address] [varchar](200) NULL,
	[Email] [varchar](100) NULL,
	[Contact_Number] [varchar](50) NULL,
	[Login_Id] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[Group_Id] [int] NULL,
	[Company_Id] [bigint] NULL,
	[CreationDate] [datetime] NOT NULL,
	[Status] [bit] NOT NULL,
	[CreatedBy] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tblBlogContent] ON 

GO
INSERT [dbo].[tblBlogContent] ([ID], [pageid], [Title], [Keywords], [KeywordDesc], [Pageh1], [BlogContent], [displayorder], [Status], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (1, 2, NULL, N'admin, controller', N'this is test', N'h1 for page', N'<p>hare krishna hare ram</p>', 1, 1, 1, CAST(0x0000A8EC0182B985 AS DateTime), 2, CAST(0x0000A8EC0182EFCE AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[tblBlogContent] OFF
GO
SET IDENTITY_INSERT [dbo].[tblCategory] ON 

GO
INSERT [dbo].[tblCategory] ([CategoryID], [CategoryName], [Status], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (1, N'Maths Senior Secondary', 0, 1, CAST(0x0000A8EB01275603 AS DateTime), 1, CAST(0x0000A8EB01333FEA AS DateTime))
GO
INSERT [dbo].[tblCategory] ([CategoryID], [CategoryName], [Status], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (2, N'Phyiscs', 1, 1, CAST(0x0000A8EB0127641B AS DateTime), 1, CAST(0x0000A8EB013A0079 AS DateTime))
GO
INSERT [dbo].[tblCategory] ([CategoryID], [CategoryName], [Status], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (4, N'Biology', 1, 1, CAST(0x0000A8EB0137BF36 AS DateTime), 1, CAST(0x0000A8EB013D680C AS DateTime))
GO
INSERT [dbo].[tblCategory] ([CategoryID], [CategoryName], [Status], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (5, N' Science', 1, 1, CAST(0x0000A8EB01393674 AS DateTime), NULL, NULL)
GO
INSERT [dbo].[tblCategory] ([CategoryID], [CategoryName], [Status], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (6, N'Mechnaical Drawing', 1, 1, CAST(0x0000A8EB013B831C AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[tblCategory] OFF
GO
SET IDENTITY_INSERT [dbo].[tblPageContent] ON 

GO
INSERT [dbo].[tblPageContent] ([ID], [pageid], [Title], [Keywords], [KeywordDesc], [Pageh1], [pagecontent], [displayorder], [Status], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (1, 2, N'page1 admin', N'admin, controller', N'this is test', N'h1 for page', N'this is content of a page', 3, 1, 1, CAST(0x0000A8EC01738AAB AS DateTime), 1, CAST(0x0000A8EC0175205D AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[tblPageContent] OFF
GO
SET IDENTITY_INSERT [dbo].[tblPageImages] ON 

GO
INSERT [dbo].[tblPageImages] ([Imageid], [ImageURL], [DisplayOrder], [PageID], [status], [CreatedOn], [CreatedBy], [UpdatedBy], [UpdatedOn]) VALUES (1, N'~/Images/d8d3e477-2c99-48e4-9003-a4a3dd891d00.jpg', 1, 3, 1, NULL, 1, 1, CAST(0x0000A8ED00BCE636 AS DateTime))
GO
INSERT [dbo].[tblPageImages] ([Imageid], [ImageURL], [DisplayOrder], [PageID], [status], [CreatedOn], [CreatedBy], [UpdatedBy], [UpdatedOn]) VALUES (2, N'', 5, 2, 1, CAST(0x0000A8EC012B851E AS DateTime), 1, 1, CAST(0x0000A8EC0141B55D AS DateTime))
GO
INSERT [dbo].[tblPageImages] ([Imageid], [ImageURL], [DisplayOrder], [PageID], [status], [CreatedOn], [CreatedBy], [UpdatedBy], [UpdatedOn]) VALUES (3, N'', 45, 3, 1, CAST(0x0000A8EC012CCC24 AS DateTime), 1, 1, CAST(0x0000A8EC01440174 AS DateTime))
GO
INSERT [dbo].[tblPageImages] ([Imageid], [ImageURL], [DisplayOrder], [PageID], [status], [CreatedOn], [CreatedBy], [UpdatedBy], [UpdatedOn]) VALUES (4, N'~/Images/e786c851-9cef-4069-a378-5e764a9944ff.jpg', 12, 3, 1, CAST(0x0000A8EC013E81F3 AS DateTime), 1, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[tblPageImages] OFF
GO
SET IDENTITY_INSERT [dbo].[tblPageMaster] ON 

GO
INSERT [dbo].[tblPageMaster] ([PageID], [PageName], [Status], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (1, N'Home Page', 0, 1, CAST(0x0000A8EB015B898E AS DateTime), 1, CAST(0x0000A8EB01631DAB AS DateTime))
GO
INSERT [dbo].[tblPageMaster] ([PageID], [PageName], [Status], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (2, N'admin Page', 1, 1, CAST(0x0000A8EB015E9248 AS DateTime), NULL, NULL)
GO
INSERT [dbo].[tblPageMaster] ([PageID], [PageName], [Status], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (3, N'Product', 1, 1, CAST(0x0000A8EB01609AD4 AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[tblPageMaster] OFF
GO
SET IDENTITY_INSERT [dbo].[tblService] ON 

GO
INSERT [dbo].[tblService] ([ServiceID], [Description], [CategoryId], [Status], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (1, N'this service related to Science', 5, NULL, 1, CAST(0x0000A8EB01832CFE AS DateTime), 1, CAST(0x0000A8EC00F0C337 AS DateTime))
GO
INSERT [dbo].[tblService] ([ServiceID], [Description], [CategoryId], [Status], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (2, N'ssss', 2, 1, 1, CAST(0x0000A8EB0188C7C2 AS DateTime), NULL, NULL)
GO
INSERT [dbo].[tblService] ([ServiceID], [Description], [CategoryId], [Status], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (3, N'bio test', 4, 1, 1, CAST(0x0000A8EC00BF181C AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[tblService] OFF
GO
SET IDENTITY_INSERT [dbo].[UserMaster] ON 

GO
INSERT [dbo].[UserMaster] ([User_Id], [User_Name], [Address], [Email], [Contact_Number], [Login_Id], [Password], [Group_Id], [Company_Id], [CreationDate], [Status], [CreatedBy]) VALUES (1, N'admin', NULL, N'admin@yahoo.com', N'9971655253', N'admin', N'123456', 1, 1, CAST(0x0000A8EA0128802D AS DateTime), 1, NULL)
GO
SET IDENTITY_INSERT [dbo].[UserMaster] OFF
GO
ALTER TABLE [dbo].[Group] ADD  CONSTRAINT [DF_Group_Group_Status]  DEFAULT ((1)) FOR [Group_Status]
GO
ALTER TABLE [dbo].[Group] ADD  CONSTRAINT [DF_Group_CreationDate]  DEFAULT (getdate()) FOR [CreationDate]
GO
ALTER TABLE [dbo].[Node] ADD  CONSTRAINT [DF_Node_Node_Status]  DEFAULT ((1)) FOR [Node_Status]
GO
ALTER TABLE [dbo].[Node] ADD  CONSTRAINT [DF_Node_CreationDate]  DEFAULT (getdate()) FOR [CreationDate]
GO
ALTER TABLE [dbo].[Rights] ADD  CONSTRAINT [DF_Rights_Status]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[Rights] ADD  CONSTRAINT [DF_Rights_CreationDate]  DEFAULT (getdate()) FOR [CreationDate]
GO
ALTER TABLE [dbo].[SubNode] ADD  CONSTRAINT [DF_SubNode_SubNode_Status]  DEFAULT ((1)) FOR [SubNode_Status]
GO
ALTER TABLE [dbo].[SubNode] ADD  CONSTRAINT [DF_SubNode_CreationDate]  DEFAULT (getdate()) FOR [CreationDate]
GO
ALTER TABLE [dbo].[tblBlogContent] ADD  CONSTRAINT [DF_tblBlogContent_Status]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[tblBlogContent] ADD  CONSTRAINT [DF_tblBlogContent_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[tblCategory] ADD  CONSTRAINT [DF_tblCategory_Status]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[tblCategory] ADD  CONSTRAINT [DF_tblCategory_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[tblPageContent] ADD  CONSTRAINT [DF_tblPageContent_Status]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[tblPageContent] ADD  CONSTRAINT [DF_tblPageContent_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[tblPageImages] ADD  CONSTRAINT [DF_tblPageImages_status]  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[tblPageImages] ADD  CONSTRAINT [DF_tblPageImages_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[tblPageMaster] ADD  CONSTRAINT [DF_PageName_Status]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[tblPageMaster] ADD  CONSTRAINT [DF_PageName_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[tblService] ADD  CONSTRAINT [DF_tblService_Status]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[tblService] ADD  CONSTRAINT [DF_tblService_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[UserMaster] ADD  CONSTRAINT [DF_UserMaster_CreationDate]  DEFAULT (getdate()) FOR [CreationDate]
GO
ALTER TABLE [dbo].[UserMaster] ADD  CONSTRAINT [DF_UserMaster_Status]  DEFAULT ((1)) FOR [Status]
GO
USE [master]
GO
ALTER DATABASE [OnlineTutors] SET  READ_WRITE 
GO
