// upload.js
const fs = require('fs');
const axios = require('axios');
const FormData = require('form-data');

const FILE_PATH = './output_video.mp4';

async function uploadFile() {
  if (!fs.existsSync(FILE_PATH)) {
    console.error('❌ output_video.mp4 not found');
    process.exit(1);
  }

  const form = new FormData();
  form.append('file', fs.createReadStream(FILE_PATH));

  try {
    const response = await axios.post('https://file.io', form, {
      headers: form.getHeaders(),
    });

    if (response.data.success) {
      console.log(`✅ File uploaded: ${response.data.link}`);
    } else {
      console.error('❌ Upload failed:', response.data);
    }
  } catch (err) {
    console.error('❌ Error uploading file:', err.message);
  }
}

uploadFile();
