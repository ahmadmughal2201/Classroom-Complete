const classModel = require("../models/classModel");
const userModel = require("../models/userModel")
const bcrypt = require("bcrypt");
/*
name: { type: String, required: true, trim: true },
  code: { type: String, required: true, unique: true, trim: true },
  description: { type: String, },
  teacher: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, },
  students: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User', // Assuming you have a User model for students
    },
  ],
*/


async function createClass(req, res) {
    try {
        console.log(req.body); //For checking response send in console
        const { name, code, teacherEmail } = req.body;
        if (!name || !code || !teacherEmail) {
            return res.status(400).json({ message: "Invalid or empty request body" });
        }
        else {
            // Check if the user already exists
            const teacherId = await userModel.findOne({ email: teacherEmail });
            const classData = await classModel.findOne({ name: name });
            console.log(teacherId);
            if (!teacherId) {
                return res.status(409).json({ message: "You are not authorized to create class" });
            }
            else if (classData) {
                return res.status(409).json({ message: "Class already exists with this try another name" });
            }
            else {

                classModel.create({ name, code, teacher: teacherId })
                    .then(res.status(200).json({ message: "Class created successfully!" }))
                    .catch((err) => {
                        console.log(err);
                        return res.status(500).json({ message: err });
                    });

            }
        }
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: error });
    }
}

async function getAllClassesForUser(req, res) {
    try {
        const { email } = req.params;
        console.log(email);
        const user = await userModel.findOne({ email: email });

        if (user) {
            const userId = user._id;

            // Find classes where the user is the teacher
            const teacherClasses = await classModel.find({teacher:userId}).populate('teacher', 'username');

            // Find classes where the user is a student
            const studentClasses = await classModel.find({students:userId}).populate('teacher', 'username').populate('students', 'username');

            // Combine the arrays of classes
            const allClasses = [...teacherClasses, ...studentClasses];

            return res.status(200).json({ message: "All classes fetched successfully!", data: allClasses });
        } else {
            return res.status(409).json({ message: "You are not an authorized user" });
        }
    } catch (error) {
        console.error('Error fetching classes:', error);
        return res.status(500).json({ message: "Internal server error" });
    }
}

async function enrollStudent(req, res) {
    try {
        const { classCode, userEmail } = req.body;
        console.log(req.body);
        // Find the class based on the provided code
        const targetClass = await classModel.findOne({ code: classCode }).populate('teacher', 'username').populate('students', 'username');
        const user = await userModel.findOne({ email: userEmail });

        if (!targetClass) {
            return res.status(404).json({ message: 'Class not found with the provided code' });
        }

        // Check if the student is already enrolled in the class
        if (targetClass.students.includes(user._id)) {
            return res.status(400).json({ message: 'Student is already enrolled in the class' });
        }
        if (targetClass.teacher === user._id) {
            return res.status(400).json({ message: 'You are the teacher of this class' });
        }

        // Update the class to include the student
        targetClass.students.push(user._id);
        await targetClass.save();

        return res.status(200).json({ message: 'Student enrolled successfully', data: targetClass });


    } catch (error) {
        console.error('Error enrolling student:', error);
        return res.status(500).json({ message: 'Internal server error' });
    }
}
module.exports = {
    createClass,
    getAllClassesForUser,
    enrollStudent
};
