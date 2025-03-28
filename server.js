const express = require("express");
const os = require("os");
const app = express();

const PORT = 3000;
const VERSION = process.env.APP_VERSION;

app.get("/", (req, res) => {
    const hostname = os.hostname();
    const ip = Object.values(os.networkInterfaces())
        .flat()
        .filter((iface) => iface.family === "IPv4" && !iface.internal)
        .map((iface) => iface.address)[0] || "Unknown";

    res.send(`Server IP: ${ip}<br>Hostname: ${hostname}<br>Version: ${VERSION}`);
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
