package com.cvbuilder.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * Model (JavaBean) that holds all candidate details for one CV.
 * <p>
 * Follows JavaBean conventions: private fields, a public zero-argument
 * constructor and public getter/setter methods. It also owns its own
 * validation rules through {@link #validate()}.
 */
public class CVBean implements Serializable {

    private static final long serialVersionUID = 1L;

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[\\w.+-]+@[\\w-]+(\\.[\\w-]+)*\\.[A-Za-z]{2,}$");
    private static final Pattern PHONE_PATTERN =
            Pattern.compile("^\\+?[0-9 ()-]{7,20}$");
    private static final Pattern YEAR_PATTERN =
            Pattern.compile("^(19|20)\\d{2}$");

    // ---------- Personal Info ----------
    private String fullName;
    private String professionalTitle;
    private String email;
    private String phone;
    private String profileUrl;        // LinkedIn / GitHub URL
    private String profileSummary;

    // ---------- Education ----------
    private String highestDegree;
    private String institution;
    private String graduationYear;
    private String major;

    // ---------- Experience ----------
    private String jobTitle;
    private String companyName;
    private String duration;
    private String responsibilities;  // one item per line

    // ---------- Skills ----------
    private String technicalSkills;   // comma-separated
    private String softSkills;        // comma-separated

    // ---------- Validation result: field name -> error message ----------
    private final Map<String, String> errors = new LinkedHashMap<>();

    /** Zero-argument constructor required by the JavaBean specification. */
    public CVBean() {
    }

    /**
     * Checks that mandatory fields (Name, Email, Degree, at least one
     * Technical Skill) are present and well-formed, and that optional
     * fields are well-formed when filled in.
     *
     * @return true if the bean holds valid data; otherwise false, with
     *         the reasons available from {@link #getErrors()}
     */
    public boolean validate() {
        errors.clear();

        // Mandatory fields
        if (isBlank(fullName)) {
            errors.put("fullName", "Full Name is required.");
        } else if (fullName.trim().length() < 3) {
            errors.put("fullName", "Full Name must be at least 3 characters.");
        }

        if (isBlank(email)) {
            errors.put("email", "Email is required.");
        } else if (!EMAIL_PATTERN.matcher(email.trim()).matches()) {
            errors.put("email", "Email address is malformed (example: name@example.com).");
        }

        if (isBlank(highestDegree)) {
            errors.put("highestDegree", "Highest Degree is required.");
        }

        if (getTechnicalSkillsList().isEmpty()) {
            errors.put("technicalSkills", "At least one Technical Skill is required.");
        }

        // Optional fields: only checked when provided
        if (!isBlank(phone) && !PHONE_PATTERN.matcher(phone.trim()).matches()) {
            errors.put("phone", "Phone Number may contain only digits, spaces, +, - and brackets (7-20 characters).");
        }

        if (!isBlank(profileUrl)) {
            String url = profileUrl.trim().toLowerCase();
            if (!url.startsWith("http://") && !url.startsWith("https://")) {
                errors.put("profileUrl", "LinkedIn/GitHub URL must start with http:// or https://.");
            }
        }

        if (!isBlank(graduationYear) && !YEAR_PATTERN.matcher(graduationYear.trim()).matches()) {
            errors.put("graduationYear", "Year of Graduation must be a 4-digit year (e.g. 2024).");
        }

        return errors.isEmpty();
    }

    /** @return validation messages from the last call to {@link #validate()}, keyed by field name */
    public Map<String, String> getErrors() {
        return errors;
    }

    /**
     * @param field form field name, e.g. "email"
     * @return the error message for that field, or an empty string if it is valid
     */
    public String getError(String field) {
        String message = errors.get(field);
        return message == null ? "" : message;
    }

    // ---------- Helper getters used by the view (read-only properties) ----------

    /** @return technical skills split on commas, blanks removed */
    public List<String> getTechnicalSkillsList() {
        return splitToList(technicalSkills, ",");
    }

    /** @return soft skills split on commas, blanks removed */
    public List<String> getSoftSkillsList() {
        return splitToList(softSkills, ",");
    }

    /** @return responsibilities split one per line, leading bullets removed */
    public List<String> getResponsibilitiesList() {
        List<String> items = new ArrayList<>();
        for (String line : splitToList(responsibilities, "\\r?\\n")) {
            String cleaned = line.replaceFirst("^[-*\\u2022]\\s*", "").trim();
            if (!cleaned.isEmpty()) {
                items.add(cleaned);
            }
        }
        return items;
    }

    private static List<String> splitToList(String value, String regex) {
        List<String> items = new ArrayList<>();
        if (value == null) {
            return items;
        }
        for (String part : value.split(regex)) {
            if (!part.trim().isEmpty()) {
                items.add(part.trim());
            }
        }
        return items;
    }

    private static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    // ---------- Standard getters and setters ----------

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getProfessionalTitle() {
        return professionalTitle;
    }

    public void setProfessionalTitle(String professionalTitle) {
        this.professionalTitle = professionalTitle;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getProfileUrl() {
        return profileUrl;
    }

    public void setProfileUrl(String profileUrl) {
        this.profileUrl = profileUrl;
    }

    public String getProfileSummary() {
        return profileSummary;
    }

    public void setProfileSummary(String profileSummary) {
        this.profileSummary = profileSummary;
    }

    public String getHighestDegree() {
        return highestDegree;
    }

    public void setHighestDegree(String highestDegree) {
        this.highestDegree = highestDegree;
    }

    public String getInstitution() {
        return institution;
    }

    public void setInstitution(String institution) {
        this.institution = institution;
    }

    public String getGraduationYear() {
        return graduationYear;
    }

    public void setGraduationYear(String graduationYear) {
        this.graduationYear = graduationYear;
    }

    public String getMajor() {
        return major;
    }

    public void setMajor(String major) {
        this.major = major;
    }

    public String getJobTitle() {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public String getResponsibilities() {
        return responsibilities;
    }

    public void setResponsibilities(String responsibilities) {
        this.responsibilities = responsibilities;
    }

    public String getTechnicalSkills() {
        return technicalSkills;
    }

    public void setTechnicalSkills(String technicalSkills) {
        this.technicalSkills = technicalSkills;
    }

    public String getSoftSkills() {
        return softSkills;
    }

    public void setSoftSkills(String softSkills) {
        this.softSkills = softSkills;
    }
}
