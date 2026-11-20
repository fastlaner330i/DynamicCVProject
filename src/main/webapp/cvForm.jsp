<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.cvbuilder.model.CVBean, java.util.Map" %>
<%@ include file="/WEB-INF/jspf/escape.jspf" %>
<%--
    View: CV data entry form.
    - Submits with POST to CVServlet.
    - "Preview Sample CV" / "Generate Template" trigger GET CVServlet?action=sample.
    - When validation fails, CVServlet forwards back here with "cvData" (to pre-fill
      the inputs) and "errors" (field name -> message) in the request scope.
--%>
<%!
    private static final String INPUT_OK =
            "mt-1 w-full rounded-lg border border-slate-300 bg-white px-3 py-2 text-slate-900 "
            + "focus:border-forest-600 focus:outline-none focus:ring-2 focus:ring-forest-200";
    private static final String INPUT_BAD =
            "mt-1 w-full rounded-lg border border-red-500 bg-red-50 px-3 py-2 text-slate-900 "
            + "focus:border-red-600 focus:outline-none focus:ring-2 focus:ring-red-200";

    /** CSS classes for an input: red when that field has an error. */
    private String inputClass(CVBean cv, String field) {
        return cv.getError(field).isEmpty() ? INPUT_OK : INPUT_BAD;
    }

    /** Error message under a field, or nothing when the field is valid. */
    private String fieldError(CVBean cv, String field) {
        String message = cv.getError(field);
        return message.isEmpty() ? "" : "<p class=\"mt-1 text-xs font-medium text-red-600\">" + esc(message) + "</p>";
    }
%>
<%
    // Bean sent back by the controller after a failed validation; empty bean on first visit
    CVBean cv = (CVBean) request.getAttribute("cvData");
    if (cv == null) {
        cv = new CVBean();
    }

    @SuppressWarnings("unchecked")
    Map<String, String> errors = (Map<String, String>) request.getAttribute("errors");
    boolean hasErrors = errors != null && !errors.isEmpty();

    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>CV Builder - Create Your CV</title>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
</head>
<body class="min-h-screen bg-forest-50/60 font-sans text-slate-800 antialiased">

<header class="bg-forest-900 text-white">
    <div class="mx-auto flex max-w-4xl flex-col gap-4 px-4 py-7 sm:flex-row sm:items-center sm:justify-between">
        <div>
            <p class="text-xs font-semibold uppercase tracking-[0.25em] text-forest-300">CSC584 &middot; CV Builder</p>
            <h1 class="mt-1 text-2xl font-extrabold tracking-tight sm:text-3xl">Build your professional CV</h1>
            <p class="mt-1 text-sm text-forest-100">Fill in your details and generate a clean, ATS-friendly CV.</p>
        </div>
        <a href="<%= ctx %>/CVServlet?action=sample"
           class="inline-flex items-center justify-center rounded-lg border border-forest-300 px-4 py-2 text-sm font-semibold text-white hover:bg-forest-800">
            Preview Sample CV
        </a>
    </div>
</header>

<main class="mx-auto max-w-4xl px-4 py-8">

    <% if (hasErrors) { %>
    <div class="mb-6 rounded-xl border border-red-200 bg-red-50 p-5" role="alert">
        <h2 class="font-semibold text-red-800">Your CV could not be generated. Please correct the following:</h2>
        <ul class="mt-2 list-inside list-disc space-y-1 text-sm text-red-700">
            <% for (String message : errors.values()) { %>
            <li><%= esc(message) %></li>
            <% } %>
        </ul>
    </div>
    <% } %>

    <%-- novalidate: let the server-side CVBean.validate() do the checking --%>
    <form action="<%= ctx %>/CVServlet" method="post" novalidate class="space-y-6">

        <p class="text-sm text-slate-500">Fields marked <span class="font-bold text-red-600">*</span> are mandatory.</p>

        <!-- Personal Info -->
        <section class="rounded-2xl bg-white p-6 shadow-sm ring-1 ring-slate-200">
            <h2 class="mb-4 flex items-center gap-3 text-sm font-bold uppercase tracking-[0.18em] text-forest-800">
                Personal Information <span class="h-px flex-1 bg-forest-100"></span>
            </h2>
            <div class="grid gap-4 sm:grid-cols-2">
                <label class="block">
                    <span class="text-sm font-medium text-slate-700">Full Name <span class="text-red-600">*</span></span>
                    <input type="text" name="fullName" required maxlength="100"
                           value="<%= esc(cv.getFullName()) %>" class="<%= inputClass(cv, "fullName") %>">
                    <%= fieldError(cv, "fullName") %>
                </label>
                <label class="block">
                    <span class="text-sm font-medium text-slate-700">Professional Title</span>
                    <input type="text" name="professionalTitle" maxlength="100" placeholder="e.g. Software Engineer"
                           value="<%= esc(cv.getProfessionalTitle()) %>" class="<%= inputClass(cv, "professionalTitle") %>">
                </label>
                <label class="block">
                    <span class="text-sm font-medium text-slate-700">Email <span class="text-red-600">*</span></span>
                    <input type="email" name="email" required maxlength="100" placeholder="name@example.com"
                           value="<%= esc(cv.getEmail()) %>" class="<%= inputClass(cv, "email") %>">
                    <%= fieldError(cv, "email") %>
                </label>
                <label class="block">
                    <span class="text-sm font-medium text-slate-700">Phone Number</span>
                    <input type="tel" name="phone" maxlength="20" placeholder="+60 12-345 6789"
                           value="<%= esc(cv.getPhone()) %>" class="<%= inputClass(cv, "phone") %>">
                    <%= fieldError(cv, "phone") %>
                </label>
                <label class="block sm:col-span-2">
                    <span class="text-sm font-medium text-slate-700">LinkedIn / GitHub URL</span>
                    <input type="url" name="profileUrl" maxlength="200" placeholder="https://github.com/username"
                           value="<%= esc(cv.getProfileUrl()) %>" class="<%= inputClass(cv, "profileUrl") %>">
                    <%= fieldError(cv, "profileUrl") %>
                </label>
                <label class="block sm:col-span-2">
                    <span class="text-sm font-medium text-slate-700">Profile Summary</span>
                    <textarea name="profileSummary" rows="4" maxlength="1000"
                              placeholder="2-4 sentences about your strengths and career goals"
                              class="<%= inputClass(cv, "profileSummary") %>"><%= esc(cv.getProfileSummary()) %></textarea>
                </label>
            </div>
        </section>

        <!-- Education -->
        <section class="rounded-2xl bg-white p-6 shadow-sm ring-1 ring-slate-200">
            <h2 class="mb-4 flex items-center gap-3 text-sm font-bold uppercase tracking-[0.18em] text-forest-800">
                Education <span class="h-px flex-1 bg-forest-100"></span>
            </h2>
            <div class="grid gap-4 sm:grid-cols-2">
                <label class="block">
                    <span class="text-sm font-medium text-slate-700">Highest Degree <span class="text-red-600">*</span></span>
                    <input type="text" name="highestDegree" required maxlength="100" placeholder="e.g. Bachelor of Computer Science"
                           value="<%= esc(cv.getHighestDegree()) %>" class="<%= inputClass(cv, "highestDegree") %>">
                    <%= fieldError(cv, "highestDegree") %>
                </label>
                <label class="block">
                    <span class="text-sm font-medium text-slate-700">Institution Name</span>
                    <input type="text" name="institution" maxlength="100"
                           value="<%= esc(cv.getInstitution()) %>" class="<%= inputClass(cv, "institution") %>">
                </label>
                <label class="block">
                    <span class="text-sm font-medium text-slate-700">Year of Graduation</span>
                    <input type="text" name="graduationYear" inputmode="numeric" maxlength="4" placeholder="2026"
                           value="<%= esc(cv.getGraduationYear()) %>" class="<%= inputClass(cv, "graduationYear") %>">
                    <%= fieldError(cv, "graduationYear") %>
                </label>
                <label class="block">
                    <span class="text-sm font-medium text-slate-700">Major / Field</span>
                    <input type="text" name="major" maxlength="100"
                           value="<%= esc(cv.getMajor()) %>" class="<%= inputClass(cv, "major") %>">
                </label>
            </div>
        </section>

        <!-- Experience -->
        <section class="rounded-2xl bg-white p-6 shadow-sm ring-1 ring-slate-200">
            <h2 class="mb-4 flex items-center gap-3 text-sm font-bold uppercase tracking-[0.18em] text-forest-800">
                Most Recent Experience <span class="h-px flex-1 bg-forest-100"></span>
            </h2>
            <div class="grid gap-4 sm:grid-cols-2">
                <label class="block">
                    <span class="text-sm font-medium text-slate-700">Job Title</span>
                    <input type="text" name="jobTitle" maxlength="100"
                           value="<%= esc(cv.getJobTitle()) %>" class="<%= inputClass(cv, "jobTitle") %>">
                </label>
                <label class="block">
                    <span class="text-sm font-medium text-slate-700">Company Name</span>
                    <input type="text" name="companyName" maxlength="100"
                           value="<%= esc(cv.getCompanyName()) %>" class="<%= inputClass(cv, "companyName") %>">
                </label>
                <label class="block sm:col-span-2">
                    <span class="text-sm font-medium text-slate-700">Duration</span>
                    <input type="text" name="duration" maxlength="50" placeholder="e.g. Jan 2024 - Present"
                           value="<%= esc(cv.getDuration()) %>" class="<%= inputClass(cv, "duration") %>">
                </label>
                <label class="block sm:col-span-2">
                    <span class="text-sm font-medium text-slate-700">Key Responsibilities / Achievements</span>
                    <textarea name="responsibilities" rows="5" maxlength="2000"
                              placeholder="One item per line, start with an action verb (e.g. Developed, Improved, Led)"
                              class="<%= inputClass(cv, "responsibilities") %>"><%= esc(cv.getResponsibilities()) %></textarea>
                </label>
            </div>
        </section>

        <!-- Skills -->
        <section class="rounded-2xl bg-white p-6 shadow-sm ring-1 ring-slate-200">
            <h2 class="mb-4 flex items-center gap-3 text-sm font-bold uppercase tracking-[0.18em] text-forest-800">
                Skills <span class="h-px flex-1 bg-forest-100"></span>
            </h2>
            <div class="grid gap-4">
                <label class="block">
                    <span class="text-sm font-medium text-slate-700">Technical Skills <span class="text-red-600">*</span></span>
                    <input type="text" name="technicalSkills" required maxlength="500" placeholder="Comma-separated, e.g. Java, JSP, MySQL"
                           value="<%= esc(cv.getTechnicalSkills()) %>" class="<%= inputClass(cv, "technicalSkills") %>">
                    <%= fieldError(cv, "technicalSkills") %>
                </label>
                <label class="block">
                    <span class="text-sm font-medium text-slate-700">Soft Skills</span>
                    <input type="text" name="softSkills" maxlength="500" placeholder="Comma-separated, e.g. Teamwork, Leadership"
                           value="<%= esc(cv.getSoftSkills()) %>" class="<%= inputClass(cv, "softSkills") %>">
                </label>
            </div>
        </section>

        <div class="flex flex-col gap-3 sm:flex-row sm:justify-end">
            <a href="<%= ctx %>/cvForm.jsp"
               class="rounded-lg border border-slate-300 bg-white px-5 py-2.5 text-center font-medium text-slate-700 hover:bg-slate-50">
                Clear Form
            </a>
            <a href="<%= ctx %>/CVServlet?action=sample"
               class="rounded-lg border border-forest-600 bg-white px-5 py-2.5 text-center font-medium text-forest-700 hover:bg-forest-50">
                Generate Template
            </a>
            <button type="submit"
                    class="rounded-lg bg-forest-800 px-5 py-2.5 font-semibold text-white shadow hover:bg-forest-900">
                Generate My CV
            </button>
        </div>
    </form>
</main>

</body>
</html>
