const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const tasksRoute = require('./routes/task.routes');

dotenv.config();

const app = express();

app.use(express.json());
app.use("/api/tasks",tasksRoute);
mongoose
  .connect(process.env.MONGODB_URI)
  .then(() => {
    console.log('MongoDB connected');
  })
  .catch((error) => {
    console.error(
      'MongoDB connection error:',
      error
    );
  });

app.get('/', (req, res) => {
  res.json({
    message: 'Task Manager API is running',
  });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(
    `Server running on port ${PORT}`
  );
});
