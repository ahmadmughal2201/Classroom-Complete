const userModel = require("../models/userModel");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");


async function registerUser(req, res) {
    try {
        // In case if any of the field is missing
        if (!req.body.username || !req.body.email || !req.body.password) {
            return res
                .status(400)
                .json({ message: "Please provide all the required fields" });
        }
        else {
            console.log(req.body); //For checking response send in console
            const { username, email, password } = req.body;
            // Check if the user already exists
            const user = await userModel.findOne({ email: email });
            if (user) {
                return res.status(409).json({ message: "Email already being used!" });
            }
            else {
                bcrypt.hash(password, 10)
                    .then((hash) => {
                        userModel.create({ username, email, password: hash })
                            .then(res.status(200).json({ message: "User created successfully!" }))
                            .catch((err) => {
                                console.log(err);
                                return res.status(500).json({ message: err });
                            });
                    });
            }
        }
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: error });
    }
}
async function loginUser(req, res) {
    console.log(req.body);
    const { email, password } = req.body;

    try {
        userModel.findOne({ email: email }).then((user) => {
            if (!user) {
                return res.status(404).json({ message: "User not found" });
            }
            else {
                bcrypt.compare(password, user.password, async (err, result) => {
                    if (err) {
                        console.log(err);
                        return res.status(500).json({ message: err });
                    }
                    else if (result == true) {
                        var token = GenerateToken(user);
                   
                        console.log("Logged In successfully");
                        return res.status(200).json({
                            message: "User logged in successfully",
                            email: email,
                            name: user.username,
                            userid: user._id,
                            token: token,
                        });
                    }
                    else if (result == false) {
                        return res.status(401).json({ message: "Invalid Credentials" });
                    }
                });
            }
        }).catch((err) => {
            console.log(err);
            return res.status(500).json({ message: err });
        });
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: error });
    }
}
function GenerateToken(user) {
    const payload = {
        id: user._id,
    };
    const token = jwt.sign(payload, process.env.JWT_SECRET);
    return token;
}

module.exports = {
    registerUser,
    loginUser,
};
