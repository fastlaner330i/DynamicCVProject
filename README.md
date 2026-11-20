# Dynamic Online CV Builder

A Jakarta EE web application that generates an ATS-friendly CV from user input.
Built with the Model-View-Controller (MVC) pattern for CSC584 Enterprise Programming.

## MVC Structure

| Layer | File |
|---|---|
| Model | `src/main/java/com/cvbuilder/model/CVBean.java` |
| Controller | `src/main/java/com/cvbuilder/controller/CVServlet.java` |
| View | `src/main/webapp/cvForm.jsp`, `cvView.jsp`, `cvError.jsp` |
| Configuration | `src/main/webapp/WEB-INF/web.xml` |

## Features

- **POST flow:** the form is submitted to `CVServlet`, which fills and validates `CVBean` and then shows `cvView.jsp`.
- **GET flow:** `CVServlet?action=sample` shows a sample CV filled with dummy data.
- **Validation:** server-side checks in `CVBean.validate()`. Invalid input returns to the form with the fields still filled in and error messages shown.

## Tech Stack

Jakarta EE (Servlet and JSP) · Payara Server · Maven · NetBeans · Tailwind CSS (CDN)

## How to Run

1. Open the project in NetBeans (**File → Open Project**).
2. Right-click the project → **Clean and Build**.
3. Right-click the project → **Run**, and choose Payara Server.
4. Open `http://localhost:8080/DynamicCVProject/`.

---
Muhammad Hafizuddin Khalis Mohd Yahyal Haq (2026122625) · CSC584 · UiTM Kampus Kuala Terengganu
