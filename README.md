 # flutter_application_1


# Employee Management System

A Flutter-based Employee Management application with a Node.js and Express backend and MySQL database.

## Features

- View all employees
- Add new employees
- Update employee details
- Delete employees with confirmation
- Form validation for name, email and mobile
- Duplicate email handling
- REST API integration
- MySQL database storage

## Technologies Used

### Frontend
- Flutter
- Dart
- HTTP package

### Backend
- Node.js
- Express.js
- MySQL
- mysql2
- dotenv
- CORS

## Project Structure

```text
flutter_application_1/
├── backend/
│   ├── config/
│   │   └── db.js
│   ├── routes/
│   │   └── employeeRoutes.js
│   ├── .env
│   ├── server.js
│   └── package.json
├── lib/
│   ├── screens/
│   ├── services/
│   └── main.dart
├── employee_management.sql
└── pubspec.yaml
```

## Setup Instructions

### 1. Clone the repository

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
cd flutter_application_1
```

### 2. Setup MySQL Database

Run the SQL script:

```bash
mysql -u root -p < employee_management.sql
```

This creates the employee_management database and employees table.

### 3. Setup Backend

Navigate to the backend folder:

```bash
cd backend
npm install
```

Create a `.env` file:

```env
DB_PASSWORD=mysql_password
PORT=5000
```

Start the backend:

```bash
npm run dev
```

The server runs on port 5000.

### 4. Configure Flutter API URL

Open:

`lib/services/employee_service.dart`

Update `baseUrl` with your computer's local IPv4 address:

```dart
static const String baseUrl =
    'http://10.168.190.173:5000/api/employees';
```

Ensure your phone and computer are connected to the same Wi-Fi network.

### 5. Run Flutter Application

Open a new terminal in the project root:

```bash
flutter pub get
flutter run
```

## API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| POST | /api/employees | Add employee |
| GET | /api/employees | Get all employees |
| GET | /api/employees/:id | Get employee by ID |
| PUT | /api/employees/:id | Update employee |
| DELETE | /api/employees/:id | Delete employee |

## Validation

- Name accepts alphabets and spaces.
- Email must have a valid format.
- Mobile number must contain exactly 10 digits.
- All fields are required.
- Duplicate email addresses are rejected.
