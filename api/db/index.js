const sql = require('mssql')

const queryDatabase = async (query) => {
    try {
        await sql.connect(process.env.MEDIA_APP_DATABASE_CONNECTION_STRING);
        // console.log("DB connected");
        const result = await sql.query(query);
        return result;
    }
    catch(error) {
        console.log("Error conencting to database: ", error);
    }
}

module.exports = {
    queryDatabase
}