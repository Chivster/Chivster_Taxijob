# 🚖 NoLo Taxi Job Script Installation Guide

## 📦 Requirements

- ✅ QBCore or Qbox Framework
- ✅ `oxmysql` resource installed and running
- ✅ Access to your server database (e.g., phpMyAdmin)

---

## 🛠️ Installation Steps

### 1. Import SQL

Create the required table for storing delivery progress:

```sql
CREATE TABLE IF NOT EXISTS `taxi_deliveries` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `cid` VARCHAR(50) NOT NULL,
  `deliveries` INT DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE (`cid`)
);
