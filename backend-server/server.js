const express = require('express');
const cors=require('cors');
require('./utils/db');
require('dotenv').config();

const PORT = process.env.PORT || 3000; // Default to 3000 if PORT is not specified

const bodyParser = require('body-parser');
const userRoutes = require('./routes/userRoute');
const classRoutes = require('./routes/classRoute');

const app = express();
app.use(cors());
app.use(bodyParser.json()); // Corrected typo in bodyParser

// API starter calls
app.use('/api', userRoutes);
app.use('/class', classRoutes);

app.get('/', (req, res) => {
    console.log(req);
    return res.status(200).send("Hello World"); // Changed status code to 200
});

app.listen(PORT, () => {
    console.log(`Express server started on port ${PORT}`);
});
