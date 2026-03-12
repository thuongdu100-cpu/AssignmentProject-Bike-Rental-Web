# 🚲 Bike Rental Management System

![Java](https://img.shields.io/badge/Java-Servlet-orange)
![JSP](https://img.shields.io/badge/JSP-Web-blue)
![Tomcat](https://img.shields.io/badge/Server-Tomcat-red)
![Architecture](https://img.shields.io/badge/Architecture-MVC-green)

## 📌 Giới thiệu dự án

**Bike Rental Management System** là hệ thống web hỗ trợ quản lý dịch vụ cho thuê xe đạp.  
Hệ thống cho phép người dùng đăng ký tài khoản, thuê xe, thanh toán chi phí thuê và theo dõi lịch sử thuê xe.

Ngoài ra, hệ thống cũng hỗ trợ nhân viên và quản trị viên quản lý xe, người dùng, giá thuê và các hoạt động vận hành của dịch vụ.

Dự án được phát triển bằng **Java Web (JSP / Servlet)** và áp dụng kiến trúc **MVC (Model - View - Controller)** nhằm giúp hệ thống dễ mở rộng và dễ bảo trì.

---

# 🎯 Mục tiêu của dự án

Mục tiêu của dự án là xây dựng một hệ thống mô phỏng dịch vụ cho thuê xe đạp trong thực tế.

Thông qua dự án này có thể:

- Thực hành phát triển hệ thống web bằng **Java Servlet và JSP**
- Áp dụng mô hình **MVC Architecture**
- Thực hành làm việc với **JDBC và Database**
- Tích hợp **VNPay Payment Gateway**
- Quản lý người dùng theo **Role-based Access Control**

---

# 🏗 Kiến trúc hệ thống

Hệ thống được xây dựng dựa trên mô hình **MVC (Model - View - Controller)**.


Client (Browser)
│
▼
Controller (Servlet)
│
▼
Business Logic
│
▼
DAO Layer
│
▼
Database
│
▼
View (JSP)


### Các thành phần chính

**Model**

Model đại diện cho các đối tượng dữ liệu trong hệ thống.

Ví dụ:

- User
- Bike
- Rental
- Payment
- Station
- PricingPlan

---

**View**

View là phần giao diện người dùng của hệ thống.

Được xây dựng bằng:

- JSP
- HTML
- CSS
- JavaScript

---

**Controller**

Controller chịu trách nhiệm xử lý request từ người dùng và điều hướng các chức năng trong hệ thống.

Ví dụ:

- LoginController
- RegisterController
- BikeController
- RentalController
- PaymentController

---

**DAO (Data Access Object)**

DAO chịu trách nhiệm làm việc trực tiếp với cơ sở dữ liệu.

Ví dụ:

- UserDAO
- BikeDAO
- RentalDAO
- PaymentDAO

DAO giúp tách phần truy vấn database ra khỏi logic của chương trình.

---

# 💻 Công nghệ sử dụng

### Backend

- Java
- Java Servlet
- JSP
- JDBC
- DAO Pattern

### Frontend

- HTML
- CSS
- JavaScript
- JSP

### Server

- Apache Tomcat

### Database

- MySQL / SQL Server

### Payment

- VNPay Payment Gateway

### Development Tools

- IntelliJ IDEA / NetBeans
- Git
- GitHub

---

# ⚙ Chức năng chính của hệ thống

## 1. Hệ thống xác thực người dùng

- Đăng ký tài khoản
- Đăng nhập
- Đăng xuất
- Quản lý thông tin cá nhân

Hệ thống sử dụng **Role-based Access Control** để phân quyền người dùng.

---

## 2. Chức năng dành cho Customer

Người dùng có thể:

- Xem danh sách xe
- Thuê xe
- Xem trạng thái thuê xe hiện tại
- Xem lịch sử thuê xe
- Thanh toán chi phí thuê
- Cập nhật thông tin cá nhân

---

## 3. Chức năng dành cho Staff

Nhân viên có thể:

- Quản lý danh sách xe
- Thêm hoặc chỉnh sửa xe
- Theo dõi tình trạng thuê xe
- Quản lý các trạm xe

---

## 4. Chức năng dành cho Admin

Quản trị viên có thể:

- Quản lý người dùng
- Phân quyền người dùng
- Quản lý giá thuê
- Theo dõi hoạt động của hệ thống
- Xem thống kê

---

# 📂 Cấu trúc thư mục dự án

Dự án được tổ chức theo kiến trúc MVC nhằm giúp code rõ ràng và dễ bảo trì.


BikeRental
│
├── src
│ ├── controller
│ │ ├── LoginController.java
│ │ ├── RegisterController.java
│ │ ├── BikeController.java
│ │ ├── RentalController.java
│ │ └── PaymentController.java
│ │
│ ├── dao
│ │ ├── UserDAO.java
│ │ ├── BikeDAO.java
│ │ ├── RentalDAO.java
│ │ └── PaymentDAO.java
│ │
│ ├── models
│ │ ├── User.java
│ │ ├── Bike.java
│ │ ├── Rental.java
│ │ ├── Payment.java
│ │ └── Station.java
│ │
│ └── utils
│ └── DBConnection.java
│
├── web
│ ├── admin
│ ├── staff
│ ├── customer
│ ├── css
│ ├── js
│ └── jsp-pages
│
└── docs
├── diagrams
└── screenshots


---

# 💳 Tích hợp thanh toán VNPay

Hệ thống hỗ trợ thanh toán trực tuyến thông qua **VNPay Payment Gateway**.

Quy trình thanh toán:

1. Người dùng chọn thanh toán
2. Hệ thống tạo URL thanh toán VNPay
3. Người dùng thực hiện thanh toán
4. VNPay trả kết quả về hệ thống
5. Hệ thống xác nhận trạng thái thanh toán

File cấu hình thanh toán thường nằm tại:


com.vnpay.common.Config.java


---

# 🚀 Hướng dẫn chạy dự án

## 1. Yêu cầu hệ thống

Cần cài đặt:

- Java JDK 8+
- Apache Tomcat
- MySQL hoặc SQL Server
- IntelliJ IDEA hoặc NetBeans

---

## 2. Clone repository


git clone https://github.com/your-repository/bike-rental-web.git


---

## 3. Cấu hình database

Tạo database và cập nhật thông tin kết nối trong project.

Ví dụ:


DB_URL
DB_USERNAME
DB_PASSWORD


---

## 4. Chạy hệ thống

1. Import project vào IDE
2. Cấu hình Tomcat
3. Build project
4. Run server

Truy cập:


http://localhost:8080/BikeRental


---

# 🔮 Hướng phát triển trong tương lai

Một số cải tiến có thể thực hiện:

- Xây dựng REST API
- Phát triển frontend bằng React hoặc Vue
- Phát triển mobile app
- Tích hợp bản đồ vị trí trạm xe
- Cải thiện UI/UX

---

# 👨‍💻 Contributors


Thưởng Nguyễn Hữu


Sinh viên ngành **Kỹ thuật phần mềm**

---

# 📄 License

Dự án được xây dựng cho mục đích **học tập và nghiên cứu**.
