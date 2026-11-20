package com.cvbuilder.controller;

import com.cvbuilder.model.CVBean;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Controller of the CV Builder (MVC).
 * <ul>
 *   <li>POST: reads the submitted form, populates and validates a {@link CVBean},
 *       then forwards to cvView.jsp (valid) or back to cvForm.jsp with the
 *       entered values and error messages (invalid).</li>
 *   <li>GET ?action=sample: builds a CVBean filled with dummy data and
 *       forwards to cvView.jsp without any user input.</li>
 * </ul>
 * The servlet is declared and mapped in WEB-INF/web.xml.
 */
public class CVServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String VIEW_PAGE = "/cvView.jsp";
    private static final String FORM_VIEW = "/cvForm.jsp";   // forward target (same request)
    private static final String FORM_PAGE = "cvForm.jsp";    // redirect target (new request)

    /** Handles the "Preview Sample CV" link (HTTP GET). */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("sample".equals(action)) {
            CVBean cvBean = createSampleCV();
            request.setAttribute("cvData", cvBean);
            request.setAttribute("isSample", true);

            RequestDispatcher dispatcher = request.getRequestDispatcher(VIEW_PAGE);
            dispatcher.forward(request, response);
        } else {
            // Unknown or missing action: send the user to the input form
            response.sendRedirect(FORM_PAGE);
        }
    }

    /** Handles the CV form submission (HTTP POST). */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 1. Instantiate the Model and populate it from the request parameters
        CVBean cvBean = new CVBean();

        cvBean.setFullName(param(request, "fullName"));
        cvBean.setProfessionalTitle(param(request, "professionalTitle"));
        cvBean.setEmail(param(request, "email"));
        cvBean.setPhone(param(request, "phone"));
        cvBean.setProfileUrl(param(request, "profileUrl"));
        cvBean.setProfileSummary(param(request, "profileSummary"));

        cvBean.setHighestDegree(param(request, "highestDegree"));
        cvBean.setInstitution(param(request, "institution"));
        cvBean.setGraduationYear(param(request, "graduationYear"));
        cvBean.setMajor(param(request, "major"));

        cvBean.setJobTitle(param(request, "jobTitle"));
        cvBean.setCompanyName(param(request, "companyName"));
        cvBean.setDuration(param(request, "duration"));
        cvBean.setResponsibilities(param(request, "responsibilities"));

        cvBean.setTechnicalSkills(param(request, "technicalSkills"));
        cvBean.setSoftSkills(param(request, "softSkills"));

        // 2. Validate through the bean, 3. store in request scope, 4. forward to a view
        request.setAttribute("cvData", cvBean);

        RequestDispatcher dispatcher;
        if (cvBean.validate()) {
            dispatcher = request.getRequestDispatcher(VIEW_PAGE);
        } else {
            // Back to the form: the bean pre-fills the inputs, the map lists what to fix
            request.setAttribute("errors", cvBean.getErrors());
            dispatcher = request.getRequestDispatcher(FORM_VIEW);
        }
        dispatcher.forward(request, response);
    }

    /** Builds a CVBean pre-populated with realistic dummy data via its setters. */
    private CVBean createSampleCV() {
        CVBean cv = new CVBean();

        cv.setFullName("Nur Aisyah binti Ahmad");
        cv.setProfessionalTitle("Junior Java Web Developer");
        cv.setEmail("aisyah.ahmad@example.com");
        cv.setPhone("+60 12-345 6789");
        cv.setProfileUrl("https://www.linkedin.com/in/nuraisyah-ahmad");
        cv.setProfileSummary("Detail-oriented Computer Science graduate with hands-on experience "
                + "building Java EE web applications using Servlets, JSP and MySQL. "
                + "Passionate about clean MVC architecture, usable interfaces and "
                + "continuous learning.");

        cv.setHighestDegree("Bachelor of Computer Science (Hons.)");
        cv.setInstitution("Universiti Teknologi MARA (UiTM)");
        cv.setGraduationYear("2026");
        cv.setMajor("Netcentric Computing");

        cv.setJobTitle("Software Developer Intern");
        cv.setCompanyName("TechNova Solutions Sdn. Bhd.");
        cv.setDuration("Mar 2026 - Aug 2026");
        cv.setResponsibilities("Developed Servlet/JSP modules for an internal leave management system\n"
                + "Designed MySQL tables and wrote JDBC data access classes\n"
                + "Reduced page load time by 30% by optimising SQL queries\n"
                + "Wrote user documentation and presented weekly progress to the team lead");

        cv.setTechnicalSkills("Java, Jakarta EE (Servlet & JSP), HTML5, CSS3, JavaScript, MySQL, Git");
        cv.setSoftSkills("Teamwork, Communication, Problem Solving, Time Management");

        return cv;
    }

    /** Reads a request parameter, returning a trimmed value or an empty string. */
    private static String param(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        return value == null ? "" : value.trim();
    }
}
