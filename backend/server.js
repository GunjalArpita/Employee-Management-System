
require('dotenv').config();
const employeeRoutes = require('./routes/employeeRoutes');
const express = require('express');
const cors = require('cors');
const db = require('./config/db');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());


// Test API
app.get('/', (req, res) => {
    res.send('Employee Management API is Running!');
});

app.use('/api/employees', employeeRoutes);

// Start server
const PORT = process.env.PORT || 5000;

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running on port ${PORT}`);
});
