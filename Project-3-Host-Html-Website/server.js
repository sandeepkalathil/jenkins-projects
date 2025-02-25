const express = require('express');
const app = express();

app.use(express.static(__dirname));

const PORT = 8020;
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
