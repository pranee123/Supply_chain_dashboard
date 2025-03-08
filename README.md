# 📊 Supply Chain Power BI Dashboard
<img width="575" alt="Suplly_chain_dashboard" src="https://github.com/user-attachments/assets/0fbf020e-36ab-4f2c-9a7f-c26d3d13d0ef" />
## 📌 Overview
This repository contains a **Power BI dashboard** that provides insights into supply chain data, including **customer orders, suppliers, products, and revenue analytics**.

---

## 📂 Files in this Repository  
- **`SupplyChain_Dashboard.pbix`** → The main Power BI dashboard file.  
- **`Dataset_Summary.csv`** → Summary of data sources used in the dashboard.  
- **`DAX_Calculations.md`** → List of all DAX measures used.  
- **`PowerBI_Report.pdf`** → Exported report from Power BI.  

---

## 📊 Dashboard Insights  
### ✅ Key Features:  
- **Top Customers by Revenue**  
- **Best-Selling Products & Suppliers**  
- **Total Discount and Savings Analysis**  
- **Monthly Revenue Trends**  
- **Customer-Supplier Relationship Analysis**  

---

## 📈 Data Sources  
The dashboard is built using **six tables from the Supply Chain database**:  
- **Customer** → Customer details (Name, City, Country)  
- **OrderItem** → Products ordered, quantity, and price  
- **Orders** → Order details and total amount  
- **Product** → Product name, supplier, price  
- **Supplier** → Supplier details  
- **Calendar** → Date-based calculations  

---

## 🛠️ DAX Measures Used  
--DAX
Total Revenue = SUM(Orders[TotalAmount])

Top Customers = 
VAR CustomerRevenue = 
    ADDCOLUMNS(
        SUMMARIZE(Customer, Customer[FirstName]),
        "Revenue", SUMX(RELATEDTABLE(Orders), Orders[TotalAmount])
    )
RETURN
    TOPN(5, CustomerRevenue, [Revenue], DESC)
