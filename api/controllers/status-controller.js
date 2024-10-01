const { statusService } = require("../services")

const getStatus = (req, res) => {
    const status = statusService.serverStatus();
    res.send(status);
}

module.exports = {
    getStatus
}