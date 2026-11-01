
const express = require('express');
const router = express.Router();
const db = require('../config/db');

// COMMON VALIDATION FUNCTION
function validateEmployee(data) {
    const { name, email, mobile, designation, department } = data;

    if (!name || !email || !mobile || !designation || !department) {
        return 'All fields are required';
    }

    // Name should contain only alphabets and spaces
    if (!/^[a-zA-Z ]+$/.test(name.trim())) {
        return 'Name must contain only alphabets';
    }

    // Validate email
    if (!/^[\w.-]+@[\w.-]+\.[a-zA-Z]{2,}$/.test(email.trim())) {
        return 'Please enter a valid email';
    }

    // Mobile must contain exactly 10 digits
    if (!/^[0-9]{10}$/.test(mobile.trim())) {
        return 'Mobile must contain exactly 10 digits';
    }

    return null;
}


// 1. ADD EMPLOYEE
router.post('/', (req, res) => {
    const { name, email, mobile, designation, department } = req.body;

    const error = validateEmployee(req.body);

    if (error) {
        return res.status(400).json({ message: error });
    }

    const sql = `INSERT INTO employees
        (name, email, mobile, designation, department)
        VALUES (?, ?, ?, ?, ?)`;

    db.query(
        sql,
        [name.trim(), email.trim(), mobile.trim(),
         designation.trim(), department.trim()],
        (err, result) => {
            if (err) {
                if (err.code === 'ER_DUP_ENTRY') {
                    return res.status(409).json({
                        message: 'Email already exists'
                    });
                }

                return res.status(500).json({
                    message: 'Database error'
                });
            }

            res.status(201).json({
                message: 'Employee added successfully',
                id: result.insertId
            });
        }
    );
});


// 2. GET ALL EMPLOYEES
router.get('/', (req, res) => {
    db.query('SELECT * FROM employees', (err, result) => {
        if (err) {
            return res.status(500).json({
                message: 'Database error'
            });
        }

        res.status(200).json(result);
    });
});


// 3. GET EMPLOYEE BY ID
router.get('/:id', (req, res) => {
    const id = req.params.id;

    db.query(
        'SELECT * FROM employees WHERE id = ?',
        [id],
        (err, result) => {
            if (err) {
                return res.status(500).json({
                    message: 'Database error'
                });
            }

            if (result.length === 0) {
                return res.status(404).json({
                    message: 'Employee not found'
                });
            }

            res.status(200).json(result[0]);
        }
    );
});


// 4. UPDATE EMPLOYEE
router.put('/:id', (req, res) => {
    const id = req.params.id;
    const { name, email, mobile, designation, department } = req.body;

    const error = validateEmployee(req.body);

    if (error) {
        return res.status(400).json({ message: error });
    }

    const sql = `UPDATE employees SET
        name = ?, email = ?, mobile = ?, designation = ?, department = ?
        WHERE id = ?`;

    db.query(
        sql,
        [name.trim(), email.trim(), mobile.trim(),
         designation.trim(), department.trim(), id],
        (err, result) => {
            if (err) {
                if (err.code === 'ER_DUP_ENTRY') {
                    return res.status(409).json({
                        message: 'Email already exists'
                    });
                }

                return res.status(500).json({
                    message: 'Database error'
                });
            }

            if (result.affectedRows === 0) {
                return res.status(404).json({
                    message: 'Employee not found'
                });
            }

            res.status(200).json({
                message: 'Employee updated successfully'
            });
        }
    );
});


// 5. DELETE EMPLOYEE
router.delete('/:id', (req, res) => {
    const id = req.params.id;

    db.query(
        'DELETE FROM employees WHERE id = ?',
        [id],
        (err, result) => {
            if (err) {
                return res.status(500).json({
                    message: 'Database error'
                });
            }

            if (result.affectedRows === 0) {
                return res.status(404).json({
                    message: 'Employee not found'
                });
            }

            res.status(200).json({
                message: 'Employee deleted successfully'
            });
        }
    );
});

module.exports = router;
