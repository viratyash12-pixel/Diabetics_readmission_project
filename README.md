# Diabetics_readmission_project
SQL analysis of 100K diabetic hospital visits in BigQuery: which patients are readmitted within 30 days, and why it might happen.
# 🏥 Diabetes Hospital Readmissions: SQL Analysis

I used SQL in BigQuery to look at about 100,000 hospital visits by diabetic patients and find out **who is more likely to come back to the hospital within 30 days**.

![SQL](https://img.shields.io/badge/SQL-BigQuery-4285F4?logo=googlecloud&logoColor=white)
![Rows](https://img.shields.io/badge/Rows-101%2C766-green)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)

---

## 📊 Dataset

[Diabetes 130-US hospitals for years 1999-2008](https://archive.ics.uci.edu/dataset/296/diabetes+130-us+hospitals+for+years+1999-2008) from the UCI Machine Learning Repository.

- 📁 `diabetic_data.csv`: 101,766 hospital visits, 71,518 patients, 50 columns
- 📁 `IDS_mapping.csv`: lookup table that explains the ID codes (for example, where the patient went after discharge)

The `readmitted` column has three values: `<30` (came back within 30 days), `>30` and `NO`. I counted a "readmission" as `<30`.

---

## ❓ Questions I looked at

1. 📌 What is the overall 30-day readmission rate?
2. 🎂 How does the rate change with age?
3. 🏆 Which age groups rank highest? (window function)
4. 🚪 Does it matter where the patient went after discharge? (join)
5. 🕒 Do longer hospital stays mean more readmissions?
6. 🔁 Do patients with earlier hospital admissions come back more often?
7. 🩺 Which medical specialties have the highest rates?
8. 💉 Is insulin treatment linked to readmission?

All queries are in [`diabetes_readmission_analysis_bigquery.sql`](diabetes_readmission_analysis_bigquery.sql).

---

## 🔍 What I found

| | Finding |
|---|---|
| 📌 **Overall** | 11.16% of visits ended in a return within 30 days |
| 🔁 **Earlier admissions** | 8.44% with none, 17.43% with two, 23.61% with four |
| 🕒 **Length of stay** | 8.18% for 1-day stays, 12.83% for 7-day stays |
| 🚪 **After discharge** | 9.30% if sent home, 27.70% if sent to a rehab facility |
| 💉 **Insulin** | 13.90% if dose lowered, 12.99% if raised, 10.04% if not on insulin |
| 🩺 **Specialty** | Hematology/Oncology 19.32%, Oncology 18.97%, Nephrology 15.38% |
| 🎂 **Age** | Ages 20-30 highest at 14.24%, then 80-90 at 12.08%. Ages 50-60 at 9.67% |

**Biggest takeaway:** patients who were admitted to hospital before are the most likely to come back. ⚠️

---

## 🛠️ SQL used

`JOIN` · `GROUP BY` · `HAVING` · `COUNTIF` · `RANK()` window function · `REGEXP_EXTRACT` · subqueries

---

## ▶️ How to run it

1. Upload `diabetic_data.csv` to a BigQuery dataset (auto-detect the schema).
2. Run the `CREATE TABLE` statement at the top of the SQL file once. It builds the discharge lookup table.
3. Run the queries one at a time.

Update the table names in the file if your project or dataset has a different name.

---

## ⚠️ Limits of this analysis

- These are patterns in the data, not proof of cause. A longer stay may just mean the patient was sicker.
- The data covers 1999-2008 and one group of US hospitals.
- Each row is a visit, not a patient. Some patients appear many times.
- Patients who died or went to hospice are included, which makes the rates slightly lower.
- Some columns have a lot of missing values (`weight` is about 97% empty), so I did not use them.

---

## 👤 Author

**Yash Virat**
📍 New Delhi, India
🔗 [LinkedIn](https://www.linkedin.com/) · 💻 [GitHub](https://github.com/)
