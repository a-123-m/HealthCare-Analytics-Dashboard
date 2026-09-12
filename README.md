# 🏥 Healthcare Analytics Dashboard - Excel, SQL, Python and Tableau
An end-to-end healthcare analytics project covering data inspection, cleaning, database modeling, and dashboarding — built with Excel, Python, SQL, and Tableau on a star-schema dataset of 310,000+ disease incidents across 300 hospitals, 92 locations, 40,000 patients and 50 disease conditions.
<p align='center'>
<img width="225" height="225" alt="image" src="https://github.com/user-attachments/assets/bc823236-8e90-4ec3-a1df-2486a4d81471" />
</p>

## 📌 Business Problem

Healthcare networks generate large volumes of operational data - patient admissions, diagnoses, treatment costs, hospital stays and outcomes, but this data is rarely analysis-ready. It typically arrives:
* Split across disconnected tables (patients, hospitals, diseases, locations, dates)
* Full of inconsistent formatting, duplicate records and missing values
* Inaccessible to non-technical stakeholders who need answers, not raw tables
Without a structured pipeline, healthcare administrators and analysts can't reliably answer operational questions.

## 💡 Proposed Solution
Build a complete analytics pipeline that takes raw, messy, multi-table healthcare data of USA all the way to a decision-ready dashboard:
1. **Excel** — Data Exploration
2. **Python (pandas)** — Data Inspection, EDA (Exploratory Data Analysis) and data cleaning on each table independently (nulls, duplicates, inconsistent casing, invalid types).
3. **SQL (PostgreSQL)** — Create Analysis ready views 
4. **Tableau** — Data visualization and answer business questions through an interactive dashboard.

## 📊 Dashboard Preview
<img width="1907" height="1027" alt="Screenshot 2026-09-12 192107" src="https://github.com/user-attachments/assets/facff2c2-fef6-4bc2-99df-c63eb1373800" />

## 🎥 Dashboard Walkthrough
https://github.com/user-attachments/assets/39d22854-8416-438b-b97d-14bb450eaf4b

## 🔄 Project Workflow
1. Excel — Data Understanding & Profiling
<p>
I started by inspecting the raw datasets in Excel to understand their structure and contents. I reviewed each column, identified the type of information it contained, checked for obvious data quality issues and created a data dictionary. This provided a clear reference for the cleaning and analysis stages that followed.
</p>

2. Python — Data Inspection, EDA, Cleaning & Preparation
<p>
I used Python to inspect and explore the individual datasets, gaining an initial understanding of their structure, distributions, and data quality. I performed exploratory data analysis (EDA) to identify patterns, missing values, duplicate records, inconsistent text formats, and other potential data quality issues. I then cleaned and standardized the data and exported the prepared tables for further transformation and analysis in SQL.
</p>

> Healthcare.ipynb python file attached. Please refer the attached file for the complete Python code.

3. SQL — Data Transformation & Integration
<p>
The cleaned datasets were loaded into SQL for further transformation and analysis. I created derived fields to make the data more useful for business analysis, including patient age groups and hospital-stay categories. I then joined the related tables, selecting only the relevant columns required for analysis, and created a final analytical table containing the key information needed for visualization and reporting in Tableau.
</p>

> sql_healthcare file attached. Please refer the attached file for the complete PostgreSQL code.

4. Tableau — Visualization & Business Insights
<p>
The data was connected to Tableau to build an interactive healthcare analytics dashboard. I created visualizations to answer specific business questions, such as:

* How is patient incident volume changing over time?
* Which regions have the highest patient volume?
* Which admission type is most common?
* What are the top 5 common diseases among patients?
* Which diseases have highest number of patient cases?
</p>

**Overall Workflow**
<img width="2172" height="724" alt="image" src="https://github.com/user-attachments/assets/68a7c92e-f6f6-43db-be38-4535584945ad" />

## 📊 Dashboard KPIs

| KPI | Value |
|---|---:|
| Total Incidents | 310,000 |
| Total Patients | 39,983 |
| Total Hospitals | 300 |
| Total Treatment Cost | $1,629,870,304 |
| Average Treatment Cost | $4,044 |
| Average Length of Stay | 9.9 days |
| Insurance Coverage | 67.27% |

## 📈 Business Questions & Visualizations

### 1. How is patient incident volume changing over time?

**Visualization:** Monthly Trend Line Chart

This visual shows the monthly pattern of healthcare incidents and helps identify periods with relatively high or low incident volumes.

---

### 2. Which diseases have the highest number of patient cases?

**Visualization:** Horizontal Bar Chart

The chart ranks diseases based on the number of patient cases.

The analysis can be filtered by:

- Disease Category
- Disease
- Transmission Type

This helps identify diseases contributing most to the overall patient volume.

---

### 3. Which regions have the highest number of patients?

**Visualization:** Regional Bar Chart

Patient volume is compared across:

- South
- West
- Midwest
- Northeast

This provides a high-level view of regional patient distribution and can support resource allocation decisions.

---

### 4. Which admission type is most common?

**Visualization:** Horizontal Bar Chart

Admission types analyzed include:

- Emergency
- Elective
- Urgent
- Outpatient
- Unknown
- Newborn

This helps understand how patients enter the healthcare network and the proportion of unplanned versus planned care.

---

### 5. What are the top 5 most common diseases among patients?

**Visualization:** Ranked Bar Chart

The top five diseases identified are:

1. Parkinson's Disease
2. Epilepsy
3. Typhoid Fever
4. Acute Kidney Injury
5. Obesity

## 📊 Key Insights
* Emergency admissions dominate the network at 85,837 incidents.
* The South and West regions carry the highest patient load (37,697 and 35,572 respectively).
* Insurance coverage sits at 67.27%.
* Incident volume is seasonal rather than trending, ranging from a February low of 23,741 to an October peak of 26,686, rather than showing sustained growth or decline.
* Average length of stay by patients is ~10 days

<br>
<p>If you found this project helpful, consider giving it a ⭐ on GitHub!<br> Thank you❤️</p>
<div>
  <h2>Connect with Me</h2>
<a href="mailto:aiswarya2000mohan@gmail.com">
  <img src="https://img.shields.io/badge/-Gmail-red?style=for-the-badge&logo=gmail&logoColor=white" alt="Gmail">
</a>
<a href="https://www.linkedin.com/in/aiswarya-mohan-950948221/">
  <img src="https://img.shields.io/badge/-LinkedIn-blue?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn">
</a>
</div>
