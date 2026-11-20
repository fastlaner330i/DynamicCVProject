<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%--
    View: friendly error page, registered in web.xml <error-page> for 404, 500 and any exception.
    (Form validation errors are shown on cvForm.jsp instead, with the inputs pre-filled.)
--%>
<%
    Integer statusCode = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
    boolean notFound = statusCode != null && statusCode == 404;

    String heading = notFound ? "Page not found" : "Something went wrong";
    String message = notFound
            ? "The page you are looking for does not exist or has been moved."
            : "We could not process your request. Please go back to the CV form and try again.";

    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>CV Builder - <%= heading %></title>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
</head>
<body class="flex min-h-screen items-center justify-center bg-forest-50/60 px-4 font-sans text-slate-800 antialiased">

<main class="w-full max-w-lg overflow-hidden rounded-2xl bg-white text-center shadow-lg ring-1 ring-slate-200">
    <div class="bg-forest-900 px-8 py-8 text-white">
        <p class="text-5xl font-extrabold tracking-tight"><%= statusCode == null ? "Oops" : statusCode %></p>
        <h1 class="mt-2 text-lg font-semibold text-forest-100"><%= heading %></h1>
    </div>
    <div class="px-8 py-8">
        <p class="text-slate-600"><%= message %></p>
        <div class="mt-6 flex flex-col justify-center gap-3 sm:flex-row">
            <button type="button" onclick="history.back()"
                    class="rounded-lg border border-slate-300 bg-white px-5 py-2.5 font-medium hover:bg-slate-50">
                Go Back
            </button>
            <a href="<%= ctx %>/cvForm.jsp"
               class="rounded-lg bg-forest-800 px-5 py-2.5 font-semibold text-white shadow hover:bg-forest-900">
                Back to CV Form
            </a>
        </div>
    </div>
</main>

</body>
</html>
