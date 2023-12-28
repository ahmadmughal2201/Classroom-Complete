const mongoose = require('mongoose');

const classSchema = new mongoose.Schema({
  name: { type: String, required: true,unique:true, trim: true },
  code: { type: String, required: true, unique: true, trim: true },
  teacher: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, },
  students: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
    }
  ],
  // Add other fields as needed
}, { timestamps: true });

module.exports = mongoose.model('Class', classSchema);
