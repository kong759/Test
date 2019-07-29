<%@page import="java.text.SimpleDateFormat"%>
<%@page import="board.BoardDataBean"%>
<%@page import="java.util.List"%>
<%@page import="board.BoardDBBeanMysql"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%
	request.setCharacterEncoding("euc-kr");
%>
<%
   if(request.getParameter("boardid")!=null){
      session.setAttribute("boardid", request.getParameter("boardid"));
   }
String boardid = (String)session.getAttribute("boardid");
if(boardid==null) boardid="1";
%>
   <%
   BoardDBBeanMysql dbPro = BoardDBBeanMysql.getInstance();
   int pageSize =3; //한 페이지에 3개씩
   
   String pageNum = request.getParameter("pageNum");
   if(pageNum == null || pageNum == ""){
	   pageNum = "1"; //url에 pageNum이 넘어가면 설정
   }
   int currentPage = Integer.parseInt(pageNum);
   int count = dbPro.getArticleCount(boardid);
   int startRow = ((currentPage-1)*pageSize);
   int endRow = currentPage*pageSize; 
   if(count<endRow){
      endRow=count;
   }
   int number = count -((currentPage - 1) * pageSize);
   
   List articleList =  dbPro.getArticles(startRow,pageSize,boardid);
   %>
   
   
   <div class="w3-container">
   <span class="w3-center w3-larger">
   <h3>(전체 글:<%=count %>)
   </h3>
   </span>
   <p class="w3-right w3-padding-right-large">
   <a href="writerForm.jsp?pageNum=<%=pageNum%>">글쓰기</a>
   </p>
   
   <%if(count==0){ %>
   <table class = "w3-table-all" width="700">
      <tr class="w3-grey">
         <td align="center" width="50">저장된 글이 없습니다.</td>
      </tr>
   </table>
   <%} else{ %>
   
   <table class = "w3-table-all" width="700">
      <tr class="w3-grey">
         <td align="center" width="50">번호</td>
         <td align="center" width="250">제 목</td>
         <td align="center" width="100">작성자</td>
         <td align="center" width="150">작성일</td>
         <td align="center" width="50">조 회</td>
         <td align="center" width="100">IP</td>
      </tr>
      <%   
         SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
         for(int i = 0 ;i<articleList.size();i++){
            BoardDataBean article = (BoardDataBean) articleList.get(i);
         %>
         <tr height="30">
            <td align="center" width="50"><%=(number--) %></td>
            <td align="center" width="250">
             <%
            if(article.getRe_level()>0){
               %><img src="<%=request.getContextPath()%>/images/level.gif"
               width="<%=5*article.getRe_level()%>" height="16">
               <img src="<%=request.getContextPath()%>/images/re.gif">
           <% 
            }
            %>
            <a href="content.jsp?num=<%=article.getNum() %>&pageNum=<%=pageNum%>"><%=article.getSubject() %></a>
            <%
            if(article.getReadcount() >= 5){
               %><img src="<%=request.getContextPath()%>/images/hot.gif"
               border="0" height="16">
           <%
            }
            %>
            <td align="center" width="100"><%=article.getWriter() %></td>
            <td align="center" width="150"><%=sdf.format(article.getReg_date()) %></td>
            <td align="center" width="50"><%=article.getReadcount() %></td>
            <td align="center" width="100"><%=article.getIp() %></td>
         </tr>
      <% }
      %>
      
   </table>
   <%
   		int bottomLine = 3;
   		int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
   		int startPage = 1 + (currentPage - 1) / bottomLine * bottomLine;
   		int endPage = startPage + bottomLine - 1;
   		if(endPage > pageCount) endPage = pageCount;
   
   %>
   
   <% if(startPage>bottomLine){ %><a href="list.jsp?pageNum=<%=startPage - bottomLine%>">[이전]</a> <%} %>
   
   <% for (int i= startPage; i <= endPage; i++){ %>
   <a href="list.jsp?pageNum=<%=i %> ">[<%=i %>]</a>
   <%} %>
   <% if(endPage<pageCount){%><a href="list.jsp?pageNum=<%=startPage + bottomLine%> ">[다음]</a> <%} %>
  
   <%} %>
   </div>
</body> 
수정했습니다. test branch
</html>