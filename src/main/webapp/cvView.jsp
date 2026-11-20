<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.cvbuilder.model.CVBean, java.util.List" %>
<%@ include file="/WEB-INF/jspf/escape.jspf" %>
<%--
    View: renders the CVBean stored in request scope as "cvData".
    Used for both flows: user-submitted data (POST) and the sample template (GET ?action=sample).
    Layout is single-column with standard headings so Applicant Tracking Systems (ATS) can parse it.
    Scriptlets here only read and display data; no business logic.
--%>
<%!
    /** True when an optional value was filled in. */
    private boolean has(String value) {
        return value != null && !value.trim().isEmpty();
    }
%>
<%
    CVBean cv = (CVBean) request.getAttribute("cvData");
    boolean isSample = Boolean.TRUE.equals(request.getAttribute("isSample"));
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title><%= cv == null ? "CV Not Found" : esc(cv.getFullName()) + " - CV" %></title>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
</head>
<body class="min-h-screen bg-slate-200/70 font-sans text-slate-800 antialiased">

<% if (cv == null) { %>
    <%-- Page opened directly without going through the controller --%>
    <main class="mx-auto max-w-xl px-4 py-20 text-center">
        <h1 class="text-2xl font-bold text-forest-900">No CV data found</h1>
        <p class="mt-2 text-slate-600">Please fill in the form to generate your CV.</p>
        <a href="<%= ctx %>/cvForm.jsp"
           class="mt-6 inline-block rounded-lg bg-forest-800 px-5 py-2.5 font-semibold text-white hover:bg-forest-900">
            Go to CV Form
        </a>
    </main>
<% } else { %>

    <!-- Toolbar (screen only, hidden when printing) -->
    <div class="no-print mx-auto flex max-w-[210mm] flex-col gap-3 px-4 pt-6 sm:flex-row sm:items-center sm:justify-between sm:px-0">
        <% if (isSample) { %>
        <span class="inline-flex w-fit items-center rounded-full bg-amber-100 px-3 py-1 text-sm font-medium text-amber-800">
            Sample template &middot; generated with dummy data
        </span>
        <% } else { %>
        <span class="inline-flex w-fit items-center rounded-full bg-forest-100 px-3 py-1 text-sm font-medium text-forest-800">
            Your CV was generated successfully
        </span>
        <% } %>
        <div class="flex gap-3">
            <a href="<%= ctx %>/cvForm.jsp"
               class="rounded-lg border border-slate-300 bg-white px-4 py-2 text-sm font-medium hover:bg-slate-50">
                Back to Form
            </a>
            <button type="button" onclick="window.print()"
                    class="rounded-lg bg-forest-800 px-4 py-2 text-sm font-semibold text-white shadow hover:bg-forest-900">
                Print / Save as PDF
            </button>
        </div>
    </div>

    <!-- CV sheet (A4 width) -->
    <article class="cv-sheet mx-auto my-6 max-w-[210mm] bg-white shadow-xl">

        <!-- Name, title and contact details (kept in the body, not a page header, so ATS reads them) -->
        <header class="bg-forest-900 px-8 py-9 text-white sm:px-12">
            <h1 class="text-3xl font-extrabold tracking-tight sm:text-4xl"><%= esc(cv.getFullName()) %></h1>
            <% if (has(cv.getProfessionalTitle())) { %>
            <p class="mt-1 text-base font-semibold uppercase tracking-[0.2em] text-forest-200"><%= esc(cv.getProfessionalTitle()) %></p>
            <% } %>
            <p class="mt-4 flex flex-wrap gap-x-3 gap-y-1 text-sm text-forest-50">
                <span><%= esc(cv.getEmail()) %></span>
                <% if (has(cv.getPhone())) { %>
                <span class="text-forest-400">|</span>
                <span><%= esc(cv.getPhone()) %></span>
                <% } %>
                <% if (has(cv.getProfileUrl())) { %>
                <span class="text-forest-400">|</span>
                <a href="<%= esc(cv.getProfileUrl()) %>" target="_blank" rel="noopener"
                   class="break-all underline decoration-forest-400 underline-offset-2"><%= esc(cv.getProfileUrl()) %></a>
                <% } %>
            </p>
        </header>

        <div class="space-y-8 px-8 py-9 sm:px-12">

            <% if (has(cv.getProfileSummary())) { %>
            <section class="cv-section">
                <h2 class="mb-3 flex items-center gap-3 text-sm font-bold uppercase tracking-[0.2em] text-forest-800">
                    Professional Summary <span class="h-px flex-1 bg-forest-200"></span>
                </h2>
                <p class="whitespace-pre-line text-[15px] leading-relaxed text-slate-700"><%= esc(cv.getProfileSummary()) %></p>
            </section>
            <% } %>

            <% if (has(cv.getJobTitle()) || has(cv.getCompanyName())) { %>
            <section class="cv-section">
                <h2 class="mb-3 flex items-center gap-3 text-sm font-bold uppercase tracking-[0.2em] text-forest-800">
                    Work Experience <span class="h-px flex-1 bg-forest-200"></span>
                </h2>
                <div class="flex flex-col sm:flex-row sm:items-baseline sm:justify-between sm:gap-4">
                    <h3 class="text-base font-bold text-slate-900"><%= esc(cv.getJobTitle()) %></h3>
                    <% if (has(cv.getDuration())) { %>
                    <span class="text-sm font-medium text-slate-500"><%= esc(cv.getDuration()) %></span>
                    <% } %>
                </div>
                <p class="text-sm font-semibold text-forest-700"><%= esc(cv.getCompanyName()) %></p>
                <%
                    List<String> responsibilities = cv.getResponsibilitiesList();
                    if (!responsibilities.isEmpty()) {
                %>
                <ul class="mt-2 list-outside list-disc space-y-1 pl-5 text-[15px] leading-relaxed text-slate-700 marker:text-forest-500">
                    <% for (String item : responsibilities) { %>
                    <li><%= esc(item) %></li>
                    <% } %>
                </ul>
                <% } %>
            </section>
            <% } %>

            <section class="cv-section">
                <h2 class="mb-3 flex items-center gap-3 text-sm font-bold uppercase tracking-[0.2em] text-forest-800">
                    Education <span class="h-px flex-1 bg-forest-200"></span>
                </h2>
                <div class="flex flex-col sm:flex-row sm:items-baseline sm:justify-between sm:gap-4">
                    <h3 class="text-base font-bold text-slate-900"><%= esc(cv.getHighestDegree()) %></h3>
                    <% if (has(cv.getGraduationYear())) { %>
                    <span class="text-sm font-medium text-slate-500"><%= esc(cv.getGraduationYear()) %></span>
                    <% } %>
                </div>
                <% if (has(cv.getInstitution())) { %>
                <p class="text-sm font-semibold text-forest-700"><%= esc(cv.getInstitution()) %></p>
                <% } %>
                <% if (has(cv.getMajor())) { %>
                <p class="mt-1 text-[15px] text-slate-700">Major: <%= esc(cv.getMajor()) %></p>
                <% } %>
            </section>

            <section class="cv-section">
                <h2 class="mb-3 flex items-center gap-3 text-sm font-bold uppercase tracking-[0.2em] text-forest-800">
                    Skills <span class="h-px flex-1 bg-forest-200"></span>
                </h2>
                <%-- Plain comma-separated text: easiest format for ATS keyword matching --%>
                <p class="text-[15px] leading-relaxed text-slate-700">
                    <span class="font-semibold text-slate-900">Technical Skills:</span>
                    <%= esc(String.join(", ", cv.getTechnicalSkillsList())) %>
                </p>
                <% if (!cv.getSoftSkillsList().isEmpty()) { %>
                <p class="mt-1 text-[15px] leading-relaxed text-slate-700">
                    <span class="font-semibold text-slate-900">Soft Skills:</span>
                    <%= esc(String.join(", ", cv.getSoftSkillsList())) %>
                </p>
                <% } %>
            </section>
        </div>
    </article>

<% } %>

</body>
</html>
